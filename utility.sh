#!/usr/bin/env bash

# Find the latest version of this application:
# https://github.com/firepress-org/bash-script-template
#
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)
#set -o nounset          # Disallow expansion of unset variables
# --- Find bad variables with CMD `./utility.sh test two three`, else disable it
# --- or remove $1, $2, $3 var defintions in @main

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# Core fct
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
		  #
		 # #
		#   #
function help {

rm utility_help.md || true
cat <<EOF > utility_help.md

## help

The command 'help is too broad'.

## Please choose:

- helpbash
- helpworkflow

## markdown viewer sources
https://github.com/axiros/terminal_markdown_viewer

EOF
input_2="utility_help.md"
mdv-all
rm utility_help.md || true

}
# idea see our docs in Markdown / mdv https://github.com/axiros/terminal_markdown_viewer#installation 

function -h {
  #alias
  help
}

function helpbash {

rm utility_help.md || true
cat <<EOF > utility_help.md

## Operator	Description

```
  ! EXPRESSION	  The EXPRESSION is false.
  -n STRING	      The length of STRING is greater than zero.
  -z STRING	      The lengh of STRING is zero (ie it is empty).
  STRING1         = STRING2	STRING1 is equal to STRING2
  STRING1         != STRING2	STRING1 is not equal to STRING2
  INTEGER1        -eq INTEGER2	INTEGER1 is numerically equal to INTEGER2
  INTEGER1        -gt INTEGER2	INTEGER1 is numerically greater than INTEGER2
  INTEGER1        -lt INTEGER2	INTEGER1 is numerically less than INTEGER2
      -d FILE	    FILE exists and is a directory.
      -e FILE	    FILE exists.
      -r FILE	    FILE exists and the read permission is granted.
      -s FILE	    FILE exists and its size is greater than zero (ie. it is not empty).
      -w FILE	    FILE exists and the write permission is granted.
      -x FILE	    FILE exists and the execute permission is granted.
```
EOF
input_2="utility_help.md"
mdv-all
rm utility_help.md || true

}

function helpworkflow {

rm utility_help.md || true
cat <<EOF > utility_help.md

# CORE WORKFLOW for https://github.com/firepress-org/ghostfire/

==> from branch edge,
==> we want to update ghost.
run these cmd
======> utility.sh version 3.3.0
======> utility.sh master
======> utility.sh release 3.3.0

## USE CASE #1

Simple version update on the dockerfile
- see CMD version

## USE CASE #2:

### EDGE BRANCH

- We commit using CMD 'push' some change on (branch) edge
- Rebase on master from edge
- In CHANGELOG, write a git history of the changes
- Git commit with a message

### MASTER BRANCH

- Tag x.x.x this commit
- push tag x.x.x
- release on Github with the tag x.x.x along a markdown description that points to our CHANGELOG.md

That takes too much time.

First method (2 steps):

  - 'master 1.2.3-r4' (rebase master from edge).
  - Review and optionaly, manually edit file CHANGELOG.md
  - 'release 1.2.3-r4' (at this point, we are now to edge branch)

Second method (3 steps):

-   'master' (rebase master from edge)
-   'draft 1.2.3-r4' (it injects the latest commit(s) in CHANGELOG.md)
-       Optionaly, manually edit CHANGELOG.md
-   'release 1.2.3-r4' (at this point, we are now to edge branch)
EOF
input_2="utility_help.md"
mdv-all
rm utility_help.md || true

}

function version {
# this updates the app's version in our Dockerfile
# usage: CMD ./utility.sh version 1.50.1
# what it does:
  # update tag in Dockerfile
  # save the commit
  # tag on the latest commit
  # push tag to remote

  App_input2_rule
  tag_version="${input_2}"

  # update tag within the Dockerfile without "-r1" "-r2"
  ver_in_dockerfile=$(echo ${tag_version} | sed 's/-r.*//g')
  sed -i '' "s/^ARG VERSION=.*$/ARG VERSION=\"${ver_in_dockerfile}\"/" Dockerfile 

  git add . && \
  git commit -m "Updated to version: ${tag_version}" && \
  git push
}


