prop.pdf: proposal.md biblio.bib gannt.png multi-example.png pandoc.svg
	pandoc --lua-filter ./latex-logo.lua --number-sections\
		--bibliography biblio.bib --citeproc proposal.md -o $@

prop.odt: proposal.md biblio.bib gannt.png multi-example.png pandoc.svg
	pandoc --lua-filter ./latex-logo.lua --number-sections\
		--bibliography biblio.bib --citeproc proposal.md -o $@

readme.md: proposal.md biblio.bib gannt.png multi-example.png pandoc.svg
	pandoc\
		--number-sections\
		--strip-comments\
		--to=markdown-citations\
		--bibliography biblio.bib --citeproc proposal.md -o $@

.PHONY: clean

clean:
	rm prop.pdf
	rm prop.odt
