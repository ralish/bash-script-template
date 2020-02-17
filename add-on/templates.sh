#!/usr/bin/env bash

function init_changelog {
cat << EOF > CHANGELOG_template.md
This changelog is based on this [template](https://github.com/firepress-org/bashlava/blob/master/add-on/templates.sh#L3). That's the way we release our code at FirePress ([blog post](https://firepress.org/en/software-and-ghost-updates/)). It's based on [keep a changelog](https://keepachangelog.com/en/1.0.0/) and it adheres to [semantic versioning](https://semver.org/spec/v2.0.0.html).

Status template:
| ⚡️ Updates | 🚀 Added | ⚠️ Changed |
🐛 Fixed | 🛑 Removed | 🔑 Security |
🙈 Oops | 🎨 Design | 🎉 happy | 🙌 blessed

# Releases

## 0.0.0
### ⚡️ Updates
- placeholder
EOF
my_message="File created: ${local_bashlava_path}/CHANGELOG_template.md" App_Green
}

function init_dockerfile {
cat << EOF > Dockerfile_template
###################################
# REQUIRED for bashLaVa https://github.com/firepress-org/bashlava
# REQUIRED for Github Action CI template https://github.com/firepress-org/ghostfire/tree/master/.github/workflows
###################################

ARG VERSION="notset"
ARG APP_NAME="notset"
ARG GITHUB_USER="notset"

###################################
# Start you Dockerfile from here (if any)
###################################
EOF
my_message="File created: ${local_bashlava_path}/Dockerfile_template" App_Green
}

function init_gitignore {
cat <<EOF > .gitignore_template
# Files
############
custom_*.sh
env_local_path.sh
.env
.cache
coverage
dist
node_modules
npm-debug

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
my_message="File created: ${local_bashlava_path}/init_gitignore" App_Green
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
}

function init_license {
# two things two update here
# project URL
# URL to LICENSE.md (you should fork it)
cat << EOF > LICENSE_template
Copyright (C) 2020
by Pascal Andy | https://pascalandy.com/blog/now/

Project:
https://github.com/owner-here/project-here

At the essence, you have to credit the author AND you have
to keep the code free AND you have to keep the code open-source AND you 
cannot repackage this code for any commercial endeavour.

Find the GNU General Public License V3 at:
https://github.com/pascalandy/GNU-GENERAL-PUBLIC-LICENSE/blob/master/LICENSE.md
EOF
my_message="File created: ${local_bashlava_path}/LICENSE_template" App_Green
}

function init_readme {
cat << EOF > README_template.md
This README is still empty.
EOF
}

# optional as not everyone needs this option
function init_dockerfile_ignore {
cat << EOF > .dockerfile_template
.cache
coverage
dist
node_modules
npm-debug
.git
EOF

}