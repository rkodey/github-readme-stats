#!/usr/bin/bash
# set -x

# 9000 debug port
# 9008 docker port

clear
NOTIFY_EMAIL=$1
PORT=$2
DEBUG=0
UPDATE=0

if [ "$PORT" == "" ]; then
  PORT=9008
fi

if [ $DEBUG -eq 0 ]; then

# Search commits wile excluding (this) repo
# curl https://api.github.com/search/commits?q=author:rkodey+-repo:rkodey/github-readme-stats
CURL="curl --silent"
CURL="curl"

# &cache_seconds=
GH_COMMON="&theme=transparent&text_color=888888&border_color=888888&title_color=4493F8&icon_color=4493F8"
GH_USER="rkodey"


# Since commits to this repo would cause the commit counter to increase, we'll only commit new images if the Stars or PRs update
GH_OPTIONS="${GH_COMMON}&show_icons=true&hide_title=true&hide_rank=true&include_all_commits=false&hide=commits,contribs,issues"
$CURL --output images/update.svg       "http://localhost:$PORT/?username=${GH_USER}${GH_OPTIONS}"


GH_OPTIONS="${GH_COMMON}&show_icons=true&hide_title=true&hide_rank=false&include_all_commits=true&hide=contribs&card_width=440px"
$CURL --output images/${GH_USER}.svg   "http://localhost:$PORT/?username=${GH_USER}${GH_OPTIONS}&rank_icon=github"
$CURL --output images/${GH_USER}2.svg  "http://localhost:$PORT/?username=${GH_USER}${GH_OPTIONS}"


GH_OPTIONS="${GH_COMMON}&show_owner=false"

GH_REPO="the-great-er-discarder-er"
$CURL --output images/${GH_REPO}-github.svg   "http://localhost:$PORT/pin/?username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"
GH_REPO="winmerge-visual-studio-dark"
$CURL --output images/${GH_REPO}-github.svg   "http://localhost:$PORT/pin/?username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"

GH_USER="gioxx"
GH_REPO="MarvellousSuspender"
$CURL --output images/${GH_REPO}-github.svg   "http://localhost:$PORT/pin/?username=${GH_USER}&repo=${GH_REPO}${GH_OPTIONS}"


node get-chrome-store.js plpkmjcnhhnpkblimgenmdhghfgghdpp the-great-er-discarder-er
node get-chrome-store.js noogafoofpebimajpfpamcfhoaifemoa MarvellousSuspender

fi  # DEBUG


git status images --untracked-files=no

echo "https://github.com/rkodey/github-readme-stats" > update.txt
update() {
  git diff --exit-code --color=always images/$1.svg >> update.txt
  if [ $? -ne 0 ]; then UPDATE=1; fi
  echo $UPDATE $1
}
update "update"
update "plpkmjcnhhnpkblimgenmdhghfgghdpp"
update "noogafoofpebimajpfpamcfhoaifemoa"


if [ $UPDATE -eq 1 ]; then
  cat update.txt
  git commit -m "-- Auto update images" *.svg
  git push origin

  if [ "${NOTIFY_EMAIL}" != "" ]; then
    cat update.txt | aha | mailx -s "github-readme-stats" -M "text/html" ${NOTIFY_EMAIL}
  fi

fi
