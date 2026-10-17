SIMPLE PDF READER (Windows / Python)

Features
- Open PDF files in tabs within one application window; open multiple PDFs at once
- Vertical scrolling and horizontal scrolling when zoomed in
- Zoom buttons, Ctrl + mouse wheel, and Fit width
- Jump to a page number
- Save bookmarks per PDF; bookmarks remain after closing the app
- Add, move, edit, recolor, and delete text overlays
- Save edited PDFs as a new file (original is preserved)
- Export PDFs to editable Word documents (.docx) with images/graphics and reader-added text/signatures included where conversion supports them
- Print via the operating system's default PDF handler/viewer
- Select and copy embedded text from the current page in a separate text window
- File and Edit menus; zoom/page/bookmark toolbar stays in place

Setup
1. Install Python 3.10 or newer from https://www.python.org/downloads/
   During installation, enable "Add Python to PATH".
2. Open Command Prompt in this folder.
3. Run:
      python -m pip install -r requirements.txt
4. Start the reader:
      python simple_pdf_reader.py
5. To open a PDF immediately from Command Prompt, pass its path:
      python simple_pdf_reader.py "C:\Users\YourName\Documents\sample.pdf"
6. To build the Windows EXE, double-click build_windows_exe.bat. The executable is created at:
      dist\SimplePDFReader.exe

Windows PDF file association
- The app now reads a PDF path passed on startup, so choosing SimplePDFReader.exe as the
  default app for .pdf files should open the clicked PDF automatically.
- When Windows asks for the app command, the file path must be passed as an argument
  (normally Windows does this automatically when you select the EXE in Open with).
- Rebuild the EXE after updating the source; replacing only the .py file will not update
  an already-built executable.

Shortcuts
- Ctrl+O: Open one or more PDFs in tabs
- Ctrl+T: New tab
- Ctrl+W: Close current tab
- Ctrl+Shift+S: Save PDF As
- Ctrl+P: Print/open for printing
- Ctrl + mouse wheel: Zoom in/out

Testing and coverage
1. Install development dependencies:
      python -m pip install -r requirements-dev.txt
2. Run the full test suite with line and branch coverage:
      python -m pytest -q --cov=simple_pdf_reader --cov-branch --cov-report=term-missing --cov-fail-under=100
3. On Windows, you can double-click run_tests.bat to run the same check.

The test suite uses a temporary PDF and exercises the GUI through Tkinter. The standard
if __name__ == "__main__" launcher guard is excluded from the coverage denominator;
main() itself is tested. 100% coverage means all measured statements and branch outcomes
were executed in this environment; it does not guarantee the absence of defects or replace
manual Windows testing for printing and desktop interaction.

Notes and limitations
- Bookmarks are stored in the Windows user folder in:
  .simple_pdf_reader_bookmarks.json
- Added text is an overlay. Existing PDF text is not directly editable in place.
- Existing text can be copied when it is embedded in the PDF. Scanned pages need OCR,
  which is not included.
- On Windows, printing is sent to the default PDF application's print handler. On macOS
  and Linux, the PDF opens in the default viewer so the user can choose Print.
- If you open another PDF while text overlays are unsaved, the app asks before discarding them.
- This is a lightweight starter app, not a full replacement for Adobe Acrobat.

Performance update
- Opening creates lightweight page placeholders before rasterizing pages.
- Visible and nearby pages are rendered incrementally.
- A bounded cache retains up to 8 rendered page images.
- Scrolling schedules nearby pages; zoom rebuilds placeholders and renders only the viewport neighborhood.

Signature feature
- Edit > Insert Signature accepts PNG, JPG/JPEG/JFIF, BMP, WebP, GIF, and TIFF images.
- Imported images are normalized internally to PNG/RGBA, so background transparency is handled consistently.
- Existing transparency in PNG/WebP/GIF images is preserved.
- Optional white/light background removal is available for signatures scanned or photographed on light paper.
- The original image file is not modified; only the copy embedded in the PDF is processed.
- Drag the signature to reposition it.
- Right-click a signature to resize by width while preserving proportions.
- Edit > Delete Selected Signature removes the selected signature.
- Signature images are embedded in saved PDFs and print copies.

Word export (Release 5)
- Use File > Save As Word Document to create an editable .docx file.
- The conversion runs in a background thread so the window remains responsive.
- Added text and signature overlays from the current session are applied to a temporary PDF for export; the source PDF is not changed.
- Pages without selectable text trigger an OCR question. Choose Yes to run OCR, No to continue without OCR, or Cancel to stop.
- Core Word conversion dependencies are installed by requirements.txt (pdf2docx and python-docx).
- Optional OCR: install requirements-ocr.txt and install Tesseract OCR separately, then ensure both OCRmyPDF and Tesseract are available on PATH.
- Headers, footers, page numbers, images, tables, and layout are preserved only as far as the converter can reconstruct them; review complex documents in Word.
- Existing PDF markup annotations that are not represented as reader-added text/signature overlays may not be reconstructed by the converter.

Word export validation: a _conversion_report.txt file is generated beside the DOCX. It flags possible text loss; it does not guarantee visual fidelity or automatically repair complex tables.

Repeated page-top artwork: the Word export now tries to detect visually repeated page headers and preserve them as a Word header image. This is generic and brand-agnostic, but detection is heuristic; verify the output and conversion report.
