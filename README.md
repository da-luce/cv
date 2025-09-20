# 📄 CV [![Deploy Resume](https://github.com/da-luce/cv/actions/workflows/deploy.yml/badge.svg)](https://github.com/da-luce/cv/actions/workflows/deploy.yml)

<br>
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
<br>

My [Curriculum Vitae](https://en.wikipedia.org/wiki/Curriculum_vitae) and cover letter template, written in $\LaTeX$. All artifacts (PDFs and preview images) are automatically built using GitHub Actions and uploaded to an AWS S3 bucket. A Terraform configuration and [instructions](#deploying-artifacts-to-aws) are included below if you want a similar settup for your own resume.

Is it overengineered? _For most, probably yes._ <br>
Is it perfect for automation enthusiasts? _Absolutely._ <br>
Maybe I can convince you to become one too—_[here's why](#why-this-setup)._

## Screenshots

### Curriculum Vitae &nbsp; [![PDF](https://img.shields.io/badge/PDF-blue?style=flat)](https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/pdfs/dalton_luce_cv.pdf)

![CV Image](https://dalton-cv-artifacts.s3.us-east-1.amazonaws.com/images/dalton_luce_cv.png)

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

## Why This Setup?

| Component                                                  | Why?                                                                                                                                                                                                    |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [**Git**](https://git-scm.com/)                            | Tracks every change in fine detail—much more granular than cloud-hosted solutions like Google Drive. Supports collaboration, safe experimentation, and integrates seamlessly with automation workflows. |
| [**LaTeX**](https://www.latex-project.org/)                | Produces professional, highly customizable PDFs. Standard in math and engineering fields, and easy to track with Git.                                                                                   |
| [**AWS S3**](https://aws.amazon.com/s3/)                   | Cheap (pennies for 2 MB of assets) and reliable hosting. Stores the latest PDFs and images outside the repo (avoiding repo bloat) and provides a stable URL accessible by anyone on the internet.       |
| [**Terraform**](https://developer.hashicorp.com/terraform) | Makes AWS setup reproducible and version-controlled. Anyone (including future you) can recreate the environment easily.                                                                                 |
| [**GitHub Actions**](https://github.com/features/actions)  | Automates the build, test, and deployment workflow on every push. Ensures your CV and cover letter are always up-to-date without manual intervention, seamlessly integrating with Git and AWS S3.       |
| [**cvlint**](https://github.com/da-luce/cvlint)            | Automatically checks your CV for formatting and content issues.                                                                                                                                         |