#!/bin/sh

# Remove existing PDFs
rm -f ./assets/dalton_luce_cv.pdf ./assets/dalton_luce_cv.aux ./assets/dalton_luce_cv.log ./assets/dalton_luce_cv.out
rm -f ./assets/cover_letter.pdf ./assets/cover_letter.aux ./assets/cover_letter.log ./assets/cover_letter.out

# Make resume
if [ "$1" = "private" ]; then
    pdflatex -jobname=./assets/dalton_luce_cv '\def\private{} \input{cv.tex}'
else
    pdflatex -jobname=./assets/dalton_luce_cv cv.tex
fi

# Make cover letter
pdflatex -jobname=./assets/cover_letter cover_letter.tex