function edge_init {
  # wip
  git push --set-upstream origin edge
}



function push {
# push commit all & push all changes
# usage: CMD ./utility.sh push "Add fct xyz"
  App_input2_rule

  git status && \
  git add -A && \
  git commit -m "${input_2}" && \
  clear && \
  git push;
}

function sq {
# squash
# usage: CMD ./utility.sh sq 3 "Add fct xyz"

  App_input2_rule
  App_input3_rule

  backwards_steps="${input_2}"
  git_message="${input_3}"
  usage="sq 3 'Add fct xyz'"

  # think rebase_master_from_edge
  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null
    git reset --hard HEAD~"${backwards_steps}" && \
    git merge --squash HEAD@{1} && \
    git push origin HEAD --force && \
    git status && \
    git add -A && \
    git commit -m "${git_message} / squashed" && \
    git push;
  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}

function stg {
# think rebase stg from edge
# usage: CMD ./utility.sh master
# idea from: https://www.gatsbyjs.org/blog/2020-01-08-git-workflows/

  # NoAttributes needed

  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null

    #no prompt

    # root branch is feat/headless-cms

    git checkout feat/headless-cms-pt2
    git rebase feat/headless-cms-pt1

    # stage all the changes we just made
    git add .
    # wrap up the rebase
    git rebase --continue

    git push origin feat/headless-cms-pt2 -f

    # PR on github
    # Merge from the first one up (merge pt1 into the root branch,
    # and then merge pt2 into the root branch)

    # Merge the earliest open PR into the root branch, using the standard “merge” option.
    # Change the base of the next branch to point at the root branch
    # In this case, we merge:
    # feat/headless-cms-pt1 TO feat/headless-cms
    # then, we merge:
    # feat/headless-cms-pt2 TO feat/headless-cms

    # Update our local state
    git checkout master
    git pull origin master
    # Rebase our root branch
    git checkout feat/headless-cms
    git rebase master
    # Continue down the chain
    git checkout feat/headless-cms-pt2
    git rebase feat/headless-cms

    ### confirmation
    echo && \
    my_message="Branch <edge> was merged to <master>" App_Blue && \
    my_message="Back to work!" App_Blue;
  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}

function masterv2-sq {
  # think rebase stg from edge
  # usage: CMD ./utility.sh master
  # idea from: https://www.gatsbyjs.org/blog/2020-01-08-git-workflows/

  # NoAttributes needed

  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "Nothing to commit, good" | 2>/dev/null

    #no prompt

    # single source of thruth is master branch
    # Update our local state
    git checkout master
    git pull origin master
    # Rebase our root branch from edge
    git rebase edge

    # At this point, we may have conflicts
    # Let tell git to use all updates from edge by default
    # stage all the changes we just made
    git add .
    # wrap up the rebase
    # the system might complain 
    # "fatal: No rebase in progress?" in the case there is nothing to rebase
    git rebase --continue || true
    git push origin master -f

    # Update our local state (if update happened on master)
    git checkout master
    git pull origin master
    # Rebase our edge branch
    git checkout edge
    git rebase master

    ### confirmation
    echo && \
    my_message="Branch <edge> was merged to <master>" App_Blue && \
    my_message="Back to work!" App_Blue;
  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}

function masterv1-sq {
# think rebase master from edge
# usage: CMD ./utility.sh master
  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null

    #prompt
    my_message="What is this merge is doing?" App_Blue
    read -p "==> " squash_message

    ### Commit your updates on edge
    git checkout edge && git pull && \
    ### merge edge to mrg_edge_2_master
    git branch -D mrg_edge_2_master || true && \
    git checkout -b mrg_edge_2_master && \
    git merge origin/edge && \
    ### merge mrg_edge_2_master to master
    git checkout master && git pull && \
    git merge --squash mrg_edge_2_master && \
    git commit . -m "${squash_message} /squash" && git push && \
    ### Go back to dev mode
    git checkout edge && git pull && \
    ### overide potential conflict with commits from master
    git merge -s ours master && git push && \
    git branch -D mrg_edge_2_master && \
    ### confirmation
    echo && \
    my_message="Branch <edge> was merged to <master>" App_Blue && \
    my_message="Back to work!" App_Blue;
  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}

