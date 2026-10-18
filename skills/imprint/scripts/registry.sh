#!/bin/sh
# registry.sh — mechanical checks and migration of the UI registry. Part of the aerial33 /imprint skill.
# No project path is hardcoded: the caller passes the paths declared in the project's CLAUDE.md §4.
# Run it from the project root (the `File:` paths of the entries are checked from there).
#
# Usage:
#   registry.sh check  MAIN ENTRIES [DECISIONS]   hygiene report of a two-file registry (writes nothing)
#   registry.sh split  SINGLE MAIN ENTRIES [MAIN_TEMPLATE ENTRIES_TEMPLATE]
#                                                 single-file registry -> two files, form only, then verify
#   registry.sh verify SINGLE MAIN ENTRIES        nothing lost or added by split (besides allowed removals)
#
# Allowed removals in split: table rows whose class is empty (none / —), the "Token-compliant?" column
# (a bare "yes" disappears, any other text moves into the class cell), "**Token violations:** none" lines,
# the parenthesis after a "Last updated:" date, the old header and the "## Entrées/Entries" wrapper.
# Perl is used for character counts: macOS awk counts bytes, not accented characters.

[ "$#" -lt 3 ] && { sed -n '4,12p' "$0" >&2; exit 2; }
command -v perl >/dev/null 2>&1 || { echo "!! perl not found" >&2; exit 2; }

