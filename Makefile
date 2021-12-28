SHELL=/bin/bash
SRC = _src
CV_TEX := $(SRC)/cv.tex
CV_MD := index.md

.PHONY: pdf md clean spell check

default: pdf md

check:
ifeq (, $(shell which aspell))
	$(error "Spell check requires aspell")
endif

pdf: $(CV_TEX)
	pdflatex -output-directory $(SRC) $(CV_TEX)
	mv $(SRC)/cv.pdf .

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

spell: check md
	aspell list < $(CV_MD) | LANG=C sort -u
