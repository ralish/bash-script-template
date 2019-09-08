#!/usr/bin/env bash

# Find the latest version of this application: https://github.com/firepress-org/bash-script-template
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)
#
#set -o nounset          # Disallow expansion of unset variables
# --- Find bad variables by using `./utility.sh test two three`, else disable it
# --- or remove $1, $2, $3 var defintions in @main
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# Git
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

function hash {
  git rev-parse --short HEAD
}
function outmaster {
  git checkout master
}
function outedge {
  git checkout edge
}
function stat {
  git status
}
function diff {
  check && echo
  git diff
}
function wip_bisect {
  echo "todo"
}
function ci-status {
  hub ci-status -v $(git rev-parse HEAD)
}
function push {
# commit all
  App_is_input2_empty

  git status && \
  git add -A && \
  git commit -m "${input_2}" && \
  clear
  git push
}
function log {
  git --no-pager log --decorate=short --pretty=oneline -n25
}
function sq {
# squash

  App_is_input2_empty
  App_is_input3_empty

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
function rbmaster {
# think rebase_master_from_edge

  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null
    git checkout master
    git pull origin master
    git rebase edge
    git push
    hash_master_is=$(git rev-parse --short HEAD)
    #
    hash_edge_is=$(git rev-parse --short HEAD)
    my_message="Diligence: ${hash_master_is} | ${hash_master_is} (master vs edge should be the same)" App_Blue

  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}
function rbedge {
# think rebase_edge_from_master

  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null
    git checkout edge
    git pull origin edge
    git rebase master
    git push
    hash_edge_is=$(git rev-parse --short HEAD)
    #
    git checkout master
    hash_master_is=$(git rev-parse --short HEAD)
    git checkout edge
    my_message="Diligence: ${hash_master_is} | ${hash_master_is} (master vs edge should be the same)" App_Blue

  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}
function pushcl {
# push changelog

# Use case: we just updated the CAHNGELOG.md file
# Next, we want to:
  #commit change on changelog.md
  #tag the commit
  #release on github
  #rbedge

  App_is_input2_empty

  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "master" ]]; then

    tag_version="${input_2}"

    version
    release
    rbedge

  else
    my_message="You must be a master branch." App_Pink
  fi

}
function version {
# tag
  
  # what it does:
    # update version in Dockerfile
    # save the commit
    # tag version on the latest commit
    # push tag to remote

  App_is_input2_empty

  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "master" ]]; then

    tag_version="${input_2}"

    # Prompt a warning
    min=1 max=4 message="WARNING: CHANGELOG.md is updated??"
    for ACTION in $(seq ${min} ${max}); do
      echo -e "${col_pink} ${message} ${col_pink}" && sleep 0.4 && clear && \
      echo -e "${col_blue} ${message} ${col_blue}" && sleep 0.4 && clear
    done

    # update version within the Dockerfile
    # We don't want to have "-r1" "-r2" etc within the Dockerfile
    ver_in_dockerfile=$(echo $tag_version | sed 's/-r.*//g')
    sed -i '' "s/^ARG VERSION=.*$/ARG VERSION=\"$ver_in_dockerfile\"/" Dockerfile 

    git add . && \
    git commit -m "Updated to version: $tag_version" && \
    git push && \
    sleep 1 && \
    # push tag
    git tag ${tag_version} && \
    git push --tags
  else
    my_message="You must be a master branch." App_Pink
  fi
}
function release {
  # ensure that 'version' has tag the latest commit
  # then, release on github

  App_is_input2_empty

  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "${currentBranch}" == "master" ]]; then

    first_name_author=$(git log | awk '/Author:/' | head -n1 | awk '{print $2}')
    tag_version="${input_2}"
    git_repo_url=$(cat Dockerfile | grep GIT_REPO_URL= | head -n 1 | grep -o '".*"' | sed 's/"//g')
    release_message1="Refer to [CHANGELOG.md](${git_repo_url}/blob/master/CHANGELOG.md) for details about this release."
    release_message2="This release was packaged and published by using <./utility.sh release>."
    release_message3="Enjoy!<br>${first_name_author}"

    clear && echo && \
    echo "Let's release version: ${tag_version}" && sleep 1 && \

    hub release create -oc \
      -m "${tag_version}" \
      -m "${release_message1}" \
      -m "${release_message2}" \
      -m "${release_message3}" \
      -t "$(git rev-parse HEAD)" \
      "${tag_version}"
    # https://hub.github.com/hub-release.1.html
      # title
      # description
      # on which commits (use the latest)
      # on which tag (use the latest)

    echo "${git_repo_url}/releases/tag/${tag_version}"
    
  else
    my_message="You must be a master branch." App_Pink
  fi
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# DOCKER
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
function lint {
  docker_image="redcoolbeans/dockerlint"

  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    ${docker_image}
}


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# OTHER
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

function test {
# uat, idempotent bash script

  echo "\$1 is now ${input_1}"
  echo "\$2 is now ${input_2}"
  echo "\$3 is now ${input_3}"
  # Useful when trying to find bad variables along 'set -o nounset'

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

function which {
  # list, show which functions are available
  clear
  cat utility.sh | awk '/function /' | awk '{print $2}' | sort -k2 -n | sed '/App_/d' | sed '/main/d' | sed '/utility/d'
}

function App_is_input2_empty {
# ensure the second attribute is not empty to continue
  if [[ "${input_2}" == "not-set" ]]; then
    my_message="You must provide a valid attribute!" App_Pink
    App_stop
  fi
}
function App_is_input3_empty {
# ensure the third attribute is not empty to continue
  if [[ "${input_3}" == "not-set" ]]; then
    my_message="You must provide a valid attribute!" App_Pink
    App_stop
  fi
}

function example_array {
  arr=( "hello" "world" "three" )
  
  for i in "${arr[@]}"; do
    echo ${i}
  done
}
function example_docs {
cat << EOF
  Utility's doc (documentation):

  This text is used as a placeholder. Words that will follow won't
  make any sense and this is fine. At the moment, the goal is to 
  build a structure for our site.

  Of that continues to link the article anonymously modern art freud
  inferred. Eventually primitive brothel scene with a distinction. The
  Enlightenment criticized from the history.
EOF
}
function example_figlet {
  docker_image="devmtl/figlet:1.0"
  message="Hey figlet"

  docker run --rm ${docker_image} ${message}
}
function passfull {
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-25) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}
function passfull_long {
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 48 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-50) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}

function gitignore {
# set and overides .gitignore

cat <<EOF > .gitignore
# Files
############
test
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

function App_stop {
  echo && exit 1
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
    App_stop
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