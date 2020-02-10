#!/usr/bin/env bash
# Find the latest version of this application:
# https://github.com/firepress-org/bash-script-template

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# Core fct
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
		  #
		 # #
		#   #
function push {
# push commit all & push all changes
# usage: bashlava.sh push "Add fct xyz"
  App_input2_rule

  git status && \
  git add -A && \
  git commit -m "${input_2}" && \
  clear && \
  git push;
}

function master {
# usage bashlava.sh master
# think squash and rebase edge to master (with squash for a clean master branch)
# idea from: https://www.gatsbyjs.org/blog/2020-01-08-git-workflows/

# NoAttributes needed

if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
  echo "Good, lets continue" | 2>/dev/null
else
  my_message="You must push your commit(s) before doing a rebase." App_Pink && App_Stop
fi

# it case we forget
App_Is_changelog
App_Is_dockerfile
App_Is_gitignore

# see logs
clear && logs

# prompt
my_message="What are we about to merge here?" App_Blue
read -p "==> " squash_message

# Update our local state
git checkout master && \
git pull origin master && \

# by using mrg_edge_2_master we can make a clean squash
# remove and create mrg_edge_2_master
git branch -D mrg_edge_2_master || true && \
git checkout -b mrg_edge_2_master && \
# no need to push it to origin (local branch only)

# merge & squash edge to mrg_edge_2_master
git merge --squash edge && \
git commit . -m "${squash_message} /squash" && \

# back to master
git checkout master && \

# rebase (commits are already squashed at this point)
git rebase mrg_edge_2_master && \
#git merge mrg_edge_2_master && \

# fix conflicts if any
  # stage all the changes we just made
  # wrap up the rebase
  # git add . && \
  # git rebase --continue || true

# push updates
git push origin master && \

# clean up
git branch -D mrg_edge_2_master || true && \

# back to branch edge
edge

### confirmation
echo && my_message="<edge> was MERGED into <master>" App_Blue && \
my_message="Back to work!" App_Blue;
}

function master-nosq {
# usage: bashlava.sh master-nosq
# think rebase master from edge no squash
# NoAttributes needed, no prompt

if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
  echo "Good, lets continue" | 2>/dev/null
else
  my_message="You must push your commit(s) before doing a rebase." App_Pink && App_Stop
fi

# Update our local state
git checkout master && \
git pull origin master && \

# rebase
git rebase edge && \

# push updates
git push origin master && \

# back to branch edge
git checkout edge

### confirmation
echo && my_message="Branch <edge> was merged to <master>" App_Blue && \
my_message="Back to work!" App_Blue;
}

function edge {
# usage: bashlava.sh master
# think scrap branch edge and recreate it just like I would start a new feat branch
# it assumes there will be no conflict with anybody else as I'm the only person using 'edge'

if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
  echo "Good, lets continue" | 2>/dev/null
else
  my_message="You must push your commit(s) before doing a rebase." App_Pink && App_Stop
fi

git branch -D edge || true && \
git checkout -b edge && \
git push --set-upstream origin edge -f

### confirmation
echo && \
my_message="<edge> was reCREATED from <master>" App_Blue
}

function cl {
  # think update the CHANGELOG.md by define on which version we are
  # usage: bashlava.sh cl 3.5.1

  App_input2_rule
  App_Is_master
  App_Is_changelog

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

  # then we still need to commit the updates
}

function cl-read {
  # think: Show me the CHANGELOG.md
  input_2="CHANGELOG.md"
  App_input2_rule
  App_glow50
}

