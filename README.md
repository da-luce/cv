# 📄 CV

My Curriculum Vitae (CV) and a cover letter template written using LaTeX.

## Building

> [!NOTE]
> Requires `pdflatex` and `imagemagick` (for image generation).

1. Install dependencies:

    ```shell
    make install
    ```

    ```shell
    source .venv/bin/activate
    ````

2. Build all outputs

    ```shell
    # Build everything (CV + cover letter + images)
    make all
    ```

    To view other available targets, run `make help`.

## Screenshots

### Curriculum Vitae

![CV Image](./dist/images/cv.png)

### Cover Letter

![Cover Letter Image](./dist/images/cover_letter.png)

## To be Implemented

- [ ] GitHub action to only generate new PDFs/Images on `main` to reduce repo size
- [x] A more standard build process that works on any OS (✅ Makefile added)
- [x] Migrate from requirements.txt to pyproject.toml for Python dependencies
