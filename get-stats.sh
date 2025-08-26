#!/usr/bin/bash
# set -x

clear
NOTIFY_EMAIL=$1

# Search commits wile excluding (this) repo
# curl https://api.github.com/search/commits?q=author:rkodey+-repo:rkodey/github-readme-stats
CURL="curl --silent"
CURL="curl"

# &cache_seconds=
GH_COMMON="&theme=transparent&text_color=888888&border_color=888888&title_color=4493F8&icon_color=4493F8"
GH_USER="rkodey"


# Since commits to this repo would cause the commit counter to increase, we'll only commit new images if the Stars or PRs update
GH_OPTIONS="${GH_COMMON}&show_icons=true&hide_title=true&hide_rank=true&include_all_commits=false&hide=commits,contribs,issues"
$CURL --output images/update.svg       "http://localhost:9008/?username=${GH_USER}${GH_OPTIONS}"


GH_OPTIONS="${GH_COMMON}&show_icons=true&hide_title=true&hide_rank=false&include_all_commits=true&hide=contribs&card_width=440px"
$CURL --output images/${GH_USER}.svg   "http://localhost:9008/?username=${GH_USER}${GH_OPTIONS}&rank_icon=github"
$CURL --output images/${GH_USER}2.svg  "http://localhost:9008/?username=${GH_USER}${GH_OPTIONS}"


GH_OPTIONS="${GH_COMMON}&show_owner=false"

GH_REPO="the-great-er-discarder-er"
$CURL --output images/${GH_REPO}.svg   "http://localhost:9008/pin/?username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"
GH_REPO="winmerge-visual-studio-dark"
$CURL --output images/${GH_REPO}.svg   "http://localhost:9008/pin/?username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"

GH_USER="gioxx"
GH_REPO="MarvellousSuspender"
$CURL --output images/${GH_REPO}.svg   "http://localhost:9008/pin/?username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"

git checkout images
git status images --untracked-files=no
git diff --exit-code images/update.svg

if [ $? -ne 0 ]; then
  if [ "${NOTIFY_EMAIL}" != "" ]; then
    git diff --exit-code images/update.svg > tee update.txt
    cat update.txt | mailx -s "github-readme-stats" ${NOTIFY_EMAIL}
  fi

  if [ 1 -eq 2 ]; then
  git commit -m "Update images" *.svg
  fi

fi

git checkout main
