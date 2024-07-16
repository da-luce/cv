#!/bin/sh

if [ "$1" = "private" ]; then
    pdflatex -jobname=dalton_luce_cv '\def\private{} \input{cv.tex}'
else
    pdflatex -jobname=dalton_luce_cv cv.tex
fi
