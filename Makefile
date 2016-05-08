JEKYLL = /usr/bin/jekyll
SITE_BUILD = ./build

clean:
	rm -rf $(SITE_BUILD)

$(JEKYLL):
	sudo gem update --system
	sudo gem install jekyll
	sudo gem install jekyll-tagging
	sudo gem install rouge

doc-deps: $(JEKYLL)

site:
	@echo
	@echo "Building site ..."
	rm -rf $(SITE_BUILD)
	jekyll build -d $(SITE_BUILD)

dev:
	@echo
	@echo "Running site ..."
	jekyll serve -d $(SITE_BUILD)

contributors:
	git log --pretty=format:"%an"|sort -u