PERL_CODE=$(cat <<'PERLEOF'
use strict; use warnings; use utf8;
binmode STDOUT, ':encoding(UTF-8)'; binmode STDERR, ':encoding(UTF-8)';
@ARGV = map { utf8::decode(my $x = $_); $x } @ARGV;
my ($cmd, @a) = @ARGV;
my $INDEX_MAX = 160; my $MAIN_MAX = 10240; my $NOTES_MAX = 10;

my $MAIN_HEADER = <<'H';
# UI Registry

> Couche **État** — design system de fait, écrit par `/imprint` (format défini par le skill).
> **Lu en entier** pour toute tâche d'interface : Index, Baseline, règles transverses. Reste sous 10 Ko.
> Les entrées des composants sont dans `ui-registry-entries.md` : ne jamais lire ce fichier en entier.
> Une entrée se lit à la demande : `grep -n '^### <Nom>' context/state/ui-registry-entries.md`, puis
> environ 40 lignes à partir de la ligne trouvée (Read `offset`/`limit`, ou `sed -n 'N,+40p'`).
H
my $ENTRIES_HEADER = <<'H';
# UI Registry — entrées

> Couche **État** — une entrée `### <Nom>` par composant, écrite par `/imprint` (format défini par le
> skill), rangée sous `## <Famille>` dans l'ordre de l'Index de `ui-registry.md`.
> **Ne jamais lire ce fichier en entier.** Une entrée : `grep -n '^### <Nom>' context/state/ui-registry-entries.md`,
> puis environ 40 lignes à partir de la ligne trouvée (Read `offset`/`limit`, ou `sed -n 'N,+40p'`).
> Index, Baseline et règles transverses : `ui-registry.md`. Aucune section transverse ici.
H

sub slurp { my $f = shift; open(my $h, '<:encoding(UTF-8)', $f) or die "!! not found: $f\n";
  local $/; my $t = <$h>; close $h; $t =~ s/\r\n/\n/g; $t =~ s/\n+\z//; return split /\n/, $t, -1; }
sub spit { my ($f, $t) = @_; open(my $h, '>:encoding(UTF-8)', $f) or die "!! cannot write: $f\n"; print $h $t; close $h; }
sub header_of { my $f = shift; return undef unless defined $f && -f $f; my @h;
  for (slurp($f)) { last if /^## /; push @h, $_ } pop @h while @h && $h[-1] =~ /^\s*$/; return join("\n", @h) . "\n"; }
sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s; }
sub cells { my $l = shift; $l =~ s/^\s*\|//; $l =~ s/\|\s*$//; return map { trim($_) } split /(?<!\\)\|/, $l, -1; }
sub is_row { $_[0] =~ /^\s*\|.*\|\s*$/ }
sub is_sep { my @c = @_; return @c && !grep { !/^:?-+:?$/ } @c; }
sub empty_cell { $_[0] =~ /^(none|aucun|aucune|—|–|-|n\/a|)$/i }
sub unwrap { my $s = shift; return $s unless $s =~ /^\((.*)\)$/s; my $in = $1; my $d = 0;
  for my $ch (split //, $in) { $d++ if $ch eq '('; $d-- if $ch eq ')'; return $s if $d < 0 } return $d == 0 ? $in : $s; }
sub compliance_rest { my $r = trim(shift);
  $r =~ s/^yes\b\s*//i; $r =~ s/\s*[·\/;,]\s*yes\s*$//i; $r =~ s/^[·\/;:,]\s*//; $r = trim($r);
  return '' if $r =~ /^(—|–|-|)$/; return unwrap($r); }

# One entry line in the old format -> new form (undef = removed). $log collects what changed.
sub transform { my ($l, $st, $log, $name) = @_;
  if (is_row($l)) { my @c = cells($l);
    if (@c == 3 && $c[2] =~ /token/i && $c[0] =~ /propert/i) { $st->{old} = 1; return '| Property | Class |'; }
    if ($st->{old} && @c == 3 && is_sep(@c)) { return '| -------- | ----- |'; }
    if ($st->{old} && @c == 3) {
      if (empty_cell($c[1])) { $log->{rows}++; return undef; }
      my $r = compliance_rest($c[2]);
      if ($r ne '') { push @{$log->{moved}}, "$name — $c[0] : « $c[2] » → « $c[1] — $r »"; return "| $c[0] | $c[1] — $r |"; }
      return "| $c[0] | $c[1] |"; }
    return $l; }
  $st->{old} = 0;
  if ($l =~ /^\*\*Token violations:\*\*\s*(none|aucune?)\.?\s*$/i) { $log->{tv}++; return undef; }
  if ($l =~ /^(Last updated:\s*\d{4}-\d{2}-\d{2})\s*\((.*)\)\s*$/) { push @{$log->{lu}}, "$name — ($2)"; return $1; }
  return $l; }

# Parse a single-file registry into preamble, ## sections (non-entry lines) and ### entries (blocks with File:).
sub parse_single { my @L = @_; my (@pre, @sec, @ent); my ($cur, $e); my $i = 0;
  while ($i < @L && $L[$i] !~ /^## /) { push @pre, $L[$i]; $i++ }
  for (; $i < @L; $i++) { my $l = $L[$i];
    if ($l =~ /^## (.*)$/) { $e = undef; $cur = { title => $1, lines => [$l], after_entry => scalar(@ent) }; push @sec, $cur; next }
    if ($l =~ /^### (.*)$/) { $e = undef; my $is = 0;
      for my $j ($i + 1 .. ($i + 8 > $#L ? $#L : $i + 8)) { last if $L[$j] =~ /^#{1,3} /; if ($L[$j] =~ /^File:/) { $is = 1; last } }
      if ($is) { $e = { name => trim($1), lines => [$l], in => ($cur ? $cur->{title} : '') }; push @ent, $e; next } }
    if ($e) { push @{$e->{lines}}, $l } elsif ($cur) { push @{$cur->{lines}}, $l } else { push @pre, $l } }
  for my $b (@sec, @ent) { pop @{$b->{lines}} while @{$b->{lines}} && $b->{lines}[-1] =~ /^\s*(---)?\s*$/ }
  return (\@pre, \@sec, \@ent); }

sub index_info { my @lines = @_; my (@names, %fam, @fams); my $f = '';
  for (@lines) { if (/^\*\*([^*]+)\*\*\s*:?\s*$/) { $f = trim($1); push @fams, $f; next }
    if (/^- \*\*(.+?)\*\*/) { push @names, trim($1); $fam{trim($1)} = $f } }
  return (\@names, \%fam, \@fams); }
sub section_lines { my ($title_re, @L) = @_; my (@out, $on);
  for (@L) { if (/^## (.*)$/) { $on = ($1 =~ $title_re) ? 1 : 0; next } push @out, $_ if $on } return @out; }

sub content_lines { # comparable lines of a produced file: no header, blanks, separators, family headings
  my ($fams, @L) = @_; my %f = map { $_ => 1 } @$fams; my @o; my $seen = 0;
  for (@L) { $seen = 1 if /^#{2,3} /; next unless $seen; next if /^\s*(---)?\s*$/; next if /^## (.*)$/ && $f{trim($1)}; push @o, $_ } return @o; }

sub verify { my ($single, $main, $entries) = @_;
  my ($pre, $sec, $ent) = parse_single(slurp($single)); my %log; my @exp;
  for my $s (@$sec) { my @c = grep { !/^\s*(---)?\s*$/ } @{$s->{lines}}; next if @c == 1 && $s->{title} =~ /^(Entr|Compon)/i; push @exp, @c }
  for my $e (@$ent) { my %st; for (@{$e->{lines}}) { my $t = transform($_, \%st, \%log, $e->{name}); push @exp, $t if defined $t && $t !~ /^\s*(---)?\s*$/ } }
  my ($names, $fam, $fams) = index_info(section_lines(qr/^Index/, slurp($main)));
  my @got = (content_lines([], slurp($main)), content_lines($fams, slurp($entries)));
  my %n; $n{$_}++ for @exp; $n{$_}-- for @got;
  my @miss = grep { $n{$_} > 0 } sort keys %n; my @extra = grep { $n{$_} < 0 } sort keys %n;
  print "== verify\n"; if (!@miss && !@extra) { print "OK — same content, only the allowed removals.\n"; return 0 }
  print "!! missing after split:\n", map("  $_\n", @miss) if @miss; print "!! added by split:\n", map("  $_\n", @extra) if @extra; return 1; }

sub split_cmd { my ($single, $main, $entries, $mt, $et) = @_;
  for ($main, $entries) { die "!! exists, not overwritten: $_\n" if -e $_ && $_ ne $single }
  my ($pre, $sec, $ent) = parse_single(slurp($single)); my %log; my (@main_secs, @moved_up, @dropped);
  my ($idx) = grep { $_->{title} =~ /^Index/ } @$sec; my ($base) = grep { $_->{title} =~ /^Baseline/ } @$sec;
  for my $s (@$sec) { my @c = grep { !/^\s*(---)?\s*$/ } @{$s->{lines}};
    if (@c == 1 && $s->{title} =~ /^(Entr|Compon)/i) { push @dropped, $s->{title}; next }
    push @moved_up, $s->{title} if $s->{after_entry} > 0 && $s != ($idx // 0) && $s != ($base // 0); }
  my @order = grep { defined } ($idx, $base); push @order, grep { my $s = $_; !grep { $_ == $s } @order } grep { my $t = $_->{title}; !grep { $_ eq $t } @dropped } @$sec;
  my ($names, $fam, $fams) = index_info($idx ? @{$idx->{lines}} : ());
  my %pos; @pos{@$names} = 0 .. $#$names; my @sorted = sort { ($pos{$a->{name}} // 1e9) <=> ($pos{$b->{name}} // 1e9) } @$ent;
  my @noidx = map { $_->{name} } grep { !exists $pos{$_->{name}} } @$ent;
  my @eout; my $lastf = '';
  for my $e (@sorted) { my $f = $fam->{$e->{name}} // '';
    if (@$fams && $f ne $lastf) { push @eout, "## $f", ''; $lastf = $f }
    my %st; my @t; for (@{$e->{lines}}) { my $x = transform($_, \%st, \%log, $e->{name}); push @t, $x if defined $x } push @eout, @t, '' }
  my $mh = header_of($mt) // $MAIN_HEADER; my $eh = header_of($et) // $ENTRIES_HEADER;
  spit($main, $mh . "\n" . join("\n\n", map { join("\n", @{$_->{lines}}) } @order) . "\n");
  pop @eout while @eout && $eout[-1] eq ''; spit($entries, $eh . "\n" . join("\n", @eout) . "\n");
  print "== split\n", "main:    $main (", -s $main, " bytes)\n", "entries: $entries (", -s $entries, " bytes, ", scalar(@$ent), " entries)\n";
  print "header replaced in both files (reading rule)\n";
  print "wrapper removed: $_\n" for @dropped;
  print "section moved up to the main file (it sat between entries): $_\n" for @moved_up;
  print "entries reordered as the Index\n";
  print "entry without Index line (kept at the end): $_\n" for @noidx;
  printf "table rows removed (empty class): %d · \"Token violations: none\" lines removed: %d\n", $log{rows} // 0, $log{tv} // 0;
  print "compliance text kept in the class cell:\n", map("  $_\n", @{$log{moved} // []}) if $log{moved};
  print "Last updated parenthesis removed (history):\n", map("  $_\n", @{$log{lu} // []}) if $log{lu};
  print "no family labels in the Index: add them at the hygiene step\n" unless @$fams;
  return verify($single, $main, $entries); }

sub check_cmd { my ($main, $entries, $dec) = @_; my @M = slurp($main); my @E = slurp($entries); my $n = 0;
  my $say = sub { print "  $_[0]\n"; $n++ };
  my $dect = defined $dec && -f $dec ? join("\n", slurp($dec)) : undef;
  my $dcount = sub { my $id = shift; return '' unless defined $dect; my $c = () = $dect =~ /\Q$id\E/g; return " (decisions: $c)" };
  print "== main file\n"; my $sz = -s $main; printf "  %d bytes%s\n", $sz, $sz > $MAIN_MAX ? "  !! over $MAIN_MAX" : ''; $n++ if $sz > $MAIN_MAX;
  my @titles = map { /^## (.*)$/ ? trim($1) : () } @M;
  $say->("first section is not Index: $titles[0]") if @titles && $titles[0] !~ /^Index/;
  $say->("second section is not Baseline: " . ($titles[1] // 'none')) if @titles > 1 && $titles[1] !~ /^Baseline/;
  my @b = grep { /^Baseline/ } @titles; $say->("several Baseline sections: " . join(' | ', @b)) if @b > 1;
  my $after = 0; for (@titles) { $after = 1 if /^Baseline/; $say->("possible Baseline override: § $_") if $after && /correct|complément|addendum|mise à jour|update|amend|rectif/i && !/^Baseline/ }
  for my $i (0 .. $#M) { $say->("entry in the main file (line " . ($i + 1) . "): $M[$i]") if $M[$i] =~ /^### / && grep { defined $M[$_] && $M[$_] =~ /^File:/ } $i + 1 .. $i + 6 }
  my @IL = section_lines(qr/^Index/, @M); my ($names, $fam, $fams) = index_info(@IL);
  for (@IL) { next unless /^- /; my $len = length($_); $say->("Index line $len chars > $INDEX_MAX: " . substr($_, 0, 60) . "…") if $len > $INDEX_MAX }
  $say->("no family labels in the Index (**Family** lines)") unless @$fams;
  print "== entries\n"; my (@ent, $e);
  for my $i (0 .. $#E) { my $l = $E[$i];
    if ($l =~ /^### (.*)$/) { $e = { name => trim($1), line => $i + 1, lines => [] }; push @ent, $e; next }
    if ($l =~ /^## (.*)$/) { $e = undef; my $t = trim($1); $say->("section in the entries file that is not an Index family: § $t (line " . ($i + 1) . ")") unless grep { $_ eq $t } @$fams; next }
    push @{$e->{lines}}, [$i + 1, $l] if $e; }
  my %in = map { $_ => 1 } @$names; my %has = map { $_->{name} => 1 } @ent;
  $say->("entry without Index line: $_->{name}") for grep { !$in{$_->{name}} } @ent;
  $say->("Index line without entry: $_") for grep { !$has{$_} } @$names;
  my @eo = grep { $in{$_} } map { $_->{name} } @ent; my @io = grep { $has{$_} } @$names;
  for my $k (0 .. $#eo) { if ($eo[$k] ne $io[$k]) { $say->("entries not in Index order (first difference: $eo[$k], Index expects $io[$k])"); last } }
  my %sent; my $hist = qr/\b[A-Z]\d{2}(?:\.\d+)?\b|jalon|revue d[ue]|décision du|décidé le|\b20\d\d-\d\d-\d\d\b/i;
  my $open = qr/à trancher|à revoir|à régler|provisoire|risque|open questions|tracker|TODO|TBD/i;
  my $logic = qr/\brequête|\bquery\b|\bwhere\b|overrideAccess|\baccess\b|\bfind\(|validation|validate|getPayload/i;
  for my $x (@ent) { my ($notes, $in_notes, @nl) = (0, 0);
    for my $p (@{$x->{lines}}) { my ($ln, $l) = @$p;
      if ($l =~ /^File:\s*(.*)$/) { for my $path ($1 =~ /`([^`]+)`/g) { next if $path =~ /[*<>{}]/ || $path !~ m{/}; (my $q = $path) =~ s{/$}{}; $say->("$x->{name}: file not found: $path") unless -e $q } }
      if ($l =~ /^Last updated:.*\(/) { $say->("$x->{name} (line $ln): history in Last updated: $l") }
      if (is_row($l)) { my @c = cells($l); $say->("$x->{name} (line $ln): old table format (Token-compliant? column)") if @c == 3 && $c[2] =~ /token/i;
        $say->("$x->{name} (line $ln): empty row: $c[0]") if @c >= 2 && !is_sep(@c) && $c[0] !~ /propert/i && empty_cell($c[1]) }
      if ($l =~ /^\*\*Token violations:\*\*\s*(none|aucune?)\.?\s*$/i) { $say->("$x->{name} (line $ln): \"Token violations: none\" (omit the line)") }
      if ($l =~ /^\*\*Pattern notes:\*\*/) { $in_notes = 1 } elsif ($l =~ /^\*\*Token violations/ || $l =~ /^#{1,4} /) { $in_notes = 0 }
      if ($in_notes && $l =~ /\S/) { $notes++; push @nl, $l;
        for my $m ($l =~ /($hist)/g) { $say->("$x->{name} (line $ln): history « $m »" . ($m =~ /^[A-Z]\d{2}/ ? $dcount->($m) : '')) }
        for my $m ($l =~ /($open)/g) { $say->("$x->{name} (line $ln): open point « $m »") }
        for my $m ($l =~ /($logic)/g) { $say->("$x->{name} (line $ln): logic or data? « $m » (check)") } } }
    $say->("$x->{name}: notes $notes lines > $NOTES_MAX") if $notes > $NOTES_MAX;
    my $txt = join(' ', @nl); $txt =~ s/^\*\*Pattern notes:\*\*\s*//;
    for my $s (split /(?<=[.;:])\s+/, $txt) { (my $k = lc $s) =~ s/\s+/ /g; $k =~ s/[.;:,\s]+$//; next if length($k) < 50; $sent{$k}{$x->{name}} = 1 } }
  for my $k (sort keys %sent) { my @w = sort keys %{$sent{$k}}; $say->("same sentence in " . join(', ', @w) . ": « " . substr($k, 0, 90) . "… »") if @w > 1 }
  printf "== %d entries, %d findings (judge: already settled in decisions? rule shared by 2+ entries?)\n", scalar(@ent), $n; return 0; }

if ($cmd eq 'check') { exit check_cmd(@a) } elsif ($cmd eq 'split') { exit split_cmd(@a) } elsif ($cmd eq 'verify') { exit verify(@a) }
die "!! unknown command: $cmd\n";
PERLEOF
)
exec perl -e "$PERL_CODE" -- "$@"
