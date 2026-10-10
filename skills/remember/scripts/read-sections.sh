#!/bin/sh
# read-sections.sh — print the context files and sections a /remember restore declares, in ONE call,
# without line numbers. Part of the aerial33 /remember skill. No project path is hardcoded: the caller
# builds the arguments from the project's CLAUDE.md.
#
# Usage: read-sections.sh SPEC [SPEC...]
#   SPEC = path                  whole file
#        | path#Name             the section whose heading text starts with "Name"
#        | path#Name1|Name2      several sections of the same file (quote the argument)
# A section runs from its heading to the next heading of the same or a higher level, or to a "---" line.
# Sub-headings (###…) stay inside their section. A missing file or section is reported, never silent.

[ "$#" -eq 0 ] && { echo "usage: read-sections.sh path[#Section[|Section]] ..." >&2; exit 2; }
status=0
for spec in "$@"; do
  case "$spec" in
    *#*) file=${spec%%#*}; names=${spec#*#} ;;
    *)   file=$spec; names= ;;
  esac
  if [ ! -f "$file" ]; then
    echo "!! not found: $file"; echo; status=1; continue
  fi
  if [ -z "$names" ]; then
    echo "===== $file ====="; cat "$file"; echo; continue
  fi
  echo "===== $file # $names ====="
  awk -v names="$names" '
    BEGIN { n = split(names, want, "|"); for (i = 1; i <= n; i++) found[i] = 0 }
    function level(s,   k) { k = 0; while (substr(s, k + 1, 1) == "#") k++; return k }
    /^#+ / {
      lv = level($0); text = substr($0, lv + 2)
      if (on && lv <= onlv) on = 0
      if (!on) for (i = 1; i <= n; i++) if (index(text, want[i]) == 1) { on = 1; onlv = lv; found[i] = 1 }
    }
    /^---[ \t]*$/ { if (on) { on = 0; next } }
    on { print }
    END { for (i = 1; i <= n; i++) if (!found[i]) { print "!! section not found: " want[i]; miss = 1 }
          exit miss }
  ' "$file" || status=1
  echo
done
exit $status
