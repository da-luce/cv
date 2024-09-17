#!/bin/sh

if [ "$1" = "private" ]; then
    pdflatex -jobname=./assets/dalton_luce_cv '\def\private{} \input{cv.tex}'
else
    pdflatex -jobname=./assets/dalton_luce_cv cv.tex
fi