function release {
# think push release + tags to github
# at this point we commited our changelog and rebase to master
# usage: bashlava.sh release 1.50.1

  App_input2_rule
  App_Is_master
  App_Is_dockerfile
  App_Is_hub_installed

  # give time to user to CTRL-C if he changes is mind
  min=1 max=4 message="WARNING: is CHANGELOG.md is updated using /cl_update/"
  for ACTION in $(seq ${min} ${max}); do
    echo -e "${col_pink} ${message} ${col_pink}" && sleep 0.4 && clear && \
    echo -e "${col_blue} ${message} ${col_blue}" && sleep 0.4 && clear
  done

  App_Tag

  first_name_author=$(git log | awk '/Author:/' | head -n1 | awk '{print $2}')
  tag_version="${input_2}"
  app_name=$(cat Dockerfile | grep APP_NAME= | head -n 1 | grep -o '".*"' | sed 's/"//g')
  github_user=$(cat Dockerfile | grep GITHUB_USER= | head -n 1 | grep -o '".*"' | sed 's/"//g')
  git_repo_url="https://github.com/${github_user}/${app_name}"
  release_message1="- Refer to CHANGELOG.md for details about this release."
  release_message2="- This release was packaged and published using https://github.com/firepress-org/bashlava"

  App_release_check_vars
  
  clear && echo && \
  echo "Let's release version: ${tag_version}" && sleep 0.4 && \

  hub release create -oc \
    -m "${tag_version}" \
    -m "${release_message1}" \
    -m "${release_message2}" \
    -t "$(git rev-parse HEAD)" \
    "${tag_version}"

  # https://hub.github.com/hub-release.1.html

  echo "${git_repo_url}/releases/tag/${tag_version}"

  edge
}

function App_Tag {
# usage: bashlava.sh tag 1.50.1
# usually used as a sub fct of release

  App_input2_rule
  App_Is_master

  # update tag within the Dockerfile. It might be already updated but sometimes it's not.
  tag_version="${input_2}"
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

function dk_update {
# think: dockerfile update version in our Dockerfile
# usage: bashlava.sh version 1.50.1

  App_input2_rule
  tag_version="${input_2}"

  # update tag within the Dockerfile without "-r1" "-r2"
  ver_in_dockerfile=$(echo ${tag_version} | sed 's/-r.*//g')
  sed -i '' "s/^ARG VERSION=.*$/ARG VERSION=\"${ver_in_dockerfile}\"/" Dockerfile 

  git add . && \
  git commit -m "Updated to version: ${tag_version}" && \
  git push
}

function dk_view {
# think: view version in the dockerfile
  cat Dockerfile | grep -i version
}

function sq {
# usage: bashlava.sh sq 3 "Add fct xyz"
# think: squash. The fct master does squash our commits as well

if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
  echo "Good, lets continue" | 2>/dev/null
else
  my_message="You must push your commit(s) before doing a rebase." App_Pink && App_Stop
fi

App_input2_rule
App_input3_rule

backwards_steps="${input_2}"
git_message="${input_3}"
usage="sq 3 'Add fct xyz'"

git reset --hard HEAD~"${backwards_steps}" && \
git merge --squash HEAD@{1} && \
git push origin HEAD --force && \
git status && \
git add -A && \
git commit -m "${git_message} / squashed" && \
git push;
}

function pr {
  # work in progress
  # hub pull-request

  # pre-requirments
    #git checkout ghostv3-dev && git pull ghostv3-dev # I'm here
    #bashlava.sh push "my change dummy file"

  git checkout ghostv3-staging && git pull ghostv3-staging
  # hub sync
  git checkout -b mrg-dev-to-staging
  git merge --no-ff origin/ghostv3-dev # no fast forward
  git push -u origin mrg-dev-to-staging
}

function release_find_the_latest {
# buggy tk
# find the latest release that was pushed on github

  app_name=$(cat Dockerfile | grep APP_NAME= | head -n 1 | grep -o '".*"' | sed 's/"//g')
  github_user=$(cat Dockerfile | grep GITHUB_USER= | head -n 1 | grep -o '".*"' | sed 's/"//g')

  if [[ -z "${app_name}" ]] ; then    #if empty
    clear
    my_message="Can't find APP_NAME in the Dockerfile." App_Pink
    App_Stop
  elif [[ -z "${github_user}" ]] ; then    #if empty
    clear
    my_message="Can't find GITHUB_USER in the Dockerfile." App_Pink
    App_Stop
  else

    my_message=$(curl -s https://api.github.com/repos/${github_user}/${app_name}/releases/latest | \
      grep tag_name | \
      awk -F ': "' '{ print $2 }' | \
      awk -F '",' '{ print $1 }')

    App_Blue
  fi
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# Rules
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #

function App_Is_master {
  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "master" ]]; then
    echo "Good, lets continue" | 2>/dev/null
  else
    my_message="You must be on the master branch to perform this action." App_Pink
    my_message="Try: go-m" App_Pink && App_Stop
  fi
}

