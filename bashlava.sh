#!/usr/bin/env bash

#
  #
    #
      #
        #
          #
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# GIT WORKFLOW
#
#   push commits, update CHANGELOG, rebase or merge, squash (when needed)
#   tag and push the release. All without leaving the terminal!
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
          #
        #
      #
    #
  #
#

function commit {
  # if no attribute were past, well... let's see what changed:
  if [[ "${input_2}" == "not-set" ]]; then
    diff
  fi

  App_Is_Input2
  git status && git add -A && \
  git commit -m "${input_2}" && clear && git push;
}

function version {
  # The version is tracked in the Dockerfile (even if you don't use docker)

  App_Is_dockerfile

  # when no attrbutes are passed
  if [[ "${input_2}" == "not-set" ]]; then
    my_message="Three version checkpoints:" && App_Blue &&\
    version-read &&\
    tag-read &&\
    release-read && echo &&\
    my_message="To update the project's version, please use this format: v 3.5.1" && App_Warning && App_Stop
  fi

  App_Is_Input2
  App_Is_edge

  tag_version="${input_2}"
  App_UpdateDockerfileVersion && \

  App_GetVarFromDockerile
  git add . && \
  git commit . -m "Update ${app_name} to version ${app_version} (Dockerfile)" && \
  git push origin edge

  echo && my_message="run ci to check status of your built on Github Actions (if any)" App_Blue
}

function master {
  if [[ "${input_2}" == "not-set" ]]; then
    version-read
  fi
  App_Is_Input2
  App_Is_commit_unpushed
  App_Is_changelog
  App_Is_dockerfile
  App_Is_gitignore
  log
  
  # prompt
  my_message="Squash message of what we want to merge:" App_Blue
  read -p ">>> " squash_message

  # Update our local state
  git checkout master && \
  git pull origin master && \

  # by using mrg_edge_2_master we create one clean squashed commit
  # remove and create mrg_edge_2_master
  git branch -D mrg_edge_2_master || true && \
  git checkout -b mrg_edge_2_master && \
  # no need to push it to origin (local branch only)

  # merge & squash edge into mrg_edge_2_master
  git merge --squash edge && \
  git commit . -m "${squash_message} (squash)" && \

  # back to master
  git checkout master && \
  # rebase (commits are already squashed at this point)
  git rebase mrg_edge_2_master && \

    # fix conflicts manually if any, then
    # git add . && \
    # git rebase --continue || true

  # push updates
  git push origin master && \
  # clean up
  git branch -D mrg_edge_2_master || true true && echo;

  # update CHANGELOG
  export tag_version="${input_2}"
  App_Changelog_Update

  # next step is: release
}

function master-nosq {
  if [[ "${input_2}" == "not-set" ]]; then
    version-read
  fi
  App_Is_Input2
  App_Is_commit_unpushed
  App_Is_changelog
  App_Is_dockerfile
  App_Is_gitignore

  # Update our local state
  git checkout master && \
  git pull origin master && \
  # rebase
  git rebase edge && \
  git push origin master && echo;
  # update CHANGELOG
  export tag_version="${input_2}"
  App_Changelog_Update
  # next setp is: release
}

function release {
  # at this point or changelog is clean.
  App_Is_Input2
  App_Is_master
  App_GetVarFromDockerile

  # push updates
  git commit . -m "Update ${app_name} to version ${app_version} (CHANGELOG)" && \
  git push origin master && \

  App_Is_dockerfile
  App_Is_hub_installed

  # Tag our release
  git tag ${app_version} && git push --tags && echo

  # prepared release
  release_message1="Refer to [CHANGELOG.md](https://github.com/${github_user}/${app_name}/blob/master/CHANGELOG.md) for details about this release."
  release_message2="Released with [bashLaVa](https://github.com/firepress-org/bashlava). You should try it, it's addictive."

  # push release
  hub release create -oc \
    -m "${app_version}" \
    -m "${release_message1}" \
    -m "${release_message2}" \
    -t "$(git rev-parse HEAD)" \
    "${app_version}" && \

  echo && my_message="https://github.com/${github_user}/${app_name}/releases/tag/${app_version}" App_Blue && \
  edge

  # let's cheers up a bit!
  clear && figlet_message="Good job!" App_figlet;
  figlet_message="${app_version} is up." App_figlet;
}

function changelog-read {
  input_2="CHANGELOG.md"
  App_Is_Input2
  App_glow50
}

