SHELL=/bin/bash
SRC = _src
CV_TEX := $(SRC)/cv.tex
CV_MD := index.md
SPELL := $(shell command -v aspell 2> /dev/null)

.PHONY: pdf md clean spell check

default: pdf md

check:
ifndef SPELL
	$(error "Spell check requires aspell")
endif

pdf: $(CV_TEX)
	pdflatex -output-directory $(SRC) $(CV_TEX)
	mv $(SRC)/cv.pdf chris-buckley-cv.pdf

md: $(CV_TEX)
	cp $(SRC)/cv.md $(CV_MD)
	sed -i'.bak' "s/description:.*$$/&$(shell awk -f $(SRC)/summary.awk $(CV_TEX))/" $(CV_MD)
	awk -f $(SRC)/cv.awk $(CV_TEX) >> $(CV_MD)
	while IFS=: read interest link; \
		do sed -i'.bak' "s~$$interest~[&]($${link/ /})~" $(CV_MD); \
	done < _data/links.yml
	rm $(CV_MD).bak

clean:
	rm -rf $(CV_MD) cv.* $(SRC)/cv.{aux,log,out,toc}

spell: check $(CV_TEX)
	aspell --conf=./$(SRC)/aspell/aspell.conf list < $(CV_TEX) | LANG=C sort -u | (! grep --color=never .)
