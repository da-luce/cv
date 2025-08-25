# Convert PDF to PNG
# FIXME: name of pdf shouldn't be magic
magick \
    -density 300 \
    ./artifacts/dalton_luce_cv.pdf \
    -quality 100 \
    -flatten \
    -sharpen 0x1.0 \
    ./artifacts/cv.png

magick \
    -density 300 \
    ./artifacts/cover_letter.pdf \
    -quality 100 \
    -flatten \
    -sharpen 0x1.0 \
    ./artifacts/cover_letter.png