function master {

# think rebase master from edge
# usage: CMD ./utility.sh master
# no squash
  # NoAttributes needed

  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null

    #no prompt

    ### Commit your updates on edge
    git checkout edge && git pull && \
    ### merge edge to mrg_edge_2_master
    git branch -D mrg_edge_2_master || true && \
    git checkout -b mrg_edge_2_master && \
    git merge origin/edge && \
    ### merge mrg_edge_2_master to master
    git checkout master && git pull && \
    git merge mrg_edge_2_master && git push && \
    ### Go back to dev mode
    git checkout edge && git pull && \
    git rebase master && git push && \
    git branch -D mrg_edge_2_master && \
    ### confirmation
    echo && \
    my_message="Branch <edge> was merged to <master>" App_Blue && \
    my_message="Back to work!" App_Blue;
  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}

function masterv2-sq {
# think rebase master from edge
# usage: CMD ./utility.sh master

# tk create a fct for this checkpoint
if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
  echo "Good, lets continue" | 2>/dev/null
else
  my_message="You must push your commit(s) before doing a rebase." App_Pink && App_Stop
fi

# Update our local state
git checkout master
git pull origin master
# Rebase our root branch from edge
git branch -D mrg_edge_2_master || true
git rebase mrg_edge_2_master

#prompt
my_message="What is this merge is doing?" App_Blue
read -p "==> " squash_message

git merge --squash mrg_edge_2_master && \
git add .
git commit . -m "${squash_message} /squash" && git push && \


# Update our local state (if update happened on master)
git checkout master
git pull origin master
# Rebase our edge branch
git checkout edge
git rebase master

### confirmation
echo && \
my_message="Branch <edge> was merged to <master>" App_Blue && \
my_message="Back to work!" App_Blue;
}

function edge {
# think rebase edge from master
# usage: CMD ./utility.sh edge

  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null
    git checkout edge && \
    git pull && \
    git rebase master && \
    git push && \
    git branch -D mrg_edge_2_master;

  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}

function cl {
  # think changelog

  # is expecting a version
  App_input2_rule

  App_Draft
}

function cl-read {
  # think changelog

  input_2="CHANGELOG.md"
  # is expecting a version
  App_input2_rule

  mdv-all
}
function cl-view {
  #alias
  cl-read
}

function release {
# push changelog
# powerfull as it combines: tag + release + edge
# usage: CMD ./utility.sh release 1.50.1

  # is expecting a version
  App_input2_rule

  # Prompt a warning
  min=1 max=4 message="WARNING: is CHANGELOG.md is updated using /cl_update/"
  for ACTION in $(seq ${min} ${max}); do
    echo -e "${col_pink} ${message} ${col_pink}" && sleep 0.4 && clear && \
    echo -e "${col_blue} ${message} ${col_blue}" && sleep 0.4 && clear
  done

  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "master" ]]; then
    tag_version="${input_2}"

    tag
    App_release
    edge
  else
    my_message="You must be in the master branch." App_Pink
  fi
}

function mdv {
# fuck cat, let's see markdown!
# markdown viewer for your terminal
# https://github.com/axiros/terminal_markdown_viewer#installation
clear

# show the first 60 lines
docker run --rm -it \
  -v $(pwd):/sandbox \
  -w /sandbox \
  devmtl/mdv:1.6.3 \
    -t 'warm & natural' ${input_2} | sed -n 12,50p
}

function mdv-all {
clear

docker run --rm -it \
  -v $(pwd):/sandbox \
  -w /sandbox \
  devmtl/mdv:1.6.3 \
    -t 'warm & natural' ${input_2}
}

