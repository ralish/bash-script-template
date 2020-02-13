#!/usr/bin/env bash

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# help and README
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
		  #
		 # #
		#   #
function help-main {

cat <<EOF > bashlava_help.md

# help

- To see all available commands, run: list
- To understand the git workflow watch our video:
- ___ https://github.com/firepress-org/bashlava

EOF
input_2="bashlava_help.md"
App_glow && rm bashlava_help.md || true
}

function help-workflow {
cat <<EOF > bashlava_help.md
# Workflows
for https://github.com/firepress-org/ghostfire/

## A) classic Git worklow

We can do a lot with only two commands!

- we are on branch edge and we update code, push commits. Let's push version 3.5.1 of our app.

master 3.5.1 <==

- will squash commits on branch the master
- then, it will trigger cl (will update the version in our CHANGELOG with the latest commits)
- the system will prompt to edit the CHANGELOG (update CHANGELOG if needed). Once CHANGELOG IS CLEAN ...

cl-push <==

- this will push a pre-formated commit: "Update APP to VERSION"
- then, it will trigger <release> (which will push a tag and push the release on GitHub
- then it will trigger <edge>, which is a perform representation of master

## B) alternative worklow

if we don't want to sqaush our commit into master, we can use:

master-nosq 3.5.1 <==
EOF

input_2="bashlava_help.md"
App_glow && rm bashlava_help.md || true
}

function help-bash {
cat <<EOF > bashlava_help.md
## Operator	Description

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

EOF

input_2="bashlava_help.md"
App_glow && rm bashlava_help.md || true
}

function help-pr-process {
cat <<EOF > bashlava_help.md
# Orginal post
- https://www.gatsbyjs.org/blog/2020-01-08-git-workflows/

# Notes

# root branch is feat/headless-cms

git checkout feat/headless-cms-pt2
git rebase feat/headless-cms-pt1

# fix conflicts if any
# stage all the changes we just made
# wrap up the rebase
# git add . && \
# git rebase --continue || true

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

EOF

input_2="bashlava_help.md"
App_glow && rm bashlava_help.md || true
}

function help-template {
cat <<EOF > bashlava_help.md
# Warning

At this point you MUST edit the nnewly created file (i.e Dockerfile, CHANGELOG, etc..), then commit it.
EOF
input_2="bashlava_help.md"
App_glow && rm bashlava_help.md || true
}