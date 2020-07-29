#!/bin/sh -l

echo "GITHUB_REPO: $GITHUB_REPOSITORY"
echo "GITHUB_SHA: $GITHUB_SHA"

ls -la

ruby /repo-scan.rb

cat hipspec-data.json

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
