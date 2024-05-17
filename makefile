main.pdf: main.typ matrix.typ
	typst c main.typ 

watch:
	typst w main.typ