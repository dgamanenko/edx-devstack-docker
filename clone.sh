#!/usr/bin/env bash

# Script for cloning Git repos housing edX services. These repos are mounted as
# data volumes into their corresponding Docker containers to facilitate development.
# Repos are cloned to the directory above the one housing this file.

if [ -z "$DEVSTACK_WORKSPACE" ]; then
    echo "need to set workspace dir"
    exit 1
elif [ -d "$DEVSTACK_WORKSPACE" ]; then
    cd $DEVSTACK_WORKSPACE
else
    echo "Workspace directory $DEVSTACK_WORKSPACE doesn't exist"
    exit 1
fi

repos=(
    "https://github.com/edx/course-discovery.git"
    "https://github.com/edx/credentials.git"
    "https://github.com/edx/edx-platform.git:master:9c6d94ada0f2b401aeb5c41b3dbf31a912a80840"
)

name_pattern="(https):\/\/(.*)\/(.*)\/(.*).(git):{0,1}([^:]+){0,}:{0,1}(.*)"

for repo in ${repos[*]}
do
    # Use Bash's regex match operator to capture the name of the repo.
    # Results of the match are saved to an array called $BASH_REMATCH.
    [[ $repo =~ $name_pattern ]]
    name="${BASH_REMATCH[4]}"
    branch="${BASH_REMATCH[6]}"
    commit_hash="${BASH_REMATCH[7]}"
    remote="${BASH_REMATCH[1]}://${BASH_REMATCH[2]}/${BASH_REMATCH[3]}/${BASH_REMATCH[4]}.${BASH_REMATCH[5]}"

    if [ -d "$name" ]; then
        printf "The [%s] repo is already checked out. Continuing.\n" $name
    else
        if [ -z "${branch}" ]; then
            git clone --depth 1 $remote
        else
            if [ -z "${commit_hash}" ]; then
                git clone --depth 1 $remote -b $branch
            else
                git clone --depth 1 $remote -b $branch
                cd $name
                git reset --hard $commit_hash
                cd ..
            fi
        fi
    fi
done
cd - &> /dev/null