function edge { 
  # it assumes there will be no conflict with anybody else as I'm the only person using 'edge'
  App_Is_commit_unpushed

  git branch -D edge || true && \
  git checkout -b edge && \
  git push --set-upstream origin edge -f && \
  echo && my_message="<edge> was create from scratch (from <master>)" App_Blue
}

function squash {
  App_Is_commit_unpushed
  App_Is_Input2
  App_Is_Input3

  backwards_steps="${input_2}"
  git_message="${input_3}"
  usage="sq 3 'Add fct xyz'"

  git reset --hard HEAD~"${backwards_steps}" && \
  git merge --squash HEAD@{1} && \
  git push origin HEAD --force && \
  git status && \
  git add -A && \
  git commit -m "${git_message} (squash)" && \
  git push;

  log
}

#
  #
    #
      #
        #
          #
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# OFFICIAL SHORTCUTS
# core> | we use it in order to 'grep' it in our fct list
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
          #
        #
      #
    #
  #
#
function c { #core> ...... "commit" all changes + git push | usage: c "FEAT: new rule to avoid this glitch"
  commit
}
function v { #core> ...... "version" update your app | usage: v 1.50.1 (+ no attribute)
  version
}
function m { #core> ...... "master" .. squash + rebase + merge edge to m + update the CHANGELOG | usage: m 3.5.1
  master
}
function m-ns { #core> ... "master" no squash + rebase + merge edge to m + update the CHANGELOG | usage: m 3.5.1
  master-nosq
}
function r { #core> ...... "release" generate CHANGELOG + push tag on m + push r on GitHub| usage: r 3.5.1
  release
}

function vr { #util> ..... "version read" Show app's version (no attribute)
  version-read
}
function rr { #util> ..... "release read" Show release from Github (attribute are optionnal)
  release-read
}
function tr { #util> ..... "tag read" the actual tag (no attribute)
  tag-read
}
function mdv { #util> ..... "markdown viewer" | usage: mdv README.md
  clear
  App_Is_Input2
  App_glow
}
function ci { #util> ..... "continous integration" CI status from Github Actions (no attribute)
  continuous-integration-status
}
function om { #util> ..... "out master" Basic git checkout (no attribute)
  git checkout master
}
function oe { #util> ..... "out edge" Basic git checkout (no attribute)
  git checkout edge
}
function l { #util> ...... "log" show me the latest commits (no attribute)
  log
}
function sq { #util> ..... "squash" commits | usage: sq 3 "Add fct xyz"
  squash
}
function e { #util> ...... "edge" recrete a fresh edge branch from master (no attribute)
  edge
}
function d { #util> ...... "diff" show me diff in my code (no attribute)
  diff
}
function s { #util> ...... "status" show me if there is something to commit (no attribute)
  status
}
function cr { #util> ..... "changelog read" (no attribute)
  changelog-read
}
function h { #util> ...... "help" alias are also set to: -h, --help, help (no attribute)
  help
}

function log { #util> .... "log" Show me the lastest commits (no attribute)
    git log --all --decorate --oneline --graph --pretty=oneline -n20
}
function hash { #util> ... "hash" Show me the latest hash commit (no attribute)
  git rev-parse HEAD && git rev-parse --short HEAD 
}
function tag-read {
  latest_tag="$(git describe --tags --abbrev=0)"
  my_message="${latest_tag} < latest commited tag on master branch" App_Blue
}
function status { git status
}
function diff { git diff
}

function help {
  figlet_message="bashLaVa" App_figlet && help-main && list
}

function test { #util> ... "test" test if requirements for bashLaVa are meet (no attribute)
# test our script & fct. Idempotent bash script

  echo "\$1 value is: ${input_1}" &&\
  echo "\$2 value is: ${input_2}" &&\
  echo "\$3 value is: ${input_3}" && echo &&\
  my_message="Date is: ${date_sec}" App_Blue &&\

  if [[ $(uname) == "Darwin" ]]; then
    my_message="Run on Darwin (Mac)." App_Blue
  else
    my_message="bashLaVa is not tested on other machine than Darmin (Mac)." App_Warning
  fi

  echo &&\
  App_Is_dockerfile &&\
  App_Is_changelog &&\
  App_Is_gitignore &&\
  App_Is_hub_installed &&\
  App_Is_docker_installed
}

