&nbsp;

<p align="center">
  <a href="https://github.com/firepress-org/bashlava">
    <img src="https://user-images.githubusercontent.com/6694151/74113494-746ee100-4b72-11ea-9601-bd7b1d786b41.jpg" width="1024px" alt="FirePress" />
  </a>
</p>

&nbsp;

# BashLava

BashLaVa makes your bash scripts a bunch of pieces of cakes. 

It's for developers that use git commands regularly. BashLaVa makes following git workflow a breeze without having to leave your terminal or use the GitHub GUI.

In other word, **the Agile release cycle should be something you master. BashLaVa helps you to get there.**

Technically speaking, it's a CLI utility *(or a CLI aggregator)*. The idea is to abstract a workflow to minimize the time to do some repetitive actions.

The abstraction is deep. In *expert-mode* *(it means, you know what you do no question asked)*, you can accomplish all these steps in **one command**:

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

## BashLaVa Demo - The full git workflow in 120 seconds!

[![bashlava_2020-02-14](https://user-images.githubusercontent.com/6694151/74553076-95458680-4f24-11ea-9447-4882aaa20e19.jpg)](https://youtu.be/6difYNilhXo)

For more explanations, check these videos:

- [BashLaVa - Introduction (step-by-step explanations)](https://youtu.be/jzGva3p7TeY)
- [Maintaining a real project with BashLaVA](https://youtu.be/J5ySPSTUgZA)
- [How to import your own custom bash-scripts into BashLaVa](https://youtu.be/ezY2N2Bdux0)
- [How to install BashLaVa on your Mac](https://youtu.be/g8pVr8-Cimw)

When starting with BashLava, I recommend to use these four commands:

```
c "UPDATE: that feat that does X"
v 3.5.1
m-
r
```


**It also allows you**:

- [quickly set your custom scripts](https://youtu.be/ezY2N2Bdux0)
- quickly write help function
- hack around  as it's all built with bash

## Installation

[Step-by-step on YouTube](https://youtu.be/g8pVr8-Cimw)

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

 c   ...... "commit" all changes + git push | usage: c "FEAT: new rule to avoid this glitch"
 v   ...... "version" update your app | usage: v 1.50.1 (+ no attribute)
 m   ...... "master" .. squash + rebase + merge edge to m + update the CHANGELOG | usage: m 3.5.1
 m-ns   ... "master" no squash + rebase + merge edge to m + update the CHANGELOG | usage: m 3.5.1
 r   ...... "release" generate CHANGELOG + push tag on m + push r on GitHub| usage: r 3.5.1


   Utilities functions

  ci   ..... "continous integration" CI status from Github Actions (no attribute)
 cr   ..... "changelog read" (no attribute)
 d   ...... "diff" show me diff in my code (no attribute)
 e   ...... "edge" recrete a fresh edge branch from master (no attribute)
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
 shorturl   "shortner" limited github repos | usage: shorturl firepress-org ghostfire (+ no attribute)
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
