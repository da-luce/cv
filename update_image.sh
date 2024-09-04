# Remake pdfs
./make.sh
pdflatex cover_letter.tex

# Convert PDF to PNG
# FIXME: name of pdf shouldn't be magic
magick \
    -density 300 \
    dalton_luce_cv.pdf \
    -quality 100 \
    -flatten \
    -sharpen 0x1.0 \
    ./assets/cv.png

magick \
    -density 300 \
    cover_letter.pdf \
    -quality 100 \
    -flatten \
    -sharpen 0x1.0 \
    ./assets/cover_letter.png

# Add new images to the commit
git add ./assets/cv.png
git add ./assets/cover_letter.png
