#!/usr/bin/env bash
SCRIPT_PATH="${BASH_SOURCE}"
while [ -L "${SCRIPT_PATH}" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "${SCRIPT_PATH}")" >/dev/null 2>&1 && pwd)"
  SCRIPT_PATH="$(readlink "${SCRIPT_PATH}")"
  [[ ${SCRIPT_PATH} != /* ]] && SCRIPT_PATH="${SCRIPT_DIR}/${SCRIPT_PATH}"
done
SCRIPT_PATH="$(readlink -f "${SCRIPT_PATH}")"
SCRIPT_DIR="$(cd -P "$(dirname -- "${SCRIPT_PATH}")" >/dev/null 2>&1 && pwd)"
cd "$SCRIPT_DIR"

DOC_NAME=Ausarbeitung

(
    cd figure
    rm -f *.eps-converted-to.pdf
    for i in *.puml; do
        [ -f "$i" ] || break
        PUML_OUT=$(echo "$i" | sed -z 's/.\{6\}$//')
        PUML_OUT=${PUML_OUT}"_puml.eps"
        cat "$i" | plantuml -pipe -charset UTF-8 -teps > "$PUML_OUT"
    done
)

rm -rf ./build
find . -type d -not -path "./build" -not -path "./build/*" -exec mkdir -p "build/{}" \;

pdflatex -output-directory="build" -shell-escape "$DOC_NAME.tex"
pdflatex -output-directory="build" -shell-escape "$DOC_NAME.tex"
biber --output-directory="build" "$DOC_NAME"
pdflatex -output-directory="build" -shell-escape "$DOC_NAME.tex"
pdflatex -output-directory="build" -shell-escape "$DOC_NAME.tex"
makeglossaries -d "build" "$DOC_NAME"
pdflatex -output-directory="build" -shell-escape "$DOC_NAME.tex"
pdflatex -output-directory="build" -shell-escape "$DOC_NAME.tex"
