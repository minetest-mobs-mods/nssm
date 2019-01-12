#!/usr/bin/env bash

# Check that all files declared are actually imported

for x in $(ls */*.lua); do
    grep "$x" */*.lua init.lua -q || echo "$x not imported"
done

