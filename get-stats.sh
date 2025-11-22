#!/usr/bin/bash
# set -x

NOTIFY_EMAIL=$1
DEBUG=0
UPDATE=0
set -a; source .env; set +a


git checkout main
git pull --ff-only


if [ $DEBUG -eq 0 ]; then

# Search commits wile excluding (this) repo
# curl https://api.github.com/search/commits?q=author:rkodey+-repo:rkodey/github-readme-stats

# &cache_seconds=
GH_COMMON="&theme=transparent&text_color=888888&border_color=888888&title_color=4493F8&icon_color=4493F8"


GH_USER="rkodey"

# Since commits to this repo would cause the commit counter to increase, we'll only commit new images if the Stars or PRs update
GH_OPTIONS="${GH_COMMON}&show_icons=true&hide_title=true&hide_rank=true&include_all_commits=false&hide=commits,contribs,issues"
node get-github.js  user  images/update.svg       "username=${GH_USER}${GH_OPTIONS}"

GH_OPTIONS="${GH_COMMON}&show_icons=true&hide_title=true&hide_rank=false&include_all_commits=true&hide=contribs&card_width=440px"
node get-github.js  user  images/${GH_USER}.svg   "username=${GH_USER}${GH_OPTIONS}&rank_icon=github"
node get-github.js  user  images/${GH_USER}2.svg  "username=${GH_USER}${GH_OPTIONS}"


GH_OPTIONS="${GH_COMMON}&show_owner=false"

GH_REPO="the-great-er-discarder-er"
node get-github.js  repo  images/${GH_REPO}-github.svg  "username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"
GH_REPO="winmerge-visual-studio-dark"
node get-github.js  repo  images/${GH_REPO}-github.svg  "username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"

GH_USER="gioxx"
GH_REPO="MarvellousSuspender"
node get-github.js  repo  images/${GH_REPO}-github.svg  "username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"


node get-chrome-store.js  images/the-great-er-discarder-er-chrome.svg   plpkmjcnhhnpkblimgenmdhghfgghdpp
node get-chrome-store.js  images/MarvellousSuspender-chrome.svg         noogafoofpebimajpfpamcfhoaifemoa

fi  # DEBUG


git status images --untracked-files=no

echo "https://github.com/rkodey/github-readme-stats" > update.txt
update() {
  git diff --exit-code --color=always images/$1.svg >> update.txt
  if [ $? -ne 0 ]; then UPDATE=1; fi
  echo $UPDATE $1
}
update "update"
update "the-great-er-discarder-er-chrome"
update "MarvellousSuspender-chrome"


if [ $UPDATE -eq 1 ]; then
  cat update.txt
  git commit -m "-- Auto update images" *.svg
  git push origin

  if [ "${NOTIFY_EMAIL}" != "" ]; then
    cat update.txt | aha | mailx -s "github-readme-stats" -M "text/html" ${NOTIFY_EMAIL}
  fi

fi
