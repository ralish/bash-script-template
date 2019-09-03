## bash-script-template


A `bash` scripting template incorporating best practices & several useful functions.

Forked from: https://github.com/ralish/bash-script-template

## Quick wins

set an alias `alias uu=./utility.sh ` (with a space at the end)

**Example 1A:**

```
./utility.sh test"

$1 is now test
$2 is now not-set
$3 is now not-set

```

**Example 1B:**

```
./utility.sh test two "three and something"

$1 is now test
$2 is now two
$3 is now three and something

```

**Example 2A:**

```
./utility.sh push

——> ERROR: You must provide a Git message.
```

**Example 2B:**

```
./utility.sh update "Improve README / Quick win section"

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

**Example 3:**

```
./utility.sh docs"

  Doc (documentation):

  This text is used as a placeholder. Words that will follow won't
  make any sense and this is fine. At the moment, the goal is to
  build a structure for our site.

  Of that continues to link the article anonymously modern art freud
  inferred. Eventually primitive brothel scene with a distinction. The
  Enlightenment criticized from the history.
```

**Example 4:** (requires docker on your machine)

```
# 
./utility.sh figlet"

 _   _               __ _       _      _
| | | | ___ _   _   / _(_) __ _| | ___| |_
| |_| |/ _ \ | | | | |_| |/ _` | |/ _ \ __|
|  _  |  __/ |_| | |  _| | (_| | |  __/ |_
|_| |_|\___|\__, | |_| |_|\__, |_|\___|\__|
            |___/         |___/
```

## Motivation

I write `bash` scripts not infrequently and realised that I often copied a recent script whenever I started writing a new one. This provided me with a basic scaffold to work on and several useful helper functions I'd otherwise likely end up duplicating.

So rather than continually copying old scripts and flensing the irrelevant code, I'm publishing a more formalised template to ease the process for my own usage and anyone else who may find it helpful! Suggestions for improvements are most welcome.

## Files


| File            | Description                                                                                      |
| --------------- |------------------------------------------------------------------------------------------------- |
| **template.sh** | A fully self-contained script which combines `source.sh` & `script.sh`.                          |
| **source.sh**   | Designed for sourcing into scripts; contains only those functions unlikely to need modification. |
| **script.sh**   | Sample script which sources in `source.sh` and contains those functions likely to be modified.   |
| **build.sh**    | Generates `template.sh` by combining `source.sh` & `template.sh`. Just a helper script for me.   |

## Usage

Being a Bash script you're free to *slice-and-dice* the source as you see fit.

The following steps outline what's typically involved to help you get started:

1. Choose between using either:
    1. `template.sh` (fully self-contained)
    2. `script.sh` with `source.sh` (source in most functions)
2. Depending on your choice open `template.sh` or `script.sh` for editing
3. Update the `script_usage()` function with additional usage guidance
4. Update the `parse_params()` function with additional script parameters
5. Add additional functions to implement the desired functionality
6. Update the `main()` function to call your additional functions

### Adding a `hostname` parameter

The following contrived example demonstrates how to add a parameter to display the system's hostname.

Update the `script_usage()` function by inserting the following before the `EOF`:  

```plain
    --hostname                  Display the system's hostname
```

Update the `parse_params()` function by inserting the following before the default case statement (`*)`):  

```bash
--hostname)
    hostname=true
    ;;
```

Update the `main()` function by inserting the following after the existing initialisation statements:  

```bash
if [[ -n ${hostname-} ]]; then
    pretty_print "Hostname is: $(hostname)"
fi
```

## Controversies

The Bash scripting community is an opinionated one. This is not a bad thing, but it does mean that some decisions made in this template aren't going to be agreed upon by everyone. A few of the most notable ones are highlighted here with an explanation of the rationale.

### errexit (*set -e*)

Conventional wisdom has for a long time held that at the top of every Bash script should be `set -e` (or the equivalent `set -o errexit`). This modifies the behaviour of Bash to exit immediately when it encounters a non-zero exit code from an executed command if it meets certain criteria. This would seem like an obviously useful behaviour in many cases, however, controversy arises both from the complexity of the grammar which determines if a command is eligible for this behaviour and the fact that there are many circumstances where a non-zero exit code is expected and should not result in termination of the script. An excellent overview of the argument against this option can be found in [BashFAQ 105](http://mywiki.wooledge.org/BashFAQ/105).

My personal view is that the benefits of `errexit` outweigh its disadvantages. More importantly, a script which is compatible with this option will work just as well if it is disabled, however, the inverse is not true. By being compatible with `errexit` those who find it useful can use this template without modification while those opposed can simply disable it without issue.

### nounset (*set -u*)

By enabling `set -u` (or the equivalent `set -o nounset`) the script will exit if an attempt is made to expand an unset variable. This can be useful both for detecting typos as well as potentially premature usage of variables which were expected to have been set earlier. The controvery here arises in that many Bash scripting coding idioms rely on referencing unset variables, which in the absence of this option are perfectly valid. Further discussion on this option can be found in [BashFAQ 112](http://mywiki.wooledge.org/BashFAQ/112).

This option is enabled for the same reasons as described above for `errexit`.

## License

All content is licensed under the terms of [The MIT License](LICENSE).
