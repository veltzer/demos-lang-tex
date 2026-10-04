# TOFIX

Findings from a code scan on 2026-10-04.

## High

- `rsconstruct.toml` - the repo's subject is never built or checked: no processor touches `src/basic.tex` (no `[processor.pdflatex]`, no lacheck run), so a broken TeX demo stays green. Add `[processor.pdflatex]` with `src_dirs = ["src"]` (and the TeX Live packages under `[dependencies] system`), plus a lacheck checker if wanted (see next item).

## Medium

- `scripts/wrapper_lacheck.py`, `scripts/wrapper_sketch.py` - nothing in the repo invokes either wrapper (no reference in `rsconstruct.toml` or anywhere else), and there are no `.sk` sketch sources for `wrapper_sketch.py` to process. Wire `wrapper_lacheck.py` into the build as a `[processor.script]` checker over `src/*.tex`, and delete `wrapper_sketch.py` (or add a sketch demo that uses it).
- `rsconstruct.toml:28,32` - `[processor.ruff]` and `[processor.mypy]` use `src_dirs = ["src", "scripts", "config"]`, but `src/` holds only `.tex` and `config/` only `.lua`; the only Python is in `scripts/`. Make both `src_dirs = ["scripts"]`.

## Low

- `scripts/wrapper_lacheck.py:34` - if lacheck emits a warning line before any `**` file header, `remember` is still `None` and the script prints the literal `None`; guard with `if remember is not None`.
- `scripts/wrapper_sketch.py:62-63,77-86` - on failure, stderr is written to a temp file only to be read back and printed (`printout`), and on success sketch's stderr (its warnings) is discarded, contradicting the docstring's "separate warning and errors"; print `e.stderr` directly and drop the temp-file plumbing (`tempfile`, `REMOVE_TMP`, `printout`).
- `doc/DONE.txt:1` - claims a Makefile builds the tex examples; there is no Makefile in the repo. `doc/TODO.txt` is empty. Delete both (or fold any live item into this file).
- `doc/tex/*.pdf` - 15 MB of third-party manuals (lshort, pgfmanual, short-math-guide, ...) committed as binaries; replace with a `doc/links.txt` of their CTAN URLs, which stay current.
- `src/basic.tex:4` - the comment says "Centered, bold title" but `\centerline` does not bold; and `:14-16` uses plain-TeX `$$...$$` in a LaTeX document, where `\[...\]` is the correct form (`$$` breaks vertical spacing and `fleqn`). Fix both so the demo teaches idiomatic LaTeX.