function tag {
# you should use release as its a sub fct of release
# usage: CMD ./utility.sh tag 1.50.1

  App_input2_rule

  tag_version="${input_2}"

  # update tag within the Dockerfile without "-r1" "-r2"
  ver_in_dockerfile=$(echo $tag_version | sed 's/-r.*//g')
  sed -i '' "s/^ARG VERSION=.*$/ARG VERSION=\"$ver_in_dockerfile\"/" Dockerfile 

  git add . && \
  git commit -m "Updated to version: $tag_version" && \
  git push && \
  sleep 1 && \
  # push tag
  git tag ${tag_version} && \
  git push --tags

# what it does:
  # update tag in Dockerfile
  # save the commit
  # tag on the latest commit
  # push tag to remote
}

function release_find_the_latest {
# buggy tk
# find the latest release that was pushed on github

  APP_NAME=$(cat Dockerfile | grep APP_NAME= | head -n 1 | grep -o '".*"' | sed 's/"//g')
  GITHUB_ORG=$(cat Dockerfile | grep GITHUB_ORG= | head -n 1 | grep -o '".*"' | sed 's/"//g')

  if [[ -z "${APP_NAME}" ]] ; then    #if empty
    clear
    my_message="Can't find APP_NAME in the Dockerfile." App_Pink
    App_Stop
  elif [[ -z "${GITHUB_ORG}" ]] ; then    #if empty
    clear
    my_message="Can't find GITHUB_ORG in the Dockerfile." App_Pink
    App_Stop
  else

    my_message=$(curl -s https://api.github.com/repos/${GITHUB_ORG}/${APP_NAME}/releases/latest | \
      grep tag_name | \
      awk -F ': "' '{ print $2 }' | \
      awk -F '",' '{ print $1 }')

    App_Blue
  fi
}

function list {
  # shortcut
  which
}

function which {
  # list (show) which CMD (functions) are available
  # the standard path is /usr/local/bin/utility.sh

  clear && echo && \
  cat /usr/local/bin/utility.sh | awk '/function /' | awk '{print $2}' | sort -k2 -n | sed '/App_/d' | sed '/main/d' | sed '/utility/d'
}

function log {
  git --no-pager log --decorate=short --pretty=oneline -n25
}
function logs {
  log # alias
}

function hash {
  git rev-parse --short HEAD
}

function stats {
  status # alias
}
function stat {
  status # alias
}
function status {
  git status
}

function info {
  # the need is to quickly see the version of our app
  cat Dockerfile
}

function diff {
  check && echo
  git diff
}

function ci {
  hub ci-status -v $(git rev-parse HEAD)
}

function lint {
  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    redcoolbeans/dockerlint
}

function lint_hado {
# tk wip
  docker run --rm hadolint/hadolint:v1.16.3-4-gc7f877d hadolint --version && echo;

  docker run --rm -i hadolint/hadolint:v1.16.3-4-gc7f877d hadolint \
    --ignore DL3000 \
    - < Dockerfile && \

  echo && \
  docker run -v `pwd`/Dockerfile:/Dockerfile replicated/dockerfilelint /Dockerfile
}

function prt {
# pr theme, theme containous
# work in progress

# pre-requirments
  #git checkout ghostv3-dev && git pull ghostv3-dev # I'm here
  #utility.sh push "my change dummy file"

git checkout ghostv3-staging && git pull ghostv3-staging
# hub sync
git checkout -b mrg-dev-to-staging
git merge --no-ff origin/ghostv3-dev # no fast forward
git push -u origin mrg-dev-to-staging

# hub pull-request

}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# sub fct
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
		  #
		 # #
		#   #