function continuous-integration-status {
  # Valid for Github Actions CI. Usually the CI build our Dockerfiles
  # while loop for 8 min
  MIN="1" MAX="300"
  for action in $(seq ${MIN} ${MAX}); do
    hub ci-status -v $(git rev-parse HEAD) && echo && sleep 5;
  done
}

function list { #util> ... "list" all core functions (no attribute)
  title-core-fct &&\
  cat /usr/local/bin/bashlava.sh | awk '/#core> /' | awk '{$1="";$3="";$4="";print $0}' | sed '/\/usr\/local\/bin\//d' && echo &&\
  title-utilities-fct &&\
  cat /usr/local/bin/bashlava.sh | awk '/#util> /' | awk '{$1="";$3="";$4="";print $0}' | sort -k2 -n | sed '/\/usr\/local\/bin\//d' && echo

  #cat /usr/local/bin/bashLaVa.sh | awk '/function /' | awk '{print $2}' | sort -k2 -n | sed '/App_/d' | sed '/main/d' | sed '/\/usr\/local\/bin\//d' | sed '/wip-/d'
  #If needed, you can list your add-on fct here as well. We don't list them by default to minimize cluter.
}

function shorturl { #util> "shortner" limited github repos | usage: shorturl firepress-org ghostfire (+ no attribute)
# output example: https://git.io/bashlava

# when no attributes are passed, use configs from the current project.
  if [[ "${input_2}" == "not-set" ]]; then
    App_GetVarFromDockerile
    input_2=${github_user}
    input_3=${app_name}
  fi
  App_Is_Input2
  App_Is_Input3

# generate URL
  clear
  curl -i https://git.io -F \
    "url=https://github.com/${input_2}/${input_3}" \
    -F "code=${input_3}" &&\

# see result
  echo && my_message="Let's open: https://git.io/${input_3}" && App_Blue && sleep 2 &&\
  open https://git.io/${input_3}
}

function version-read {
  App_GetVarFromDockerile
  my_message="${app_version} < version in Dockerfile" App_Blue
}

function release-read {
  # find the latest release that was pushed on github

  # for this project
  if [[ "${input_2}" == "not-set" ]] && [[ "${input_3}" == "not-set" ]] ; then
    App_GetVarFromDockerile
  # for any project on GitHub (ie. pascalandy docker-stack-this)
  else
    github_user=${input_2}
    app_name=${input_3}
  fi

  release_latest=$(curl -s https://api.github.com/repos/${github_user}/${app_name}/releases/latest | \
    grep tag_name | awk -F ': "' '{ print $2 }' | awk -F '",' '{ print $1 }')

  my_message="${release_latest} < released on https://github.com/${github_user}/${app_name}/releases/tag/${release_latest}" && App_Blue
}

function wip-pr {
  # tk work in progress
  # we can reuse much of the work from m
  # hub pull-request

  git checkout ghostv3-staging && git pull ghostv3-staging
  # hub sync
  git checkout -b mrg-dev-to-staging
  git merge --no-ff origin/ghostv3-dev # no fast forward
  git push -u origin mrg-dev-to-staging
}

#
  #
    #
      #
        #
          #
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# CHILD FUNCTIONS
#   (the user don't directly call these fct)
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
          #
        #
      #
    #
  #
#

function App_Changelog_Update {
  App_Is_Input2
  App_Is_master
  App_Is_changelog
  App_UpdateDockerfileVersion
  App_RemoveTmpFiles

  # logs (raw format)
  git_logs="$(git --no-pager log --abbrev-commit --decorate=short --pretty=oneline -n25 | \
    awk '/HEAD ->/{flag=1} /tag:/{flag=0} flag' | \
    sed -e 's/([^()]*)//g' | \
    awk '$1=$1')"

  # copy logs in a file
  echo -e "${git_logs}" > ~/temp/tmpfile2

  # --- Time to reformat the logs

  # find the number of line in this file
  number_of_lines=$(cat ~/temp/tmpfile2 | wc -l | awk '{print $1}')
  App_GetVarFromDockerile
  for lineID in $(seq 1 ${number_of_lines}); do
    hash_to_replace=$(cat ~/temp/tmpfile2 | sed -n "${lineID},${lineID}p;" | awk '{print $1}')
    # create URLs from commits
      # Unlike Ubuntu, OS X requires the extension to be explicitly specified.
      # The workaround is to set an empty string. Here we use ''
    sed -i '' "s/${hash_to_replace}/[${hash_to_replace}](https:\/\/github.com\/${github_user}\/${app_name}\/commit\/${hash_to_replace})/" ~/temp/tmpfile2
  done
  # add space at the begining of a line
  sed 's/^/ /' ~/temp/tmpfile2 > ~/temp/tmpfile3
  # add sign "-" at the begining of a line
  sed 's/^/-/' ~/temp/tmpfile3 > ~/temp/tmpfile4
  # create main file
  echo -e "" >> ~/temp/tmpfile
  # insert H2 title version 
  echo -e "## ${input_2} (${date_day})" >> ~/temp/tmpfile
  # insert H3 Updates
  echo -e "### ⚡️ Updates" >> ~/temp/tmpfile
  # insert our montage to the main file
  cat ~/temp/tmpfile4 >> ~/temp/tmpfile
  # Insert our release notes after pattern "# Release"
  bottle="$(cat ~/temp/tmpfile)"
  awk -vbottle="$bottle" '/# Releases/{print;print bottle;next}1' CHANGELOG.md > ~/temp/tmpfile
  cat ~/temp/tmpfile | awk 'NF > 0 {blank=0} NF == 0 {blank++} blank < 2' > CHANGELOG.md
  App_RemoveTmpFiles && echo &&\

  # The system will open the CHANGELOG, in case you have to edit it.
  nano CHANGELOG.md && echo

  # then run: release
}

