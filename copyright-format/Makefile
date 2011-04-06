all: copyright-format.txt.gz copyright-format.html

%.html: %.xml html.dsl
	jade -V nochunks -t sgml -d html.dsl \
		/usr/share/xml/declaration/xml.dcl $< > $@
	-tidy -q -i -m -f /dev/null $@

%.txt: %.html
	links -dump $< | perl -pe 's/[\r\0]//g' > $@

%.txt.gz: %.txt
	gzip -cf9 $< > $@

clean:
	rm -f *.css *.html *.txt *.txt.gz

.DELETE_ON_ERROR:
