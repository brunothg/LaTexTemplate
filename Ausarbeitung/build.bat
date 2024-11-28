@echo off
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


pdflatex -shell-escape "%DOC_NAME%.tex"
pdflatex -shell-escape "%DOC_NAME%.tex"
biber "%DOC_NAME%"
pdflatex -shell-escape "%DOC_NAME%.tex"
pdflatex -shell-escape "%DOC_NAME%.tex"
makeglossaries "%DOC_NAME%"
pdflatex -shell-escape "%DOC_NAME%.tex"
pdflatex -shell-escape "%DOC_NAME%.tex"