function App_RemoveTmpFiles {
  rm ~/temp/tmpfile > /dev/null 2>&1
  rm ~/temp/tmpfile2 > /dev/null 2>&1
  rm ~/temp/tmpfile3 > /dev/null 2>&1
  rm ~/temp/tmpfile4 > /dev/null 2>&1
}

function App_Is_master {
  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "master" ]]; then
    echo "Good, lets continue" > /dev/null 2>&1
  else
    my_message="You must be on <master> branch to perform this action (ERR5681)" App_Pink
    my_message="Try: out-m" App_Blue && App_Stop
  fi
}
function App_Is_edge {
  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "edge" ]]; then
    echo "Good, lets continue" > /dev/null 2>&1
  else
    my_message="You must be on <edge> branch to perform this action (ERR5682)" App_Pink
    my_message="Try: out-e" App_Blue && App_Stop
  fi
}
function App_Is_commit_unpushed {
  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "Good, lets continue" > /dev/null 2>&1
  else
    my_message="You must push your commit(s) before doing a rebase (ERR5683)" App_Pink && App_Stop
  fi
}
function App_Is_dockerfile {
  if [ -f Dockerfile ]; then
    echo "Good, lets continue" > /dev/null 2>&1
  else
    my_message="Dockerfile does not exit. Let's generate one (WAR5684)" App_Warning &&\
    init_dockerfile &&\
    App_Stop && echo
  fi
}
function App_Is_changelog {
  if [ -f CHANGELOG.md ]; then
    echo "Good, lets continue" > /dev/null 2>&1
  else
    my_message="CHANGELOG.md does not exit. Let's generate one (WAR5685)" App_Warning &&\
    init_changelog && \
    App_Stop && echo
  fi
}
function App_Is_gitignore {
  if [ -f .gitignore ]; then
    echo "Good, lets continue" > /dev/null 2>&1
  else
    my_message=".gitignore does not exit. Let's generate one (WAR5686)" App_Warning &&\
    init_gitignore && \
    App_Stop && echo
  fi
}
function App_Is_hub_installed {
  if [[ $(hub version | grep -c "hub version") == "1" ]]; then
    my_message="Hub is installed." App_Blue
  else
    echo && my_message="Hub is missing. See requirements https://github.com/firepress-org/bashlava" App_Pink && \
    open https://github.com/firepress-org/bashlava
  fi
}
function App_Is_docker_installed {
  if [[ $(docker version | grep -c "Client: Docker Engine") == "1" ]]; then
    my_message="$(docker --version) is installed." App_Blue
  else
    my_message="Docker is missing. https://github.com/firepress-org/bash-script-template#requirements" App_Pink
  fi
}
function App_Is_Input2 {
# ensure the second attribute is not empty to continue
  if [[ "${input_2}" == "not-set" ]]; then
    my_message="You must provide a valid attribute (ERR5687)" App_Pink
    App_Stop
  fi
}
function App_Is_Input3 {
# ensure the third attribute is not empty to continue
  if [[ "${input_3}" == "not-set" ]]; then
    my_message="You must provide a valid attribute (ERR5688)" App_Pink
    App_Stop
  fi
}
function App_Curlurl {
  # must receive var: url_to_check
  UPTIME_TEST=$(curl -Is ${url_to_check} | grep -io OK | head -1);
  MATCH_UPTIME_TEST1="OK";
  MATCH_UPTIME_TEST2="ok";
  if [ "$UPTIME_TEST" = "$MATCH_UPTIME_TEST1" ] || [ "$UPTIME_TEST" = "$MATCH_UPTIME_TEST2" ]; then
    my_message="${url_to_check} <== is online" App_Green
  elif [ "$UPTIME_TEST" != "$MATCH_UPTIME_TEST1" ] || [ "$UPTIME_TEST" = "$MATCH_UPTIME_TEST2" ]; then
    my_message="${url_to_check} <== is offline" App_Pink
    my_message="The git up repo is not responding as expected :-/" App_Pink && sleep 5
  fi
}
function App_release_check_vars {
  if [[ -z "${app_name}" ]]; then
    my_message="ERROR: app_name is empty (ERR5691)" App_Pink App_Stop
  elif [[ -z "${app_version}" ]]; then
    my_message="ERROR: app_version is empty (ERR5692)" App_Pink App_Stop
  elif [[ -z "${git_repo_url}" ]]; then
    my_message="ERROR: git_repo_url is empty (ERR5693)" App_Pink App_Stop
  elif [[ -z "${release_message1}" ]]; then
    my_message="ERROR: release_message1 is empty (ERR5694)" App_Pink App_Stop
  elif [[ -z "${release_message2}" ]]; then
    my_message="ERROR: release_message2 is empty (ERR5695)" App_Pink App_Stop
  fi

  url_to_check=${git_repo_url}
  App_Curlurl
}

