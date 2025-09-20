.PHONY: all clean build private cover-letter images help install test release

# Default target
all: build images

# Variables
BUILD_DIR := build
DIST_DIR := dist
SRC_DIR := src
PDF_DIR := $(DIST_DIR)/pdfs
IMG_DIR := $(DIST_DIR)/images
CV_NAME := dalton_luce_cv
COVER_LETTER_NAME := cover_letter
S3_BUCKET := dalton-cv-artifacts
AWS_REGION := us-east-1

# These are GitHub Camo image proxy URLs.
# To obtain them: paste the raw S3 image link into a GitHub Markdown file (README, issue, etc.),
# let GitHub render it, then right-click → "Copy image address".
CV_GITHUB_CACHE_URL:= https://camo.githubusercontent.com/19e0bf2e0d1d9b58f0bd2a4bf66b214f817d5ae7e72ff4e3684b8b15522be23f/68747470733a2f2f64616c746f6e2d63762d6172746966616374732e73332e75732d656173742d312e616d617a6f6e6177732e636f6d2f696d616765732f63762e706e67
COVER_GITHUB_CACHE_URL:= https://camo.githubusercontent.com/31c147493e3d013bd48fcbeda87b802e2a8012a64faf6dc324f640ba7eec4f24/68747470733a2f2f64616c746f6e2d63762d6172746966616374732e73332e75732d656173742d312e616d617a6f6e6177732e636f6d2f696d616765732f636f7665725f6c65747465722e706e67

# Help target
help:
	@echo "Available targets:"
	@echo "  all            - Build CV and cover letter, then generate images"
	@echo "  build          - Build public version of the CV"
	@echo "  private        - Build private version of the CV"
	@echo "  cover-letter   - Build the cover letter PDF"
	@echo "  images         - Generate PNG images from PDFs using ImageMagick"
	@echo "  clean          - Remove all build and distribution artifacts"
	@echo "  install        - Install Python dependencies (not defined here)"
	@echo "  test           - Run cvlint on the generated CV PDF"
	@echo "  release        - Upload PDFs and images to S3, purge GitHub Camo cache"

# Create necessary directories
$(PDF_DIR) $(IMG_DIR):
	mkdir -p $@

# Build public CV
build: $(PDF_DIR) cover-letter
	mkdir -p $(PDF_DIR)
	pdflatex -output-directory=$(BUILD_DIR) -jobname=$(CV_NAME) $(SRC_DIR)/$(CV_NAME).tex
	cp $(BUILD_DIR)/$(CV_NAME).pdf $(PDF_DIR)

# Build private CV
private: $(PDF_DIR)
	mkdir -p $(BUILD_DIR)
	pdflatex -output-directory=$(BUILD_DIR) -jobname=$(CV_NAME) "\def\\private{} \input{$(SRC_DIR)/$(CV_NAME).tex}"
	cp $(BUILD_DIR)/$(CV_NAME).pdf $(PDF_DIR)

# Build cover letter
cover-letter: $(PDF_DIR)
	mkdir -p $(BUILD_DIR)
	pdflatex -output-directory=$(BUILD_DIR) -jobname=cover_letter $(SRC_DIR)/$(COVER_LETTER_NAME).tex
	cp $(BUILD_DIR)/$(COVER_LETTER_NAME).pdf $(PDF_DIR)

# Generate images from PDFs
images: $(IMG_DIR)
	@if command -v convert >/dev/null 2>&1; then \
		magick -density 300 $(DIST_DIR)/pdfs/dalton_luce_cv.pdf -quality 100 -flatten -sharpen 0x1.0 $(IMG_DIR)/$(CV_NAME).png; \
		magick -density 300 $(DIST_DIR)/pdfs/cover_letter.pdf -quality 100 -flatten -sharpen 0x1.0 $(IMG_DIR)/$(COVER_LETTER_NAME).png; \
	else \
		echo "Imageconvert not found. Please install Imageconvert to generate images."; \
	fi

# Clean build directory
clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR)

# Run tests
test:
	@if ! command -v cvlint >/dev/null 2>&1; then \
		echo "Error: cvlint is not installed or not in PATH."; \
		echo "Please install cvlint by following instructions at https://github.com/da-luce/cvlint"; \
		exit 1; \
	fi
	cvlint check $(PDF_DIR)/$(CV_NAME).pdf

release:
	aws s3 cp $(PDF_DIR)/ s3://$(S3_BUCKET)/pdfs/ --recursive --region $(AWS_REGION)
	aws s3 cp $(IMG_DIR)/ s3://$(S3_BUCKET)/images/ --recursive --region $(AWS_REGION)
	# Purge GitHub Camo image cache, so updated images show up in README immediately
	curl -X PURGE "$(CV_GITHUB_CACHE_URL)"
	curl -X PURGE "$(COVER_GITHUB_CACHE_URL)"

enter:
	docker run --rm -it -v "$$(pwd)":/cv -w /cv daluce/cv:latest /bin/bash
