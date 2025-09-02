# 📄 CV

My [Curriculum Vitae](https://en.wikipedia.org/wiki/Curriculum_vitae) (CV) and cover letter template, written in $\LaTeX$ ([learn more](https://www.latex-project.org/)).

## Files

### Curriculum Vitae

**[⬇️ Download CV PDF](https://dalton-cv.s3.us-east-1.amazonaws.com/pdfs/dalton_luce_cv.pdf)**

![CV Image](https://dalton-cv.s3.us-east-1.amazonaws.com/images/cv.png)

### Cover Letter

![Cover Letter Image](https://dalton-cv.s3.us-east-1.amazonaws.com/images/cover_letter.png)

## Building

> [!NOTE]
> Requires `pdflatex` and `imagemagick` (for image generation). On macOS, you can install them with:
>
> ```shell
> brew install basictex imagemagick
> ```
>
> Then reload your terminal to ensure the binaries are in your PATH.

1. Install Python dependencies for testing:

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

> [!NOTE]
> The Makefile builds PDFs and images locally. PDFs and images are uploaded to an [S3](https://aws.amazon.com/s3/) bucket via a [GitHub Action](./.github/workflows/deploy.yml) for easy access.  Storage cost is extremely low: for a 2 MB resume and cover letter, it would be just over a cent for three **years**.

## To be Implemented

* [ ] Improve testing and add to `deploy.yml` action
* [ ] Add Terraform template for AWS setup
* [x] Add details on AWS usage in README
* [x] GitHub action to only generate new PDFs/Images on `main` to reduce repo size
* [x] A more standard build process that works on any OS (✅ Makefile added)
* [x] Migrate from requirements.txt to pyproject.toml for Python dependencies