function App_Is_dockerfile {
  if [ -f Dockerfile ]; then
    echo "Good, lets continue" | 2>/dev/null
  else
    my_message="Dockerfile does not exit. Let's create one." App_Pink && init_dockerfile && App_Stop
  fi
}

function App_Is_changelog {
  if [ -f CHANGELOG.md ]; then
    echo "Good, lets continue" | 2>/dev/null
  else
    my_message="CHANGELOG.md does not exit. Let's create one." App_Blue
    init_changelog && \
    App_Stop && echo
  fi
}

function App_Is_gitignore {
  if [ -f .gitignore ]; then
    echo "Good, lets continue" | 2>/dev/null
  else
    my_message=".gitignore does not exit. Let's create one." App_Blue
    init_gitignore && \
    App_Stop && echo
  fi
}

function App_Is_hub_installed {
  if [[ $(hub version | grep -c "hub version") == "1" ]]; then
    echo && my_message="Hub is installed." App_Blue
  else
    echo && my_message="Hub is missing. https://github.com/firepress-org/bash-script-template#requirements" App_Pink
  fi
}

function App_Is_docker_installed {
  if [[ $(docker version | grep -c "Client: Docker Engine") == "1" ]]; then
    my_message="Docker is installed." App_Blue
  else
    my_message="Docker is missing. https://github.com/firepress-org/bash-script-template#requirements" App_Pink
  fi
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

function App_release_check_vars {
  if [[ -z "${first_name_author}" ]]; then
    my_message="ERROR: first_name_author is empty." App_Pink App_Stop
  elif [[ -z "${tag_version}" ]]; then
    my_message="ERROR: tag_version is empty." App_Pink App_Stop
  elif [[ -z "${app_name}" ]]; then
    my_message="ERROR: APP_NAME is empty." App_Pink App_Stop
  elif [[ -z "${github_user}" ]]; then
    my_message="ERROR: GITHUB_USER is empty." App_Pink App_Stop
  elif [[ -z "${git_repo_url}" ]]; then
    my_message="ERROR: git_repo_url is empty." App_Pink App_Stop
  elif [[ -z "${release_message1}" ]]; then
    my_message="ERROR: release_message1 is empty." App_Pink App_Stop
  elif [[ -z "${release_message2}" ]]; then
    my_message="ERROR: release_message2 is empty." App_Pink App_Stop
  fi

  url_to_check=${git_repo_url}
  App_Curlurl
}

function App_Curlurl {
  # must receive var: url_to_check

  UPTIME_TEST=$(curl -Is ${url_to_check} | grep -io OK | head -1);
  MATCH_UPTIME_TEST1="OK";
  MATCH_UPTIME_TEST2="ok";
  #
  if [ "$UPTIME_TEST" = "$MATCH_UPTIME_TEST1" ] || [ "$UPTIME_TEST" = "$MATCH_UPTIME_TEST2" ]; then
    my_message="${url_to_check} <== is online" App_Green
    
  elif [ "$UPTIME_TEST" != "$MATCH_UPTIME_TEST1" ] || [ "$UPTIME_TEST" = "$MATCH_UPTIME_TEST2" ]; then
    my_message="${url_to_check} <== is offline" App_Pink
  fi
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# utilities
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
		  #
		 # #
		#   #

function test {
# test our script & fct. Idempotent bash script

  echo "\$1 value is: ${input_1}"
  echo "\$2 value is: ${input_2}"
  echo "\$3 value is: ${input_3}"
  # Useful when trying to find bad variables along 'set -o nounset'

  App_Is_hub_installed 
  App_Is_docker_installed 

  my_message="Date is: ${date_sec}" App_Blue
}

function which {
  # If needed, you can list your add-on function here as well. We don't list them by default to minimize cluter.
  help-which
  cat /usr/local/bin/bashlava.sh | awk '/function /' | awk '{print $2}' \
    | sort -k2 -n | sed '/App_/d' | sed '/main/d' | sed '/MYCONFIG/d' \
    | sed '/\/usr\/local\/bin\//d' | sed '/utility/d'
}

function App_Stop {
  my_message="(exit 1)" App_Pink && echo && exit 1
}

function help {
  figlet_message="bashLaVa"
  App_figlet && \
  help-main && \
  which
}

function App_figlet {
  docker_image="devmtl/figlet:1.0"
  docker run --rm ${docker_image} ${figlet_message}
}

function App_glow50 {
# markdown viewer for your terminal. Better than cat!

docker run --rm -it \
  -v $(pwd):/sandbox \
  -w /sandbox \
  devmtl/glow:0.2.0 glow ${input_2} | sed -n 12,50p # show the first 60 lines
}

function App_glow {

docker run --rm -it \
  -v $(pwd):/sandbox \
  -w /sandbox \
  devmtl/glow:0.2.0 glow ${input_2}
}

function passgen {
  # password generator. See also "passgen_long" These char are not part of the password to minimize human error: i,I,L,l,o,O,0
  docker run ctr.run/github.com/firepress-org/alpine:master sh -c "/usr/local/bin/random3.sh";
}

function go-m {
  git checkout master # go to master
}
function go-e {
  git checkout edge # go to edge
}

function log {
  git --no-pager log --decorate=short --pretty=oneline -n25
}

function hash {
  git rev-parse --short HEAD
}

function status {
  git status
}

function diff {
  git diff
}

function ci {
  # work along Github Actions CI
  hub ci-status -v $(git rev-parse HEAD)
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# bashlava low-level logic
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #

function add_on {
  # think: every script that should not be under the main bashlava.sh should threated as an add-on.
  # This will make easier to maintain de project, minimise cluter, minimise break changes, easy to accept PR
  source "${addon_fct_path}/help.sh"
  source "${addon_fct_path}/alias.sh"
  source "${addon_fct_path}/examples.sh"
  source "${addon_fct_path}/templates.sh"
  source "${addon_fct_path}/docker.sh"
  source "${addon_fct_path}/utilities.sh"

  # Define your own custom add-on scripts. 
  # `custom_*.sh` file are in part .gitignore so they will not be commited.
  # MYCONFIG
  source "${addon_fct_path}/custom_pascal.sh"
}

function App_DefineVariables {

# MYCONFIG
local_bashlava_path="/Volumes/960G/_pascalandy/11_FirePress/Github/firepress-org/bashlava"
addon_fct_path="${local_bashlava_path}/add-on"

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

#	Define color for echo prompts:
export col_std="\e[39m——>\e[39m"
export col_grey="\e[39m——>\e[39m"
export col_blue="\e[34m——>\e[39m"
export col_pink="\e[35m——>\e[39m"
export col_green="\e[36m——>\e[39m"
export col_white="\e[97m——>\e[39m"
export col_def="\e[39m"
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

function main() {
  # ENTRYPOINT

  trap script_trap_err ERR
  trap script_trap_exit EXIT
  source "$(dirname "${BASH_SOURCE[0]}")/.bashcheck.sh"  # shellcheck 
  App_DefineVariables

  # set empty input. The user must provide 1 to 3 attributes
  input_1=$1
  if [[ -z "$1" ]]; then    #if empty
    clear
    my_message="You must provide at least one attribute!" App_Green
    my_message="Try: 'bashlava.sh help'" App_Green
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

  # safety (must be after setting the empty input)
  set -eou pipefail
    # set -o xtrace # <== Trace the execution of the script (debug)

  script_init "$@"
  cron_init
  colour_init

  # Use add-on scripts
  add_on

  #lock_init system

  # Attribute #1. It accepts two more attributes
  # tk FEAT add logic if 
  clear
  $1
}

main "$@"
echo
