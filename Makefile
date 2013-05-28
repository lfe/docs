JEKYLL = /usr/bin/jekyll
SITE_BUILD = ./build
BOOK_SRC = $(SITE_BUILD)/downloads
BOOK_DST = ./downloads
PYTHONPATH = PYTHONPATH=.
PYGMENTS = $(shell python -c "import pygments;print pygments.__path__[0]")
MARKDOWN = $(shell python -c "import markdown;print markdown.__path__[0]")
BOOKS = $(shell $(PYTHONPATH) python -c "from scriptlib import config;print config.get_book_names()")
EPUB_BUILD = $(SITE_BUILD)/epub
WKPDF = /usr/bin/wkpdf

$(JEKYLL):
	sudo gem update --system
	sudo gem install jekyll
	sudo gem install jekyll-tagging

$(PYGMENTS):
	sudo pip install pygments

$(MARKDOWN):
	sudo pip install markdown

$(WKPDF):
	sudo gem install wkpdf

doc-deps: $(JEKYLL) $(PYGMENTS) $(MARKDOWN) $(WKPDF)
	sudo pip install pil

build-md: doc-deps
	@echo
	@echo "Generating markdown for ebooks ..."
	rm -f $(BOOK_DST)/*.markdown
	$(PYTHONPATH) python bin/generateMD.py

build-site: build-md
	@echo
	@echo "Building site and generating html for ebooks ..."
	rm -rf $(SITE_BUILD)
	rm -f $(BOOK_DST)/*.html
	jekyll build -d $(SITE_BUILD)
	cp $(BOOK_SRC)/*.html $(BOOK_DST)/

build-pdf: $(WKPDF)
	@echo
	@echo "Generating pdfs for ebooks ..."
	rm -f $(BOOK_DST)/*.pdf
	for BOOK in $(BOOKS); do \
	$(WKPDF) \
	--source $(BOOK_DST)/$$BOOK.html \
	--output $(BOOK_DST)/$$BOOK.pdf; done

build-epub: build-site build-pdf
	@echo
	@echo "Generating epubs for ebooks ..."
	rm -f $(BOOK_DST)/*.epub
	for BOOK in $(BOOKS); do \
	$(PYTHONPATH) python bin/generateEPub.py \
	--html=$(BOOK_DST)/$$BOOK.html \
	--archive-path=$(EPUB_BUILD); done
	cp $(EPUB_BUILD)/*.epub $(BOOK_DST)

build-mobi: build-epub build-mobi-fast

build-mobi-fast:
	@echo
	@echo "Generating mobis for ebooks ..."
	rm -f $(BOOK_DST)/*.mobi
	for BOOK in $(BOOKS); do \
	./bin/kindlegen $(BOOK_DST)/$$BOOK.epub -c2; done

publish-books: build-mobi
	git commit \
	$(BOOK_DST)/*.markdown \
	$(BOOK_DST)/*.html \
	$(BOOK_DST)/*.pdf \
	$(BOOK_DST)/*.epub \
	$(BOOK_DST)/*.mobi \
	-m "Updated LFE ebooks."

contributors:
	git log --pretty=format:"%an"|sort -u

.PHONY: build-books build-epub build-mobi