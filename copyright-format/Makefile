all: copyright-format-1.0.txt.gz copyright-format-1.0.html

copyright-format-1.0.html: copyright-format-1.0.xml html.dsl
	jade -V nochunks -t sgml -d html.dsl \
		/usr/share/xml/declaration/xml.dcl $< > $@
	-tidy -q -i -m -f /dev/null $@

copyright-format-1.0.txt: copyright-format-1.0.html
	links -dump $< | perl -pe 's/[\r\0]//g' > $@

copyright-format-1.0.txt.gz: copyright-format-1.0.txt
	gzip -cf9 $< > $@

clean:
	rm -f *.css *.html *.txt *.txt.gz

.DELETE_ON_ERROR:
