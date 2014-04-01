all: pdf md

pdf:
	pdflatex cv.tex

md:
	awk -f cv.awk cv.tex | tee cv.md