function App_Draft {
# think draft your release in the changelog
# you should use release as it's a sub fct of release

# build the message to insert in the CHANGELOG
  touch ~/temp/tmpfile && rm ~/temp/tmpfile || true
  touch ~/temp/tmpfile2 && rm ~/temp/tmpfile2 || true
  touch ~/temp/tmpfile3 && rm ~/temp/tmpfile3 || true
  touch ~/temp/tmpfile4 && rm ~/temp/tmpfile4 || true

  git_logs="$(git --no-pager log --abbrev-commit --decorate=short --pretty=oneline -n25 | \
    awk '/HEAD ->/{flag=1} /tag:/{flag=0} flag' | \
    sed -e 's/([^()]*)//g' | \
    awk '$1=$1')"

  echo -e "${git_logs}" >> ~/temp/tmpfile2
  # add space at the begining of a line
  sed 's/^/ /' ~/temp/tmpfile2 > ~/temp/tmpfile3
  # add sign "-" at the begining of a line
  sed 's/^/-/' ~/temp/tmpfile3 > ~/temp/tmpfile4

  echo -e "" >> ~/temp/tmpfile
  # insert version
  echo -e "## ${input_2}" >> ~/temp/tmpfile
  echo -e "### ⚡️ Updates" >> ~/temp/tmpfile
  cat ~/temp/tmpfile4 >> ~/temp/tmpfile
  bottle="$(cat ~/temp/tmpfile)"

  # Insert our release notes after pattern "# Release"
  awk -vbottle="$bottle" '/# Releases/{print;print bottle;next}1' CHANGELOG.md > ~/temp/tmpfile
  cat ~/temp/tmpfile | awk 'NF > 0 {blank=0} NF == 0 {blank++} blank < 2' > CHANGELOG.md

  # clean
  rm ~/temp/tmpfile || true
  rm ~/temp/tmpfile2 || true
  rm ~/temp/tmpfile3 || true
  rm ~/temp/tmpfile4 || true

  # Manually edit CHANGELOG in terminal
  nano CHANGELOG.md
}

function App_release {
# it's a sub fct of release
# ensure that 'version' has tag the latest commit
# then, release on github

  App_input2_rule

  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "master" ]]; then

    first_name_author=$(git log | awk '/Author:/' | head -n1 | awk '{print $2}')
    tag_version="${input_2}"
    git_project_name=$(cat Dockerfile | grep GIT_PROJECT_NAME= | head -n 1 | grep -o '".*"' | sed 's/"//g')
    github_org=$(cat Dockerfile | grep GITHUB_ORG= | head -n 1 | grep -o '".*"' | sed 's/"//g')
    git_repo_url="https://github.com/${github_org}/${git_project_name}"
    release_message1="Refer to CHANGELOG.md for details about this release."
    release_message2="This release was packaged and published using https://github.com/firepress-org/bash-script-template"
    release_message3="Enjoy!"

    App_release_check_vars
    
    clear && echo && \
    echo "Let's release version: ${tag_version}" && sleep 0.4 && \

    hub release create -oc \
      -m "${tag_version}" \
      -m "${release_message1}" \
      -m "${release_message2}" \
      -m "${release_message3}" \
      -t "$(git rev-parse HEAD)" \
      "${tag_version}"

    # https://hub.github.com/hub-release.1.html

    echo "${git_repo_url}/releases/tag/${tag_version}"
    
  else
    my_message="You must be a master branch." App_Pink
  fi
}

function App_release_check_vars {
  if [[ -z "${first_name_author}" ]]; then
    my_message="ERROR: first_name_author is empty." App_Pink App_Stop
  elif [[ -z "${tag_version}" ]]; then
    my_message="ERROR: tag_version is empty." App_Pink App_Stop
  elif [[ -z "${git_project_name}" ]]; then
    my_message="ERROR: git_project_name is empty." App_Pink App_Stop
  elif [[ -z "${github_org}" ]]; then
    my_message="ERROR: github_org is empty." App_Pink App_Stop
  elif [[ -z "${git_repo_url}" ]]; then
    my_message="ERROR: git_repo_url is empty." App_Pink App_Stop
  elif [[ -z "${release_message1}" ]]; then
    my_message="ERROR: release_message1 is empty." App_Pink App_Stop
  elif [[ -z "${release_message2}" ]]; then
    my_message="ERROR: release_message2 is empty." App_Pink App_Stop
  elif [[ -z "${release_message3}" ]]; then
    my_message="ERROR: release_message3 is empty." App_Pink App_Stop
  fi
}

