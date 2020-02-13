#!/usr/bin/env bash


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# OFFICIAL SHORTCUTS
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #

function v { version
}
function vr { version-read
}
function c { push # think push commit commit
}
function m { master
}
function m-ns { master-nosq
}
function r { release
}
function e { edge
}
function l { log
}
function s { status
}
function cr { changelog-read
}
function h { help
}


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#
# DUPLICATE SHORTCUTS
#
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #

function -h { help
}
function --help { help
}
function bashlava { help
}

function m-no { master-nosq
}
function master-ns { master-nosq # think no squash
}
function master-no { master-nosq # think no squash
}

function commit { push # think push commit
}

function udpate { version
}
function dk { version
}

function v-dk { version-df
}
function dk-view { version-df
}

function list { which
}

function logs { log
}

function stats { status
}
function stat { status
}

function pass { passgen
}
function passfull { passgen
}