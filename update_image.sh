# Remake pdf
./make.sh

# Convert PDF to PNG
# FIXME: name of pdf shouldn't be magic
magick \
    -density 300 \
    dalton_luce_cv.pdf \
    -quality 100 \
    -flatten \
    -sharpen 0x1.0 \
    ./assets/cv.png

# Add new image to the commit
git add ./assets/cv.png
