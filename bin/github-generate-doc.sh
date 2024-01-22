#!/bin/bash -eu
script=gisp
readme=README.md
man=gisp.1
if ! podchecker $script; then
  exit 1
fi
curl -L https://cpanmin.us/ -o bin/cpanm
chmod +x bin/cpanm
bin/cpanm -n Pod::Markdown
/usr/local/opt/perl/bin/pod2markdown < $script > README.md
/usr/bin/pod2man -u < $script > $man
if git status -sb | grep -q "$readme\|$man"; then
  # https://qiita.com/thaim/items/3d1a4d09ec4a7d8844ce
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  git add $readme $man
  git commit -m "[ci skip] docs: update doc for ${script##*/}"
  git remote set-url origin git@github.com:"$GITHUB_REPOSITORY"
  branch=${GITHUB_REF#refs/heads/}
  git push origin main:"$branch"
fi
