# 📄 CV [![Deploy Resume](https://github.com/da-luce/cv/actions/workflows/deploy.yml/badge.svg)](https://github.com/da-luce/cv/actions/workflows/deploy.yml)

<br>

<p align="center">
  <a href="https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/pdfs/dalton_luce_cv.pdf">
    <img src="https://img.shields.io/badge/📄%20View_PDF-blue?style=for-the-badge&logo=&logoColor=white" alt="View PDF">
  </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/images/cv.png">
    <img src="https://img.shields.io/badge/🌄%20View_PNG-blue?style=for-the-badge&logo=&logoColor=white" alt="View PNG">
  </a>
</p>

<br>

My [Curriculum Vitae](https://en.wikipedia.org/wiki/Curriculum_vitae) (CV) and cover letter template, written in $\LaTeX$ ([learn more](https://www.latex-project.org/)). All artifacts (PDFs and preview images) are automatically built using [GitHub Actions](https://github.com/features/actions) and uploaded to an [AWS S3](https://aws.amazon.com/s3/) bucket. A [Terraform](https://developer.hashicorp.com/terraform) configuration and [instructions](#deploying-artifacts-to-aws) are included below if you want to set it up yourself.

Is it overengineered? _For most, probably yes._ <br>
Is it perfect for automation enthusiasts? _Absolutely._ <br>
Maybe I can convince you to become one too—_[here's why](#why-this-setup)._

## Screenshots

### Curriculum Vitae &nbsp; [![PDF](https://img.shields.io/badge/PDF-blue?style=flat)](https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/pdfs/dalton_luce_cv.pdf)

![CV Image](https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/images/cv.png)

### Cover Letter &nbsp; [![PDF](https://img.shields.io/badge/PDF-blue?style=flat)](https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/pdfs/cover_letter.pdf)

![Cover Letter Image](https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/images/cover_letter.png)

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

## Deploying Artifacts to AWS

Follow these steps to set up your AWS account and configure GitHub Actions for automatic CV deployment.

1. Preview the Terraform changes

    ```bash
    terraform plan
    ```

2. Apply the configuration

    ```bash
    terraform apply
    ```

3. Retrieve the GitHub Actions credentials and bucket name

    ```bash
    # Access Key ID
    terraform output -raw github_actions_access_key_id

    # Secret Access Key
    terraform output -raw github_actions_secret_access_key

    # Bucket name
    terraform output -raw cv_bucket_name
    ```

4. Add the credentials as GitHub repository secrets

   * `AWS_ACCESS_KEY_ID` → value from `github_actions_access_key_id`
   * `AWS_SECRET_ACCESS_KEY` → value from `github_actions_secret_access_key`
   * `AWS_S3_BUCKET` → value from `cv_bucket_name`

5. See it in action

   Once the secrets are added, the provided [workflow](./.github/workflows/deploy.yml) will automatically build your CV PDFs and preview images, then upload them to the configured S3 bucket whenever you push changes to the repository.

> **Note:** S3 storage is extremely cheap—effectively pennies for years of CV and cover letter artifacts.

## Why This Setup?

| Component     | Why?                                                                                                                                                                                                    |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Git**       | Tracks every change in fine detail—much more granular than cloud-hosted solutions like Google Drive. Supports collaboration, safe experimentation, and integrates seamlessly with automation workflows. |
| **LaTeX**     | Produces professional, highly customizable PDFs. Standard in math and engineering fields, and easy to track with Git.                                                                                   |
| **AWS S3**    | Cheap, reliable hosting. Stores the latest PDFs and images outside the repo (avoiding repo bloat) and provides a stable URL accessible by anyone on the internet.                                       |
| **Terraform** | Makes AWS setup reproducible and version-controlled. Anyone (including future you) can recreate the environment easily.                                                                                 |

## To be Implemented

* [ ] Improve testing and add to `deploy.yml` action
* [x] Add Terraform template for AWS setup
* [x] Add details on AWS usage in README
* [x] GitHub action to only generate new PDFs/Images on `main` to reduce repo size
* [x] A more standard build process that works on any OS (✅ Makefile added)
* [x] Migrate from requirements.txt to pyproject.toml for Python dependencies
