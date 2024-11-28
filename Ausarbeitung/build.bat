@echo off
setlocal EnableExtensions
setlocal EnableDelayedExpansion
cd %~dp0

set DOC_NAME=Ausarbeitung

pushd figure
FOR %%i IN (*-eps-converted-to.pdf) DO (
	del "%%i" /f /q
)
FOR %%i IN (*.puml) DO (
	set filename=%%i
	set pumlout=!filename:~0,-5!_puml.eps
	
	type "!filename!" | plantuml -pipe -charset UTF-8 -teps > "!pumlout!"
)
popd

rmdir /s /q ".\build"
:tmp_build_loop
set "TMP_BUILD=%tmp%\bat~%RANDOM%.tmp"
if exist "%TMP_BUILD%" goto :tmp_build_loop
xcopy /s /e /i ".\*" "%TMP_BUILD%"
move "%TMP_BUILD%" ".\build"
for /r ".\build" %%f in (*) do del "%%f"

pdflatex -output-directory="build" -shell-escape "%DOC_NAME%.tex"
pdflatex -output-directory="build" -shell-escape "%DOC_NAME%.tex"
biber --output-directory="build" "%DOC_NAME%"
pdflatex -output-directory="build" -shell-escape "%DOC_NAME%.tex"
pdflatex -output-directory="build" -shell-escape "%DOC_NAME%.tex"
makeglossaries -d "build" "%DOC_NAME%"
pdflatex -output-directory="build" -shell-escape "%DOC_NAME%.tex"
pdflatex -output-directory="build" -shell-escape "%DOC_NAME%.tex"