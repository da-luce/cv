# 📄 CV

My Curriculum Vitae (CV) and a cover letter template written using LaTeX.

## Building

> [!WARNING]
> Build scripts currently only run on MacOS.

> [!NOTE]
> Requires `pdflatex` and `imagemagick`.

Set executable permissions:

```bash
chmod +x ./make.sh
```

Then run:

```bash
# Public info
./make.sh
# Private info
./make.sh private
# For cover letter
pdflatex cover_letter.tex
```

## Screenshots

### Curriculum Vitae

![CV Image](./assets/cv.png)

### Cover Letter

![Cover Letter Image](./assets/cover_letter.png)
