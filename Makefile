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
S3_BUCKET_PREFIX := dalton-cv-artifacts/cv
AWS_REGION := us-east-1

CACHE_CONTROL := public, max-age=300

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
	@echo "  release        - Upload PDFs and images to S3"

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
		magick -density 300 $(DIST_DIR)/pdfs/$(CV_NAME).pdf -quality 100 -flatten -sharpen 0x1.0 $(IMG_DIR)/$(CV_NAME).png; \
		magick -density 300 $(DIST_DIR)/pdfs/$(COVER_LETTER_NAME).pdf -quality 100 -flatten -sharpen 0x1.0 $(IMG_DIR)/$(COVER_LETTER_NAME).png; \
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

# IMPORTANT: artifacts must be uploaded under the 'cv/' prefix
release:
	aws s3 cp $(PDF_DIR)/ s3://$(S3_BUCKET_PREFIX)/pdfs/ --recursive --region $(AWS_REGION) --cache-control "$(CACHE_CONTROL)"
	aws s3 cp $(IMG_DIR)/ s3://$(S3_BUCKET_PREFIX)/images/ --recursive --region $(AWS_REGION) --cache-control "$(CACHE_CONTROL)"

enter:
	docker run --rm -it --pull always -v "$$(pwd)":/cv -w /cv daluce/cv:latest /bin/bash
