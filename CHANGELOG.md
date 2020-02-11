### About this changelog

Based on this [template](https://gist.github.com/pascalandy/af709db02d3fe132a3e6f1c11b934fe4). Release process at FirePress ([blog post](https://firepress.org/en/software-and-ghost-updates/)). Based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### Status template

- ⚡️ Updates
- 🚀 New feat.
- 🐛 Fix bug
- 🛑 Removed
- 🔑 Security

# Releases

## 0.9.10
### ⚡️ Updates
- [c00720c](https://github.com/firepress-org/bashlava/commit/c00720c) Improve commit message for /dk, /master, /release, /squash

## 0.9.9
### ⚡️ Updates
- [ac350c3](https://github.com/firepress-org/bashlava/commit/ac350c3) Improve release message / better explanation of what bashlava does /squashed

## 0.9.8
### ⚡️ Updates
- [3edfb00](https://github.com/firepress-org/bashlava/commit/3edfb00) Improve Changelog and fix typo / Add /log into /master /squashed

## 0.9.7
### ⚡️ Updates
- [878e2f2](https://github.com/firepress-org/bashlava/commit/878e2f2) Make the local variable more obvious
- [878e2f2](https://github.com/firepress-org/bashlava/commit/878e2f2) Cleaner way to manage custom_scripts
- [878e2f2](https://github.com/firepress-org/bashlava/commit/878e2f2) Better error handling
- [e91a2b4](https://github.com/firepress-org/bashlava/commit/e91a2b4) Adding 3 examples for custom scripts
- [beaa2e0](https://github.com/firepress-org/bashlava/commit/beaa2e0) Improve fct CI / FIX custom_urls.sh
- [36685ea](https://github.com/firepress-org/bashlava/commit/36685ea) Improve template for Dockferfile
- [71602ed](https://github.com/firepress-org/bashlava/commit/71602ed) Improve README

## 0.9.6
As you can see here, our commit hash link back to the actual commit :)

### ⚡️ Updates
- [0d2bec1](https://github.com/firepress-org/bashlava/commit/0d2bec1) App_changelog_update, Improve create URLs from git commits & remove vars during QA
- [2d79b65](https://github.com/firepress-org/bashlava/commit/2d79b65) App_changelog_update, Improve create URLs from git commits, RENAME out-m & out-e
- [6ee27a2](https://github.com/firepress-org/bashlava/commit/6ee27a2) new alias
- [22ead68](https://github.com/firepress-org/bashlava/commit/22ead68) Changelog_Update / create URLs from git commits
- [b27be25](https://github.com/firepress-org/bashlava/commit/b27be25) improved fct log
- [a14ccf7](https://github.com/firepress-org/bashlava/commit/a14ccf7) init alias
- [909c531](https://github.com/firepress-org/bashlava/commit/909c531) improve prompt messages
- [4862c97](https://github.com/firepress-org/bashlava/commit/4862c97) add alias, improve prompt messages
- [1b03630](https://github.com/firepress-org/bashlava/commit/1b03630) FIX logic on /release, improve comments
- [bd1e1c7](https://github.com/firepress-org/bashlava/commit/bd1e1c7) The abstraction is real. /cl is now under /release
- [6769998](https://github.com/firepress-org/bashlava/commit/6769998) dk: add comment
- [5896031](https://github.com/firepress-org/bashlava/commit/5896031) cl-push is now cl thanks to App_Changelog_Update
- [09f32af](https://github.com/firepress-org/bashlava/commit/09f32af) fct dk: add logic to show version when no attributs are passed
- [e8e6861](https://github.com/firepress-org/bashlava/commit/e8e6861) rename dk-version to dk
- [1dfe01a](https://github.com/firepress-org/bashlava/commit/1dfe01a) update Dockerfile template
- [299082d](https://github.com/firepress-org/bashlava/commit/299082d) improve alias
- [fcb4075](https://github.com/firepress-org/bashlava/commit/fcb4075) fct cl FIX var, minor optimzations

## 0.9.5
### ⚡️ Updates
- 45345aa FIX if logic

## 0.9.4
### ⚡️ Updates
- 12bbab0 Fix typo /squash

## 0.9.3
### ⚡️ Updates
- c6570d8 FIX tag when release AND add checkpoints when updating Dockerfile version /squash

## 0.9.2
### ⚡️ Updates
- ffbfbfa Add logic to see actual version when not providing a version in fct master
- 1addff9 help-workflow /major copy update
- 1c28961 fix lost && sign, rename cl-read to cl-view, FIX version within the Dockerfile
- 567788a add alias: dk-show, cl-show
- fb13a87 init cl-push, Update Dockerfile version
- 932756a FIX missing title in CHANGELOG.md

## 0.9.1
### ⚡️ Updates
- FIX img url in README
- c2f8e617e29df22cdcd7dbcc00dcae347f767a03 add checkpoint to fct release

## 0.9.0
This is a important release as it's introducting add-ons. This will be important to scale to project and leave the core elements at there place.

### 🚀 New feat.
- 610dbf0 init add-on/utilities.sh

### ⚡️ Updates
- 16f98cc init fct App_Is_commit_unpushed, merge App_Tag into fct release, Add missing rules, rename dk_update to dk_version
- 20954d5 🚀 update copy for workflow
- e8c86a0 init alias version
- 5d99150 add alias r
- c37344e Init App_is_env_local_path, Init App_Is_hub_installed, move functions by groups
- d01c4e4 removed merge App_release into release
- 937dc03 add checkpoints in fct master
- bc8c187 add alias appversion
- 1bb36a2 rename edge-init to edge
- 5e1f5f8 init App_Is_changelog
- ed6ecae init App_Is_master, App_Is_Dockerfile
- c82fe1c 🚀 refactor fct release
- f7a0551 Optimize Dockerfile template
- 8841eac update README, refactor fct cl, alias c /squash
- 8a0994c various code optimizations
- 610dbf0 init add-on/utilities.sh
- 43b7a90 update add-on/help
- 4b80939 move few fct under add-on/docker
- 2f7d67d update App_Stop

## 0.8.14
### ⚡️ Updates
- 0243fb7 remove dummy files
- 856d4cb Add alias cl-view

## 0.8.13
### ⚡️ Updates
- 3d1a6bf add fct cl-read
- 619ab54 add mdv / squashed

## 0.8.12
### ⚡️ Updates
- d86bb3b changelog update
- 05ff973 add function cl / changelog

## 0.8.11
### ⚡️ Updates
- bb6b2fb4 improve function master AND master-sq
- 51919ad1 remove dummy files
- c6d8279b Merge branch 'master' into edge
- 3ae02d29 add prt, still wip
- bb219693 add new alias
- 9232548c minor fct info updates

## 0.8.10
### ⚡️ Updates
- 4ce5479 Updated to version: 0.8.10
- 74c0b47 add fct info
- faa1bcc reorganise VAR in our fake Dockerfile
- b21aa84 add status alias

## 0.8.9
### ⚡️ Updates
- 3a5be95 Updated to version: 0.8.9
- 92b10a6 Merge branch 'master' into edge
- df3ebf4 Update comment in App_release
- f4bd14c added fct list
- abbce23 Update comment in App_release
- aa4d1b6 added fct list

## 0.8.8
### ⚡️ Updates
- overall reorganisation to make it easier to read

## 0.8.7
### ⚡️ Updates
9157715 Add help, version / Renamed master, edge, release
909ad8e Add fct version

## 0.8.6
### ⚡️ Updates
- 180a9af Improve comments and vars
- 191b3f0 Fix and rename add_dockerignore / squashed
- c6b2f45 Update add_dockerfile template

## 0.8.5
### ⚡️ Updates
- d1c3164 Fix logic where the APP_NAME is not the same as the git repo name
- 0496250 introduce a new var in Dockerfile

## 0.8.4
### ⚡️ Updates
- d1299bb rename fct release_find_the_latest
- 95ae92f Add find_latest_release / squashed

## 0.8.3
### ⚡️ Updates
- 2e9b65f Add fct add_dockerignore, update changelog URL
- 5858e5e Init dockerignore
- af05b49 fct tag / now can be executed on any branches + update CHANGELOG url

## 0.8-r2
### ⚡️ Updates
- 11abc51 FIX release message

## 0.8-r1
### ⚡️ Updates
- a0abfdd Improve functions ordering + README / squashed
- 50b755b Rename passgen / instead passfull
- 65eda6a Rename fct tag / instead of version
- fbbb5fb Improve the dynamic between updatecl and pushcl
- 3b61bd4 Improve README

## 0.7-r4
### ⚡️ Updates
- 89c4f36f Esthetic updates / squashed

## 0.7-r3
### ⚡️ Updates
- 1fb4af1c Improve README / squashed

## 0.7-r2
### ⚡️ Updates
- 0d56c7a1 Improve sq fct
- dd7b7be6 Minor updates to utility.sh

## 0.7-r1
### ⚡️ Updates
- 07bb2a92 Improve release messages

## 0.7-r0
### ⚡️ Updates
43f8ddc9 Overall code improvements

## 0.6-r4
### ⚡️ Updates
- 7c28fe3b Improve pullcl

## 0.6-r3
### ⚡️ Updates
- e6e44b8f 🚀 New feat. Add push_cl

## 0.6-r2
### ⚡️ Updates
- 44b179eb update rbmaster
- 8faf9d7f Improve README examples
- 257f356d 🚀 New feat. Added fct which_func
- 9229df00 improve release
- dc490cdb 🚀 New feat. Add fct log
- ac63cdf8 🚀 New feat. Add fct sq (means squash)
- e7b5816b Improve README
- 27d57316 🚀 New feat. Add logic to version + release fct

## 0.6-r1
### 🚀 Added (new feat.)
- 2x rebase functions

## 0.6-r0
### ⚡️ Updates
- Update fct **version** and **release**.
- **release** fct is now based on https://github.com/github/hub

## 0.5-r2
### ⚡️ Updates
- Update fct check

## 0.5-r1
### ⚡️ Updates
- Improve Prompt before doing a git push
- Testing `utility.sh` / git push, tag, version, release, etc. That's why there are many release today :-p

## 0.5-r0
### ⚡️ Updates
- Improve README

## 0.4-r2
### ⚡️ Updates
- Improve comments

## 0.4-r1
### ⚡️ Updates
- improve comments

## 0.4-r0
### 🚀 Added (new feat.)
- update release fct

## 0.3-r0
### 🚀 Added (new feat.)
- Intensely developed. Ignore this version and any previous versions.
