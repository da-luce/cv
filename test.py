from pypdf import PdfReader
from spellchecker import SpellChecker
from pathlib import Path
import re
import pytest

# ---------- Configuration ----------
PDF_PATH = Path("artifacts/dalton_luce_cv.pdf")
TEX_PATH = Path("cv.tex")

# Custom words to ignore in spellcheck
CUSTOM_WORDS = {
    "tailwind", "github", "lambda", "s3", "msk", "step", "functions",
    "ci/cd", "terraform", "cloudformation", "clearcase", "node.js",
    "ros", "verilog", "groovy", "java", "c++", "javascript", "typescript",
    "svelte", "docker", "jenkins", "grafana", "opencv", "autobike",
    "linkedin", "daltonluce.com", "nix", "ntp", "ieee", "hkn", "cv",
}

# ---------- PDF Tests ----------
def test_pdf_exists():
    assert PDF_PATH.is_file(), f"CV PDF not found at {PDF_PATH}"

def test_pdf_page_count():
    pdf = PdfReader("artifacts/dalton_luce_cv.pdf")
    assert len(pdf.pages) <= 1, f"CV is {len(pdf.pages)} pages (should be ≤1 page)"

# ---------- LaTeX Spellcheck ----------
def test_tex_spellcheck():
    assert TEX_PATH.is_file(), f".tex file not found at {TEX_PATH}"

    with open(TEX_PATH, "r", encoding="utf-8") as f:
        tex_content = f.read()

    spell = SpellChecker()
    spell.word_frequency.load_words(CUSTOM_WORDS)

    misspelled = spell.unknown(tex_content)
    assert not misspelled, f"Spelling errors found: {misspelled}"
