#!/bin/sh

BUILD_DIR=./build
ARTIFACTS_DIR=./artifacts

# Create directories if they doesn't exist
mkdir -p "$BUILD_DIR"
mkdir -p "$ARTIFACTS_DIR"

# Make resume
if [ "$1" = "private" ]; then
    pdflatex -output-directory="$BUILD_DIR" -jobname=dalton_luce_cv '\def\private{} \input{cv.tex}'
else
    pdflatex -output-directory="$BUILD_DIR" -jobname=dalton_luce_cv cv.tex
fi

# Make cover letter
pdflatex -output-directory="$BUILD_DIR" -jobname=cover_letter cover_letter.tex

# Copy the generated PDFs to artifacts folder
cp "$BUILD_DIR/dalton_luce_cv.pdf" "$ARTIFACTS_DIR/"
cp "$BUILD_DIR/cover_letter.pdf" "$ARTIFACTS_DIR/"