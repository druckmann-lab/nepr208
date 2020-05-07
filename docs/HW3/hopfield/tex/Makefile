filename=ps3

all: pdf

pdf:
	latexmk $(filename).tex

view:
	open $(filename).pdf

clean:
	rm *.aux *.log *.out *.fls *.fdb_latexmk *.bbl *.blg *.lof *.toc
