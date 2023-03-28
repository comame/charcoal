#!/bin/bash

set -euxo pipefail

# project root で実行
cd $(dirname $0)/..

default_branch=`git remote show origin | grep 'HEAD branch' | awk '{print $NF}'`

if [[ $default_branch = `git symbolic-ref --short HEAD` ]]; then
  pnpm install

  if [[ `git status --porcelain | grep pnpm-*.lock` ]]; then
    git add pnpm-*.yaml
    git commit -m "chore: pnpm install after publish"
    git push origin $default_branch
  else
    echo 'No diff found after pnpm install'
  fi

  git push origin --tags
else
  echo 'Not in default branch'
fi