function test {
# test our script & fct. Idempotent bash script

  echo "\$1 is now ${input_1}"
  echo "\$2 is now ${input_2}"
  echo "\$3 is now ${input_3}"
  # Useful when trying to find bad variables along 'set -o nounset'

  if [[ ! -z "${input_2}" ]] && [[ "${input_2}" != not-set ]]; then
    my_message="input_2 is not empty" 
    echo && App_Green 
  fi

  # validate that hub is installed
  if [[ $(hub version | grep -c "hub version") == "1" ]]; then
    echo && my_message="Hub is installed." App_Blue
  else
    echo && my_message="Hub is missing. https://github.com/firepress-org/bash-script-template#requirements" App_Pink
  fi

  # validate that Docker is installed
  if [[ $(docker version | grep -c "Client: Docker Engine") == "1" ]]; then
    my_message="Docker is installed." App_Blue
  else
    my_message="Docker is missing. https://github.com/firepress-org/bash-script-template#requirements" App_Pink
  fi

  # validate if current directory is a Git repository
  # git rev-parse --is-inside-work-tree

  my_message="Date is: ${date_sec}" App_Blue
}

function example_array {
  arr=( "hello" "world" "three" )
  
  for i in "${arr[@]}"; do
    echo ${i}
  done
}

function example_figlet {
  docker_image="devmtl/figlet:1.0"
  message="Hey figlet"

  App_figlet
}

function App_figlet {
  docker run --rm ${docker_image} ${message}
}

function App_input2_rule {
# ensure the second attribute is not empty to continue
  if [[ "${input_2}" == "not-set" ]]; then
    my_message="You must provide a valid attribute!" App_Pink
    App_Stop
  fi
}

function App_input3_rule {
# ensure the third attribute is not empty to continue
  if [[ "${input_3}" == "not-set" ]]; then
    my_message="You must provide a valid attribute!" App_Pink
    App_Stop
  fi
}

function App_Stop {
  my_message="Exit 1. Bye bye." App_Pink && sleep 1 && \
  echo && exit 1
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# utilities
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
		  #
		 # #
		#   #
function passgen {
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-25) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}

function passgen_long {
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 48 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-50) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}

function add_license {
# add changelog

cat << EOF > LICENSE_template
Copyright (C) 2019
by Pascal Andy | https://pascalandy.com/blog/now/

Project:
https://github.com/firepress-org/PLACEHOLDER

Find the GNU General Public License V3 at:
https://github.com/pascalandy/GNU-GENERAL-PUBLIC-LICENSE/blob/master/LICENSE.md

Basically, you have to credit the author AND keep the code free and open source.

EOF
}

