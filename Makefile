SHELL=/bin/bash
SRC = _src
CV_TEX := $(SRC)/cv.tex
CV_MD := index.md
SPELL := $(shell command -v aspell 2> /dev/null)

CACHE_FOLDER := /opt/build/cache
TEXLIVEDIR := $(CACHE_FOLDER)/texlive
TEXLIVE_BIN := $(TEXLIVEDIR)/bin/x86_64-linux
PATH := $(PATH):$(TEXLIVE_BIN)

.PHONY: texlive pdf md clean spell check

default: pdf md

check:
ifndef SPELL
	$(error "Spell check requires aspell")
endif

texlive:
	mkdir -p $(CACHE_FOLDER) texlive-installer $(TEXLIVEDIR)
	wget -q http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
	tar -xf install-tl-unx.tar.gz -C ./texlive-installer --strip 1
	printf '%s\n' \
"selected_scheme scheme-basic" \
"TEXDIR $(TEXLIVEDIR)" \
"TEXMFLOCAL $(TEXLIVEDIR)/texmf-local" \
"TEXMFSYSCONFIG $(TEXLIVEDIR)/texmf-config" \
"TEXMFSYSVAR $(TEXLIVEDIR)/texmf-var" \
"binary_x86_64-linux 1" \
"tlpdbopt_install_docfiles 0" \
"tlpdbopt_install_srcfiles 0" \
	> ./texlive.profile
	./texlive-installer/install-tl --profile ./texlive.profile
	tlmgr install parskip titlesec enumitem

pdf: $(CV_TEX)
	pdflatex -output-directory $(SRC) $(CV_TEX)
	mv $(SRC)/cv.pdf chris-buckley-cv.pdf

md: $(CV_TEX)
	cp $(SRC)/cv.md $(CV_MD)
	sed -i'.bak' "s/description:.*$$/&$(shell awk -f $(SRC)/summary.awk $(CV_TEX))/" $(CV_MD)
	awk -f $(SRC)/cv.awk $(CV_TEX) >> $(CV_MD)
	while IFS=: read text link; \
		do sed -i'.bak' "s~$$text~[&]({% include mainurl.html %}$${link/ /})~" $(CV_MD); \
	done < _data/links.yml
	rm $(CV_MD).bak

clean:
	rm -rf $(CV_MD) cv.* $(SRC)/cv.{aux,log,out,toc}

spell: check $(CV_TEX)
	aspell --conf=./$(SRC)/aspell/aspell.conf list < $(CV_TEX) | LANG=C sort -u | (! grep --color=never .)
