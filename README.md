&nbsp;

<p align="center">
    Brought to you by
</p>

<p align="center">
  <a href="https://firepress.org/">
    <img src="https://user-images.githubusercontent.com/6694151/50166045-2cc53000-02b4-11e9-8f7f-5332089ec331.jpg" width="340px" alt="FirePress" />
  </a>
</p>

<p align="center">
    <a href="https://firepress.org/">FirePress.org</a> |
    <a href="https://play-with-ghost.com/">play-with-ghost</a> |
    <a href="https://github.com/firepress-org/">GitHub</a> |
    <a href="https://twitter.com/askpascalandy">Twitter</a>
    <br /> <br />
</p>

&nbsp;

# [bash-script-template](https://github.com/firepress-org/bash-script-template)


## What is this?

An idempotent `bash script` template using best practices for bash. It includes several useful functions (sub-scripts) to manage your code on GitHub.


## How to, Examples & Quick wins

<details><summary>Expand content (click here).</summary>
<p>

You should use an alias like: `alias uu=./utility.sh ` (with a space at the end) to really benefit from this app.

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
./utility.sh which

add_changelog
add_dockerfile
add_gitignore
add_license
ci
diff
example_array
example_docs
example_figlet
hash
lint
log
outedge
outmaster
passfull
passfull_long
push
pushcl
rbedge
rbmaster
release
sq
stat
test
updatecl
version
which
```

</p>
</details>


## Requirements

Some scripts are using:

- [Docker](https://docs.docker.com/install/)
- [Hub](https://github.com/github/hub#installation)


## Website hosting

If you are looking for an alternative to WordPress, [Ghost](https://firepress.org/en/faq/#what-is-ghost) might be the CMS you are looking for. Check out our [hosting plans](https://firepress.org/en).

![ghost-v2-review](https://user-images.githubusercontent.com/6694151/64218253-f144b300-ce8e-11e9-8d75-312a2b6a3160.gif)


## Motivation, Files, Opinionated scripts, errexit, nounset

<details><summary>Expand content (click here).</summary>
<p>

## Motivation

I write `bash` scripts not infrequently and realised that I often copied a recent script whenever I started writing a new one. This provided me with a basic scaffold to work on and several useful helper functions I'd otherwise likely end up duplicating.

So rather than continually copying old scripts and flensing the irrelevant code, I'm publishing a more formalised template to ease the process for my own usage and anyone else who may find it helpful! Suggestions for improvements are most welcome.

This project was forked from: https://github.com/ralish/bash-script-template

## Files

- **.bashcheck.sh**: Designed for sourcing into scripts; contains only those functions unlikely to need modification.
- **utility.sh**: Core script which sources in `.bashcheck.sh` and contains those functions likely to be modified.

## Controversies

The Bash scripting community is an opinionated one. This is not a bad thing, but it does mean that some decisions made in this template aren't going to be agreed upon by everyone. A few of the most notable ones are highlighted here with an explanation of the rationale.

## errexit (*set -e*)

Conventional wisdom has for a long time held that at the top of every Bash script should be `set -e` (or the equivalent `set -o errexit`). This modifies the behaviour of Bash to exit immediately when it encounters a non-zero exit code from an executed command if it meets certain criteria. This would seem like an obviously useful behaviour in many cases, however, controversy arises both from the complexity of the grammar which determines if a command is eligible for this behaviour and the fact that there are many circumstances where a non-zero exit code is expected and should not result in termination of the script. An excellent overview of the argument against this option can be found in [BashFAQ 105](http://mywiki.wooledge.org/BashFAQ/105).

My personal view is that the benefits of `errexit` outweigh its disadvantages. More importantly, a script which is compatible with this option will work just as well if it is disabled, however, the inverse is not true. By being compatible with `errexit` those who find it useful can use this template without modification while those opposed can simply disable it without issue.

## nounset (*set -u*)

By enabling `set -u` (or the equivalent `set -o nounset`) the script will exit if an attempt is made to expand an unset variable. This can be useful both for detecting typos as well as potentially premature usage of variables which were expected to have been set earlier. The controvery here arises in that many Bash scripting coding idioms rely on referencing unset variables, which in the absence of this option are perfectly valid. Further discussion on this option can be found in [BashFAQ 112](http://mywiki.wooledge.org/BashFAQ/112).

This option is enabled for the same reasons as described above for `errexit`.

</p>
</details>


## Why, Contributing, License

<details><summary>Expand content (click here).</summary>
<p>

## Why all this work?

Our [mission](https://firepress.org/en/our-mission/) is to empower freelancers and small organizations to build an outstanding mobile-first website.

Because we believe your website should speak up in your name, we consider our mission completed once your site has become your impresario.

Find me on Twitter [@askpascalandy](https://twitter.com/askpascalandy).

— [The FirePress Team](https://firepress.org/) 🔥📰

## Contributing

The power of communities pull request and forks means that `1 + 1 = 3`. You can help to make this repo a better one! Here is how:

1. Fork it
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Check this post for more details: [Contributing to our Github project](https://pascalandy.com/blog/contributing-to-our-github-project/). Also, by contributing you agree to the [Contributor Code of Conduct on GitHub](https://pascalandy.com/blog/contributor-code-of-conduct-on-github/). 

## License

- This git repo is under the **GNU V3** license. [Find it here](./LICENSE).

</p>
</details>
