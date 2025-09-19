.PHONY: all clean build private cover-letter images help install test

# Default target
all: build images

# Variables
BUILD_DIR := build
DIST_DIR := dist
SRC_DIR := src

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Build CV and cover letter, generate images"
	@echo "  build        - Build CV (public version)"
	@echo "  private      - Build CV (private version)"
	@echo "  cover-letter - Build cover letter only"
	@echo "  images       - Generate PNG images from PDFs"
	@echo "  clean        - Remove build directory"
	@echo "  install      - Install Python dependencies"
	@echo "  test         - Run tests"

# Create necessary directories
$(DIST_DIR)/pdfs $(DIST_DIR)/images:
	mkdir -p $@

# Build public CV
build: $(DIST_DIR)/pdfs cover-letter
	mkdir -p $(BUILD_DIR)
	pdflatex -output-directory=$(BUILD_DIR) -jobname=dalton_luce_cv $(SRC_DIR)/cv.tex
	cp $(BUILD_DIR)/dalton_luce_cv.pdf $(DIST_DIR)/pdfs/

# Build private CV
private: $(DIST_DIR)/pdfs
	mkdir -p $(BUILD_DIR)
	pdflatex -output-directory=$(BUILD_DIR) -jobname=dalton_luce_cv '\def\private{} \input{$(SRC_DIR)/cv.tex}'
	cp $(BUILD_DIR)/dalton_luce_cv.pdf $(DIST_DIR)/pdfs/

# Build cover letter
cover-letter: $(DIST_DIR)/pdfs
	mkdir -p $(BUILD_DIR)
	pdflatex -output-directory=$(BUILD_DIR) -jobname=cover_letter $(SRC_DIR)/cover_letter.tex
	cp $(BUILD_DIR)/cover_letter.pdf $(DIST_DIR)/pdfs/

# Generate images from PDFs
# FIXME: currently using deprecated "convert" since ubuntu GitHub runners only have access to IMv6
images: $(DIST_DIR)/images
	@if command -v convert >/dev/null 2>&1; then \
		convert -density 300 $(DIST_DIR)/pdfs/dalton_luce_cv.pdf -quality 100 -flatten -sharpen 0x1.0 $(DIST_DIR)/images/cv.png; \
		convert -density 300 $(DIST_DIR)/pdfs/cover_letter.pdf -quality 100 -flatten -sharpen 0x1.0 $(DIST_DIR)/images/cover_letter.png; \
	else \
		echo "Imageconvert not found. Please install Imageconvert to generate images."; \
	fi

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)

# Run tests
test:
	# See https://github.com/da-luce/cvlint
	cvlint check dist/pdfs/dalton_luce_cv.pdf