function App_UpdateDockerfileVersion {
  # expect VAR: $tag_version
  # update ap VERSION  within the Dockerfile.

  # version before
  App_GetVarFromDockerile
  version_before=${app_version}

  # apply update
  tag_version_clean=$(echo $tag_version | sed 's/-r.*//g')
  # sometimes we push 3.15.2-r4, this will clean "-r4"
  sed -i '' "s/^ARG VERSION=.*$/ARG VERSION=\"$tag_version_clean\"/" Dockerfile

  # version after
  App_GetVarFromDockerile
  version_after=${app_version}

  # To debug if needed
      # confirm change was well executed (to dubug id needed)
      #App_GetVarFromDockerile
      #if [[ "${version_before}" == "${version_after}" ]]; then
      #  my_message="${version_before} <== Dockerfile version before" App_Pink
      #  my_message="${version_after} <== Dockerfile version after" App_Pink
      #  my_message="The versions did NOT changed. Is it ok?" App_Pink && sleep 5
      #else
      #  my_message="${version_before} <== Dockerfile version before" App_Green
      #  my_message="${version_after} <== Dockerfile version after" App_Green
      #fi
}

function App_GetVarFromDockerile {
  # Extract vars from our Dockerfile
  app_name=$(cat Dockerfile | grep APP_NAME= | head -n 1 | grep -o '".*"' | sed 's/"//g')
  app_version=$(cat Dockerfile | grep VERSION= | head -n 1 | grep -o '".*"' | sed 's/"//g')
  github_user=$(cat Dockerfile | grep GITHUB_USER= | head -n 1 | grep -o '".*"' | sed 's/"//g')

  if [[ -z "${app_name}" ]] ; then    #if empty
    clear
    my_message="Can't find APP_NAME in the Dockerfile (ERR5679)" App_Pink && App_Stop
  elif [[ -z "${app_version}" ]] ; then    #if empty
    clear
    my_message="Can't find APP_VERSION in the Dockerfile (ERR5680)" App_Pink && App_Stop
  elif [[ -z "${github_user}" ]] ; then    #if empty
    clear
    my_message="Can't find GITHUB_USER in the Dockerfile (ERR5680)" App_Pink && App_Stop
  fi
}

function App_figlet {
  docker run --rm ${docker_img_figlet} ${figlet_message}
}

function App_glow50 {
# markdown viewer for your terminal. Better than cat!
  docker run --rm -it \
    -v $(pwd):/sandbox \
    -w /sandbox \
    ${docker_img_glow} glow ${input_2} | sed -n 12,50p # show the first 60 lines
}

function App_glow {
  docker run --rm -it \
    -v $(pwd):/sandbox \
    -w /sandbox \
    ${docker_img_glow} glow ${input_2}
}

