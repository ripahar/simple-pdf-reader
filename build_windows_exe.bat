@echo off
setlocal
cd /d "%~dp0"
echo Installing build dependencies...
py -m pip install --upgrade pip
if errorlevel 1 goto error
py -m pip install -r requirements.txt pyinstaller
if errorlevel 1 goto error
echo.
echo Building SimplePDFReader.exe...
py -m PyInstaller --noconfirm --clean --onefile --windowed --collect-all pdf2docx --collect-all docx --name SimplePDFReader simple_pdf_reader.py
if errorlevel 1 goto error
echo.
echo SUCCESS! Your executable is here:
echo %CD%\dist\SimplePDFReader.exe
echo.
pause
exit /b 0
:error
echo.
echo BUILD FAILED. Check the error messages above.
pause
exit /b 1
