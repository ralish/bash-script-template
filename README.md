&nbsp;

<p align="center">
  <a href="https://github.com/firepress-org/bashlava">
    <img src="https://user-images.githubusercontent.com/6694151/74113494-746ee100-4b72-11ea-9601-bd7b1d786b41.jpg" width="1024px" alt="FirePress" />
  </a>
</p>

&nbsp;

![Screen Shot 2020-02-14 at 10 48 33 AM](https://user-images.githubusercontent.com/6694151/74545859-9623eb80-4f17-11ea-81a5-518ab0a1778f.jpg)

# BashLava

BashLava makes your bash scripts a bunch of pieces of cakes. 

It's for developers that use git commands regularly. BashLava makes following git workflow a breeze without having to leave your terminal or use the GitHub GUI.

Technically speaking, it's a CLI utility *(or a CLI aggregator)*. It's not a CLI per se as it does not directly call APIs. The idea is to abstract a workflow to minimize the time to do some repetitive actions.

## See it in action

<iframe width="560" height="315" src="https://www.youtube.com/embed/6difYNilhXo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

**Per example by typing these four commands**:

```
c "UPDATE: that thing that does X"
v 3.5.1
m 3.5.1
r 3.5.1
```

you will perform all these actions:

- push commits
- rebase or merge code to master (squash when needed)
- Generate CHANGELOG from commits and append the updates into the existing CHANGELOG
- Tag & push master branch
- push the release on Github with a template message
- reset your dev branch (to avoid any conflicts)

**It also allows you**:

- quickly set your custom scripts
- quickly write help function
- hack around it as it's all built with bash
- and more.

## Installation

You must create a symlink to your PATH for both files. Something like this:

```
ln -s /Volumes/myuser/Github/firepress-org/bashlava/bashlava.sh /usr/local/bin/bashlava.sh

ln -s /Volumes/myuser/Github/firepress-org/bashlava/.bashcheck.sh /usr/local/bin/.bashcheck.sh
```

Assuming your $path is `/usr/local/bin`

To confirm everything is running normally, run: `bashlava.sh test`

## Requirements

- [Docker](https://docs.docker.com/install/): (markdown viewer, password generator, lint checker, etc.)
- [Hub](https://github.com/github/hub#installation): needed to push release to Github.
- nano (brew install nano): needed to edit your changelog when the system prompt.

## How To, Examples & Quick wins

<details><summary>Click to expand this section.</summary>
<p>

You should use an alias like: `alias uu=bashlava.sh ` (with a space at the end) to really benefit from this app.

**Example**: test

```
$1 value is: test
$2 value is: not-set
$3 value is: not-set

——> Date is: 2020-02-14_10H49s21
——> Run on Darwin (Mac).

——> Hub is installed.
——> Docker version 19.03.5, build 633a0ea is installed.
```

**Example**: push commit

```
bashlava.sh c "README / Add requirement section"

——> ERROR: You must provide a Git message.
```

**Example**: list available functions

```
bashlava.sh list

   Core functions

 c   ...... "commit" commit all + git push | usage: c "FEAT: new rule to avoid this glitch"
 v   ...... "version" update your app | usage: v 1.50.1 (if no attribute, show actual version)
 m   ...... "master" squash + rebase + merge edge to master + update the CHANGELOG | usage: m 3.5.1
 m-ns   ... "master" rebase (no squash) + merge edge to master + update the CHANGELOG | usage: m-ns 3.5.1
 r   ...... "release" commit CHANGELOG + push release on Github + push tag on master branch | usage: r 3.5.1
 e   ...... "edge" recrete a fresh edge branch from master (no attribute)


   Utilities functions

 ci   ..... "continous integration" CI status from Github Actions (no attribute)
 cr   ..... "changelog read" (no attribute)
 d   ...... "diff" show me diff in my code (no attribute)
 h   ...... "help" alias are also set to: -h, --help, help (no attribute)
 hash   ... "hash" Show me the latest hash commit (no attribute)
 l   ...... "log" show me the latest commits (no attribute)
 list   ... "list" all core functions (no attribute)
 log   .... "log" Show me the lastest commits (no attribute)
 mdv   ..... "markdown viewer" | usage: mdv README.md
 oe   ..... "out edge" Basic git checkout (no attribute)
 om   ..... "out master" Basic git checkout (no attribute)
 rr   ..... "release read" Show release from Github (attribute are optionnal)
 s   ...... "status" show me if there is something to commit (no attribute)
 sq   ..... "squash" commits | usage: sq 3 "Add fct xyz"
 test   ... "test" test if requirements for bashLaVa are meet (no attribute)
 tr   ..... "tag read" the actual tag (no attribute)
 vr   ..... "version read" Show app's version (no attribute)
```

</p>
</details>

## Website hosting

If you are looking for an alternative to WordPress, [Ghost](https://firepress.org/en/faq/#what-is-ghost) might be the CMS you are looking for. Check out our [hosting plans](https://firepress.org/en).

![ghost-v2-review](https://user-images.githubusercontent.com/6694151/64218253-f144b300-ce8e-11e9-8d75-312a2b6a3160.gif)


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
