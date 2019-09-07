## bash-script-template


An idempotent `bash script` template using best practices and several useful functions to manage your code.

Useful for your typical DevOps workflow.

## Usage & quick wins

set an alias `alias uu=./utility.sh ` (with a space at the end)

**Example**: test

```
./utility.sh test"

$1 is now test
$2 is now not-set
$3 is now not-set

——> Hub is installed.
——> Docker is installed.
——> Date is: 2019-09-06_23H10s56
```

**Example**: test using attributes

```
./utility.sh test two "The red fox is running."

$1 is now test
$2 is now two
$3 is now The red fox is running.

——> Hub is installed.
——> Docker is installed.
——> Date is: 2019-09-06_23H39s16
```

**Example**: git status

```
./utility.sh stat

On branch edge
Your branch is up to date with 'origin/edge'.

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
	deleted:    dummyfile.md
	modified:   utility.sh

no changes added to commit (use "git add" and/or "git commit -a")
```

**Example**: git push

```

./utility.sh push

——> ERROR: You must provide a Git message.

### ### ###

./utility.sh push "Improve README / Quick win section"

Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 506 bytes | 506.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:firepress-org/bash-script-template.git
   9737dc7..7255277  master -> master
```

**Example**: rebase master (from the branch edge)

```
# 
./utility.sh rbmaster"

Switched to branch 'master'
Your branch is up to date with 'origin/master'.
From github.com:firepress-org/bash-script-template
 * branch            master     -> FETCH_HEAD
Already up to date.
First, rewinding head to replay your work on top of it...
Fast-forwarded master to edge.
Total 0 (delta 0), reused 0 (delta 0)
To github.com:firepress-org/bash-script-template.git
   27d5731..4a2a0e5  master -> master
Switched to branch 'edge'
Your branch is up to date with 'origin/edge'.
——> Diligence: 4a2a0e5 | 4a2a0e5 (master vs edge should be the same)
```

**Example**: list available functions

```
./utility.sh which_func

ci-status
diff
example_array
example_docs
example_figlet
gitignore
hash
lint
log
outedge
outmaster
passfull
passfull_long
push
rbedge
rbmaster
release
sq
stat
test
version
which_func
wip_bisect
```

## Requirements

Some scripts are using:

- [Docker](https://docs.docker.com/install/)
- [Hub](https://github.com/github/hub#installation)

## Files

| File            | Description                                                                                      |
| --------------- |------------------------------------------------------------------------------------------------- |
                      |
| **.bashcheck.sh**   | Designed for sourcing into scripts; contains only those functions unlikely to need modification. |
| **utility.sh**   | Core script which sources in `.bashcheck.sh` and contains those functions likely to be modified. |

## Motivation

It was forked from: https://github.com/ralish/bash-script-template

I write `bash` scripts not infrequently and realised that I often copied a recent script whenever I started writing a new one. This provided me with a basic scaffold to work on and several useful helper functions I'd otherwise likely end up duplicating.

So rather than continually copying old scripts and flensing the irrelevant code, I'm publishing a more formalised template to ease the process for my own usage and anyone else who may find it helpful! Suggestions for improvements are most welcome.

## Controversies

The Bash scripting community is an opinionated one. This is not a bad thing, but it does mean that some decisions made in this template aren't going to be agreed upon by everyone. A few of the most notable ones are highlighted here with an explanation of the rationale.

### errexit (*set -e*)

Conventional wisdom has for a long time held that at the top of every Bash script should be `set -e` (or the equivalent `set -o errexit`). This modifies the behaviour of Bash to exit immediately when it encounters a non-zero exit code from an executed command if it meets certain criteria. This would seem like an obviously useful behaviour in many cases, however, controversy arises both from the complexity of the grammar which determines if a command is eligible for this behaviour and the fact that there are many circumstances where a non-zero exit code is expected and should not result in termination of the script. An excellent overview of the argument against this option can be found in [BashFAQ 105](http://mywiki.wooledge.org/BashFAQ/105).

My personal view is that the benefits of `errexit` outweigh its disadvantages. More importantly, a script which is compatible with this option will work just as well if it is disabled, however, the inverse is not true. By being compatible with `errexit` those who find it useful can use this template without modification while those opposed can simply disable it without issue.

### nounset (*set -u*)

By enabling `set -u` (or the equivalent `set -o nounset`) the script will exit if an attempt is made to expand an unset variable. This can be useful both for detecting typos as well as potentially premature usage of variables which were expected to have been set earlier. The controvery here arises in that many Bash scripting coding idioms rely on referencing unset variables, which in the absence of this option are perfectly valid. Further discussion on this option can be found in [BashFAQ 112](http://mywiki.wooledge.org/BashFAQ/112).

This option is enabled for the same reasons as described above for `errexit`.

## License

- This git repo is under the **GNU V3** license. [Find it here](./LICENSE.md).
