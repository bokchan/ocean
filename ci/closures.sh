#!/bin/bash
set -x

# Enables printing of all potential GC allocation sources to stdout
export DFLAGS=-vgc

# Prepare sources
beaver dlang make d2conv || exit 1

# Run tests and write compiler output to temporary file
compiler_output=`mktemp`
beaver dlang make fasttest 2>&1 > $compiler_output || exit 1

# Ensure there are no lines about closure allocations in the output.
# Note explicit check for `grep` exit status 1, i.e. no lines found.
grep -e "closure" $compiler_output
test $? -eq 1 || exit 1
