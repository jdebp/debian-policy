include debian/rules

policy.sgml: version.ent
menu-policy.sgml: version.ent
mime-policy.sgml: version.ent

ifneq (,$(strip $(HAVE_ORG_EMACS)))
%.txt: %.org
	$(EMACS) --batch -Q -l ./README-css.el -l org --visit $^ \
          --funcall org-export-as-ascii >/dev/null 2>&1
%.html: %.org
	$(EMACS) --batch -Q -l ./README-css.el -l org --visit $^ \
          --funcall org-export-as-html-batch >/dev/null 2>&1
endif

%.validate: %
	nsgmls -wall -gues $<

%.html/index.html: %.sgml
	LANG=C debiandoc2html $<

%-1.html: %.sgml
	LANG=C debiandoc2html -1 -b $*-1d $< && \
        mv $*-1d.html/index.html $*-1.html && \
        rmdir $*-1d.html

%.html.tar.gz: %.html/index.html
	tar -czf $(<:/index.html=.tar.gz) $(<:/index.html=)

%.txt: %.sgml
	LANG=C debiandoc2text $<

%.txt.gz: %.txt
	gzip -cf9 $< > $@

%.ps: %.sgml
	LANG=C debiandoc2latexps $<

%.ps.gz: %.ps
	gzip -cf9 $< > $@

%.pdf: %.sgml
	LANG=C debiandoc2latexpdf $<

%.pdf.gz: %.pdf
	gzip -cf9 $< > $@

# convenience aliases :)
html: policy.html/index.html
html-1: policy-1.html
txt text: policy.txt
ps: policy.ps
pdf: policy.pdf
policy: html txt ps pdf

leavealone :=	$(FHS_HTML) $(FHS_FILES) $(FHS_ARCHIVE) \
		libc6-migration.txt \
		upgrading-checklist.html virtual-package-names-list.txt
	      
.PHONY: distclean
distclean:
	rm -rf $(filter-out $(leavealone),$(wildcard *.html))
	rm -f $(filter-out $(leavealone),$(wildcard *.txt *.txt.gz *.html.tar.gz *.pdf *.ps))
	rm -f *.lout* lout.li *.sasp* *.tex *.aux *.toc *.idx *.log *.out *.dvi *.tpt
	rm -f `find . -name "*~" -o -name "*.bak" -o -name ".#*" -o -name core`
	rm -f version.ent
	rm -f *.rej *.orig

# if a rule bombs out, delete the target
.DELETE_ON_ERROR:
# no default suffixes work here, don't waste time on them
.SUFFIXES: 
