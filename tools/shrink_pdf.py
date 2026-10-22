# 요약 PDF의 그림을 96dpi JPEG(품질 80)로 다시 넣어 용량을 줄인다(약 14MB → 1MB).
#   python3 tools/shrink_pdf.py assets/pdf/edgerunners_summary.pdf   (PyMuPDF 1.24 이상)
import os, sys, pymupdf
src = sys.argv[1]
tmp = src + ".tmp"
d = pymupdf.open(src)
d.rewrite_images(dpi_threshold=100, dpi_target=96, quality=80)
d.save(tmp, garbage=4, deflate=True)
d.close()
os.replace(tmp, src)
print(src, os.path.getsize(src) // 1024, "KB")
