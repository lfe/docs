total-changes-header:
	@echo
	@echo "#################################"
	@echo "#  Total Changes                #"
	@echo "#################################"

total-calendar-contributions:
	@echo
	@echo "Commit Calendar"
	@echo "============================="
	@/alt/opt/node/6.9.5/lib/node_modules/git-stats/bin/git-stats -g
	@/alt/opt/node/6.9.5/lib/node_modules/git-stats/bin/git-stats -gn

total-contributions:
	@echo
	@echo "Contributions"
	@echo "============================="
	@gitinspector -rlm -f clj,cljc,cljs,sql,md --grading

total-author-changes:
	@echo
	@echo "$(AUTHOR)'s Changes"
	@echo "============================="
	@git log --author="$(AUTHOR)" --pretty=tformat: --numstat | \
	gawk '{ add += $$1; subs += $$2; loc += $$1 - $$2 } END { printf "Lines added: \t%s\nLines removed: \t%s\nTotal lines: \t%s\n", add, subs, loc }' -
	@git log --author="$(AUTHOR)" | \
	grep commit | wc -l | \
	gawk '{ commits = $$1 } END { printf "Commits: \t%s\n", commits }'

threeweek-changes-header:
	@echo
	@echo "#################################"
	@echo "#  3 Weeks Ago Changes          #"
	@echo "#################################"

twoweek-changes-header:
	@echo
	@echo "#################################"
	@echo "#  2 Weeks Ago Changes          #"
	@echo "#################################"

prevweek-changes-header:
	@echo
	@echo "#################################"
	@echo "#  1 Week Ago Changes           #"
	@echo "#################################"

week-changes-header:
	@echo
	@echo "#################################"
	@echo "#  This Week's Changes          #"
	@echo "#################################"

yesterday-changes-header:
	@echo
	@echo "#################################"
	@echo "#  Yesterday's Changes          #"
	@echo "#################################"

today-changes-header:
	@echo
	@echo "#################################"
	@echo "#  Today's Changes              #"
	@echo "#################################"

time-author-changes:
	@echo
	@echo "$(AUTHOR)'s Changes"
	@echo "============================="
	@git log --since="$(SINCE)" --until="$(UNTIL)" --author="$(AUTHOR)" --pretty=tformat: --numstat | \
	gawk '{ add += $$1; subs += $$2; loc += $$1 - $$2 } END { printf "Lines added: \t%s\nLines removed: \t%s\nTotal lines: \t%s\n", add, subs, loc }' -
	@git log --since="$(SINCE)" --until="$(UNTIL)" --author="$(AUTHOR)" | \
	grep commit | wc -l | \
	gawk '{ commits = $$1 } END { printf "Commits: \t%s\n", commits }'

### Duncan's Changes

total-duncan-changes:
	@AUTHOR="Duncan McGreggor" $(MAKE) --no-print-directory total-author-changes

threeweek-duncan-changes:
	@AUTHOR="Duncan McGreggor" SINCE="4 weeks ago" UNTIL="3 weeks ago" $(MAKE) --no-print-directory time-author-changes

twoweek-duncan-changes:
	@AUTHOR="Duncan McGreggor" SINCE="3 weeks ago" UNTIL="2 weeks ago" $(MAKE) --no-print-directory time-author-changes

prevweek-duncan-changes:
	@AUTHOR="Duncan McGreggor" SINCE="2 weeks ago" UNTIL="1 week ago" $(MAKE) --no-print-directory time-author-changes

week-duncan-changes:
	@AUTHOR="Duncan McGreggor" SINCE="1 week ago" UNTIL="today" $(MAKE) --no-print-directory time-author-changes

yesterday-duncan-changes:
	@AUTHOR="Duncan McGreggor" SINCE="2 days ago" UNTIL="1 day ago" $(MAKE) --no-print-directory time-author-changes

today-duncan-changes:
	@AUTHOR="Duncan McGreggor" SINCE="1 day ago" UNTIL="today" $(MAKE) --no-print-directory time-author-changes

### All Author's Changes

total-stats: total-changes-header total-calendar-contributions total-contributions total-duncan-changes
threeweek-stats: threeweek-changes-header threeweek-duncan-changes
twoweek-stats: twoweek-changes-header twoweek-duncan-changes
prevweek-stats: prevweek-changes-header prevweek-duncan-changes
week-stats: week-changes-header week-duncan-changes
yesterday-stats: yesterday-changes-header yesterday-duncan-changes
today-stats: today-changes-header today-duncan-changes

### All Stats

stats: total-stats threeweek-stats twoweek-stats prevweek-stats week-stats yesterday-stats today-stats
	@echo