function add_changelog {
# add changelog

cat << EOF > CHANGELOG_template.md
### About this changelog

Based on this [template](https://gist.github.com/pascalandy/af709db02d3fe132a3e6f1c11b934fe4). Release process at FirePress ([blog post](https://firepress.org/en/software-and-ghost-updates/)). Based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### Status template

- ⚡️ Updates
- 🚀 New feat.
- 🐛 Fix bug
- 🛑 Removed
- 🔑 Security

# Releases

## 0.0.0
### ⚡️ Updates
- placeholder

EOF
}

function add_dockerignore {
# add dockerignore

cat << EOF > .dockerignore_template
.cache
coverage
dist
node_modules
npm-debug
.git

EOF
}

function add_dockerfile {
# add changelog

cat << EOF > Dockerfile_template
# This is a fake Dockerfile.

# Those vars are used broadly outside this very Dockerfile
# Github Action CI and release script (./utility.sh) is consuming variables from here.

ARG VERSION="notset"
ARG APP_NAME="notset"
ARG GIT_PROJECT_NAME="notset-in-docker"
#
ARG ALPINE_VERSION="3.10"
ARG USER="notset"
#
ARG DOCKERHUB_USER="devmtl"
ARG GITHUB_USER="firepress"
ARG GITHUB_ORG="firepress-org"
ARG GITHUB_REGISTRY="registry"

EOF
}
function add_gitignore {
# add gitignore

cat <<EOF > .gitignore_template
# Files
############
.bashcheck.sh
.cache
coverage
dist
node_modules
npm-debug
.env
var-config.sh

# Directories
############
/tmp
/temp

# Compiled source #
###################
*.com
*.class
*.dll
*.exe
*.o
*.so

# Packages #
############
# it's better to unpack these files and commit the raw source
# git has its own built in compression methods
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

# Logs and databases #
######################
*.log
*.sql
*.sqlite

# OS generated files #
######################
.DS_Store
.DS_Store?
.vscode
.Trashes
ehthumbs.db
Thumbs.db
.AppleDouble
.LSOverride
.metadata_never_index

# Thumbnails
############
._*

# Icon must end with two \r
###########################
Icon

# Files that might appear in the root of a volume
#################################################
.DocumentRevisions-V100
.fseventsd
.dbfseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.trash
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.com.apple.timemachine.supported
.PKInstallSandboxManager
.PKInstallSandboxManager-SystemSoftware
.file
.hotfiles.btree
.quota.ops.user
.quota.user
.quota.ops.group
.quota.group
.vol
.efi

# Directories potentially created on remote AFP share
#####################################################
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk
.Mobile*
.disk_*

# Sherlock files
################
TheFindByContentFolder
TheVolumeSettingsFolder
.FBCIndex
.FBCSemaphoreFile
.FBCLockFolder
EOF
}

function App_DefineVariables {
#==============================================
#	Date generators
 date_nano="$(date +%Y-%m-%d_%HH%Ms%S-%N)";
  date_sec="$(date +%Y-%m-%d_%HH%Ms%S)";
  date_min="$(date +%Y-%m-%d_%HH%M)";
 date_hour="$(date +%Y-%m-%d_%HH)XX";
  date_day="$(date +%Y-%m-%d)";
date_month="$(date +%Y-%m)-XX";
 date_year="$(date +%Y)-XX-XX";
          # 2017-02-22_10H24_14-500892448
          # 2017-02-22_10H24_14
          # 2017-02-22_10H24
          # 2017-02-22_10HXX
          # 2017-02-22
          # 2017-02-XX
          # 2017-XX-XX

#==============================================
#	Define color for echo prompts:
  export col_std="\e[39m——>\e[39m"
  export col_grey="\e[39m——>\e[39m"
  export col_blue="\e[34m——>\e[39m"
  export col_pink="\e[35m——>\e[39m"
  export col_green="\e[36m——>\e[39m"
  export col_white="\e[97m——>\e[39m"
  export col_def="\e[39m"

#==============================================
#	Placeholders
#export GITHUB_TOKEN="$(cat ~/secrets_open/token_github/token.txt)"
}
function App_Pink {
  echo -e "${col_pink} ERROR: ${my_message}"
}
function App_Blue {
  echo -e "${col_blue} ${my_message}"
}
function App_Green {
  echo -e "${col_green} ${my_message}"
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# ENTRYPOINT
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
function main() {

  trap script_trap_err ERR
  trap script_trap_exit EXIT

  # shellcheck source=.bashcheck.sh
  source "$(dirname "${BASH_SOURCE[0]}")/.bashcheck.sh"

  App_DefineVariables

  # input management
  input_1=$1
  if [[ -z "$1" ]]; then    #if empty
    clear
    my_message="You must provide at least one attribute." App_Pink
    App_Stop
  else
    input_1=$1
  fi

  if [[ -z "$2" ]]; then    #if empty
    input_2="not-set"
  else
    input_2=$2
  fi

  if [[ -z "$3" ]]; then    #if empty
    input_3="not-set"
  else
    input_3=$3
  fi

  script_init "$@"
  cron_init
  colour_init
  #lock_init system

  # Attribute #1
  # It accept 2 other attributes
  clear
  $1
}

main "$@"
echo

# https://github.com/firepress-org/bash-script-template