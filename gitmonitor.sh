#!/bin/bash

UPLOAD_PATH=/root/xxd.github.com/upload

while inotifywait -q -r -e ATTRIB,CLOSE_WRITE,CREATE,DELETE  $UPLOAD_PATH; do
  cd $UPLOAD_PATH
  git add -A
  git commit -a -m 'Commit to Git repository automatically.'
done
