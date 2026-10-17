@echo off
setlocal
cd /d "%~dp0"
py -m pytest -q --cov=simple_pdf_reader --cov-branch --cov-report=term-missing --cov-fail-under=100
pause
