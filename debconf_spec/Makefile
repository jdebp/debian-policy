all: debconf_specification.txt debconf_specification.html

%.html: %.xml html.dsl
	jade -V nochunks -t sgml -d html.dsl \
		/usr/lib/sgml/declaration/xml.dcl $< > $@
	-tidy -i -m -f /dev/null $@

%.txt: %.html
	links -dump $< | perl -pe 's/[\r\0]//g' > $@

clean:
	rm -f *.css *.html *.txt
