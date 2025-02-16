:: Sources:
:: https://developers.google.com/speed/webp/download
:: https://developers.google.com/speed/webp/docs/using
:: https://web.dev/articles/serve-images-webp
:: http://downloads.webmproject.org/releases/webp/index.html
:: Download and unzip it copy/move the folder to ProgramFiles and;
:: Add this to PATH: %ProgramFiles%\cwebp\bin // if copied to that folder
clear
@cls
@echo THIS BAT-FILE CONVERTS AN IMAGE IN IMAGES-FOLDER TO WEBP
@echo (If you have installed the cwebp and added the path to the bin-file.)
@echo ---
@echo (1) Put all the images you want to convert into the images-folder.
@echo (2) And push a button when you are ready (to start the converting-process).
@echo ---
@echo (NB) The converted file will be placed in webp-folder:)
@echo (NB) "Ctrl C" exits the loop
@echo ---
@setlocal enableextensions enabledelayedexpansion
@echo off
:x
echo - What is the name of the imagefile?
set /p input= Ex: image-name.jpg: 
set variable=%input%
echo !variable!
if "x!variable:~-4!"=="x.jpg" (
    set variable=!variable:~0,-4!
)
echo !variable!
cwebp -q 50 convert/original-format/%input% -o convert/webp/!variable!.webp
goto x
endlocal
