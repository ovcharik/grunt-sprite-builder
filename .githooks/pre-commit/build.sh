#!/usr/bin/env bash

npm run build-task
git add tasks/

npm run build-example
git add -A example/
