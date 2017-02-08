#! /bin/bash

# thisFile=gitpush.sh

echo "git add *"
git add *
# git reset HEAD $thisFile

echo -n "git commit -m "
read message
git commit -m "$message"

echo git push origin master
git push origin master

