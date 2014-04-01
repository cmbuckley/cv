all: pdf md

pdf:
	pdflatex cv.tex

md:
	awk -F '[{}]' -f cv.awk cv.tex | tee cv.md
