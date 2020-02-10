#!/usr/bin/env bash

function init_license {
cat << EOF > LICENSE_template
Copyright (C) 2020
by Pascal Andy | https://pascalandy.com/blog/now/

Project:
https://github.com/firepress-org/PLACEHOLDER

Find the GNU General Public License V3 at:
https://github.com/pascalandy/GNU-GENERAL-PUBLIC-LICENSE/blob/master/LICENSE.md

Basically, you have to credit the author AND keep the code free and open source.
EOF
}

function init_changelog {
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
help-template
}

function init_dockerignore {
cat << EOF > .dockerignore_template
.cache
coverage
dist
node_modules
npm-debug
.git
EOF
help-template
}

function init_dockerfile {
cat << EOF > Dockerfile_template
###################################
# REQUIRED BY OUR GITHUB ACTION CI
###################################

ARG VERSION="notset"
ARG APP_NAME="notset"
ARG GITHUB_USER="notset"

###################################
# REQUIRED BY THIS SPECIFIC BUILD (start you Dockerile from here if any)
###################################
EOF
help-template
}
function init_gitignore {
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
custom_*.sh
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
help-template
}