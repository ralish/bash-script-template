&nbsp;

<p align="center">
  <a href="https://github.com/firepress-org/bashlava">
    <img src="https://user-images.githubusercontent.com/6694151/74113494-746ee100-4b72-11ea-9601-bd7b1d786b41.jpg" width="1024px" alt="FirePress" />
  </a>
</p>

&nbsp;

> BashLaVa makes your bash scripts a bunch of pieces of cakes.

# BashLava

BashLaVa is a utility-first bash framework. The idea is to abstract your workflow to minimize the time to do some repetitive actions.

It's for developers that use git commands regularly. BashLaVa makes following git workflow a breeze without having to leave your terminal or use GitHub GUI.

In other word, the the **agile release cycle** should be something you master. BashLaVa helps you big time to get there.

## Abstraction

The abstraction is deep. In *expert-mode* *(it means, you really know what you do)*, you can accomplish all these steps in **one command**:

Context: you made few commits on your DEV branch. You are ready to release. So you need to:

1. **version** the project
2. **squash** + **rebase** + **merge** code to master (not squashing is possible as well)
3. Generate or **update the CHANGELOG**
4. **tag** with version & **push tag** to master branch
5. push the **release** on GitHub with a template message
6. **reset** your DEV (edge) branch (to avoid any conflicts)
7. Back to work for the next release!

In. One. Command.

&nbsp;

![bashLaVa-help](https://user-images.githubusercontent.com/6694151/74569005-5ecd3300-4f47-11ea-9cbe-a41466b34229.jpg)

&nbsp;

## BashLaVa Demo

Videos WIP

When starting with BashLava, I recommend to use these four commands:

```
c "UPDATE: that feat that does X"
v 3.5.1
m-
r
```


**It also allows you**:

- quickly set your custom scripts (Videos WIP)
- quickly write help function
- hack around  as it's all built with bash

## Installation

Step-by-step on YouTube (video wip)

- 1) git **clone** this repo

- 2) **create a symlink** to your PATH for both files.

```
ln -s /Volumes/myuser/Github/firepress-org/bashlava/bashlava.sh /usr/local/bin/bashlava.sh

ln -s /Volumes/myuser/Github/firepress-org/bashlava/.bashcheck.sh /usr/local/bin/.bashcheck.sh
```

Assuming your $path is `/usr/local/bin`

- 3) **Test your installation**. run: `bashlava.sh test`

## Requirements

- A Mac. I didn't test BashLaVa on other systems. *Let's me know if you want to help for this :)*
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

   Core functions

 c   ...... "commit" all changes + git push | usage: c "FEAT: new rule to avoid this glitch"
 v   ...... "version" update your app | usage: v 1.50.1
 m   ...... "master" (with squash) rebase + merge + update CHANGELOG | usage: m "UPDATE chap 32 + FIX typo"
 m-   ..... "master-" like m but with (no squash) | (no attr)
 r   ...... "release" + push tag + push release on GitHub | (no attr)


   Expert mode

 d   ...... "deploy" all steps (v,m,r) in one command (with squash) | usage: d 3.5.2 "UPDATE chap 32 + FIX typo"
 d-   ..... "deploy" all steps (v,m-,r) in one command (no squash) | usage: d- 3.5.2


   Utilities functions

 ci   ..... "continous integration" CI status from Github Actions (no attr)
 cr   ..... "changelog read" (no attr)
 diff   ... "diff" show me diff in my code (no attr)
 e   ...... "edge" recrete a fresh edge branch from master (no attr)
 gitio   .. "git.io shortner" work only with GitHub repos | usage: shorturl firepress-org ghostfire (opt attr)
 h   ...... "help" alias are also set to: -h, --help, help (no attr)
 hash   ... "hash" Show me the latest hash commit (no attr)
 l   ...... "log" show me the latest commits (no attr)
 list   ... "list" all core functions (no attr)
 log   .... "log" Show me the lastest commits (no attr)
 m-m   .... "master-merge" from edge. Does not update changelog | usage: m- "UPDATE chap 32 + FIX typo"
 mdv   .... "markdown viewer" | usage: mdv README.md
 oe   ..... "out edge" Basic git checkout (no attr)
 om   ..... "out master" Basic git checkout (no attr)
 rr   ..... "release read" Show release from Github (attr is opt)
 s   ...... "status" show me if there is something to commit (no attr)
 sq   ..... "squash" commits | usage: sq 3 "Add fct xyz"
 test   ... "test" test if requirements for bashLaVa are meet (no attr)
 tr   ..... "tag read" tag on master branch (no attr)
 vr   ..... "version read" show app's version from Dockerfile (no attr)


   Accronyms

 attr ==> attribute(s)
 opt ===> optional
 m =====> master branch
 e =====> edge branch (DEV branch if you prefer)
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