function App_Pink { echo -e "${col_pink} ERROR: ${my_message}"
}
function App_Warning { echo -e "${col_pink} Warning: ${my_message}"
}
function App_Blue { echo -e "${col_blue} ${my_message}"
}
function App_Green { echo -e "${col_green} ${my_message}"
}
function App_Stop { echo -e "${col_pink} exit 1" && echo && exit 1
}

#
  #
    #
      #
        #
          #
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# bashLaVa engine (lol)
#   low-level logic
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
          #
        #
      #
    #
  #
#

function App_Configure_Custom_Path {
  # See README for the installation instructions.
  # Check if project's path is well configured.
  if [ ! -f ${local_bashlava_path}/bashlava.sh ]; then
      my_message="Local path is not valid (ERR5672)" App_Pink &&\
      App_Reset_Custom_path
      my_message="Path was autoreset reset. Try running 'help' again." App_Warning &&\
      App_Stop
  else
      echo "Path is valid. Lets continue." > /dev/null 2>&1
  fi
}

function App_Reset_Custom_path {
  # this find and configure the absolute path for bashLaVa project
  readlink $(which bashlava.sh) > /usr/local/bin/bashlava_path_tmp
  cat /usr/local/bin/bashlava_path_tmp | sed 's/\/bashlava.sh//g' > /usr/local/bin/bashlava_path
  rm /usr/local/bin/bashlava_path_tmp
}

function App_Load_Add_on {
  # every script that should not be under the main bashlava.sh shell script, should threated as an add-on.
  # This will make easier to maintain de project, minimise cluter, minimise break changes, easy to accept PR
  # tk readlink -f `which command`
  source "${local_bashlava_addon_path}/help.sh"
  source "${local_bashlava_addon_path}/alias.sh"
  source "${local_bashlava_addon_path}/examples.sh"
  source "${local_bashlava_addon_path}/templates.sh"
  source "${local_bashlava_addon_path}/utilities.sh"

  # Define your own custom add-on scripts. `custom_*.sh` files are in part .gitignore so they will not be commited.
  source "${local_bashlava_addon_path}/custom_scripts_entrypoint.sh"
}

function App_DefineVariables {

  local_bashlava_path="$(cat /usr/local/bin/bashlava_path)"
  local_bashlava_addon_path="$(cat /usr/local/bin/bashlava_path)/add-on"

#	docker images 
  docker_img_figlet="devmtl/figlet:1.0"
  docker_img_glow="devmtl/glow:0.2.0"

#	Define color for echo prompts:
  export col_std="\e[39m——>\e[39m"
  export col_grey="\e[39m——>\e[39m"
  export col_blue="\e[34m——>\e[39m"
  export col_pink="\e[35m——>\e[39m"
  export col_green="\e[36m——>\e[39m"
  export col_white="\e[97m——>\e[39m"
  export col_def="\e[39m"

#	Date generators
  date_nano="$(date +%Y-%m-%d_%HH%Ms%S-%N)"
    date_sec="$(date +%Y-%m-%d_%HH%Ms%S)"
    date_min="$(date +%Y-%m-%d_%HH%M)"
  date_hour="$(date +%Y-%m-%d_%HH)XX"
    date_day="$(date +%Y-%m-%d)"
  date_month="$(date +%Y-%m)-XX"
  date_year="$(date +%Y)-XX-XX"
            # 2017-02-22_10H24_14-500892448
            # 2017-02-22_10H24_14
            # 2017-02-22_10H24
            # 2017-02-22_10HXX
            # 2017-02-22
            # 2017-02-XX
            # 2017-XX-XX
}

# ENTRYPOINT
function main() {
  
  trap script_trap_err ERR
  trap script_trap_exit EXIT
  source "$(dirname "${BASH_SOURCE[0]}")/.bashcheck.sh"

  # Load variables
  App_DefineVariables
  App_Configure_Custom_Path
  App_Load_Add_on

  # set empty input. The user must provide 1 to 3 attributes
  input_1=$1
  if [[ -z "$1" ]]; then    #if empty
    clear
    my_message="You must provide at least one attribute (ERR5671)" App_Pink && help && App_Stop
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
  # it would be easy to have bashLaVa accept more than 3 attributes.

  script_init "$@"
  cron_init
  colour_init
  #lock_init system
  #set -o xtrace # <==  / Trace the execution of the script to debug (if needed)
  
  # tk input_1: FEAT add logic to confirm the fct exist or not
  clear
  $1
}

main "$@"
echo
