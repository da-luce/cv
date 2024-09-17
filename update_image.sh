# Convert PDF to PNG
# FIXME: name of pdf shouldn't be magic
magick \
    -density 300 \
    ./assets/dalton_luce_cv.pdf \
    -quality 100 \
    -flatten \
    -sharpen 0x1.0 \
    ./assets/cv.png

magick \
    -density 300 \
    ./assets/cover_letter.pdf \
    -quality 100 \
    -flatten \
    -sharpen 0x1.0 \
    ./assets/cover_letter.png
