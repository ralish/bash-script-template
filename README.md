&nbsp;

<p align="center">
  <a href="https://github.com/firepress-org/bashlava">
    <img src="https://user-images.githubusercontent.com/6694151/74113494-746ee100-4b72-11ea-9601-bd7b1d786b41.jpg" width="1024px" alt="FirePress" />
  </a>
</p>

&nbsp;

# BashLava

BashLava makes your bash scripts a bunch of piece of cakes. With it, you can quickly:

- push commits
- rebase or merge code to master (squash when needed)
- Generate CHANGELOG from commits and append the updates into the existing CHANGELOG
- Tag branch
- push the release on Github
- reset your dev branch (to avoid any conflicts)

It make following Git best practices a breeze without having to leave your terminal or use the GitHub GUI. You should try it, it's addictive.

I also allows you:

- quickly set your custom scripts
- quickly write help function
- hack around it as it's all built with bash
- and more.

### Motivation

WIP (VIDEO)

This core `bashcheck.sh` was forked from: https://github.com/ralish/bash-script-template

## How To, Examples & Quick wins

<details><summary>Click to expand this section.</summary>
<p>

You should use an alias like: `alias uu=bashlava.sh ` (with a space at the end) to really benefit from this app.

**Example**: help

![Screen Shot 2020-02-08 at 10 18 35 PM](https://user-images.githubusercontent.com/6694151/74095577-03232580-4ac1-11ea-936d-eace83e91fe0.jpg)

**Example**: test

```
bashlava.sh test"

$1 is now test
$2 is now not-set
$3 is now not-set

——> Hub is installed.
——> Docker is installed.
——> Date is: 2019-09-06_23H10s56
```

**Example**: test using attributes

```
bashlava.sh test two "The red fox is running."

$1 is now test
$2 is now two
$3 is now The red fox is running.

——> Hub is installed.
——> Docker is installed.
——> Date is: 2019-09-06_23H39s16
```

**Example**: git push

```
bashlava.sh push

——> ERROR: You must provide a Git message.
```

Now with a second attribute:

```
bashlava.sh push "README / Add requirement section"

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

**Example**: list available functions

```
bashlava.sh which

ci
cl-view
diff
dk
dk-view
edge
hash
help
log
master
master-nosq
out-e
out-m
passgen
push
release
sq
status
test
which
```

</p>
</details>


## Website hosting

If you are looking for an alternative to WordPress, [Ghost](https://firepress.org/en/faq/#what-is-ghost) might be the CMS you are looking for. Check out our [hosting plans](https://firepress.org/en).

![ghost-v2-review](https://user-images.githubusercontent.com/6694151/64218253-f144b300-ce8e-11e9-8d75-312a2b6a3160.gif)


## Motivation, Files, Opinionated scripts, errexit, nounset

<details><summary>Click to expand this section.</summary>
<p>

### Installation

You shoud syslink these to the git repo to make future update easy.

example:
```
ln -s $HOME/Github/firepress-org/bashlava/bashlava.sh /usr/local/bin/bashlava.sh
ln -s $HOME/Github/firepress-org/bashlava/.bashcheck.sh /usr/local/bin/.bashcheck.sh
```

Assuming your $path is:

```
/usr/local/bin/utility.sh
/usr/local/bin/bashcheck.sh
```

## Requirements

- [Docker](https://docs.docker.com/install/): use launch few ephemere container like a markdown viewer or a password generator.
- [Hub](https://github.com/github/hub#installation): needed to push release.
- nano (brew install nano): needed to edit your changelog (system prompt).

</p>
</details>

## Why, Contributing, License

<details><summary>Click to expand this section.</summary>
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
