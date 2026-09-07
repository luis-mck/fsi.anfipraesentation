#! /bin/sh

# ⚠ This script requires qpdf ⚠

wget https://teri.fsi.uni-tuebingen.de/anfiheft/anfiheft-info.pdf
qpdf anfiheft-info.pdf --pages . 1-1 -- erstiheft-info.pdf
rm anfiheft-info.pdf anfiheft-info.pdf.1

wget https://teri.fsi.uni-tuebingen.de/anfiheft/anfiheft-kogni.pdf
qpdf anfiheft-kogni.pdf --pages . 1-1 -- erstiheft-kogni.pdf
rm anfiheft-kogni.pdf anfiheft-kogni.pdf.1