#!/usr/bin/env bash

# RUN THIS ON YOUR OWN RISK IF THIS SCRIPT DELETES ALL OF YOUR TAGS I WASH MY HANDS OFF OF IT :P

REPO_BASE=`/usr/bin/pwd`

if [ $# -eq 0 ]; then
	echo "No remote folder param provided using current path as repository base"
else
	echo "Seems that repo path is provided, moving to: $1!"
	cd $1
fi

/usr/bin/git status 2&>1 > /dev/null
RESULT=$?

if [ $RESULT -ne 0 ]; then
	echo -e "\n\tNot in git repo, quitting\n"
	exit 1
fi

num=0
MAX=$(git tag | xargs -I@ git log --format=format:"%ai @%n" -1 @ | sort | wc -l)

if [ $MAX -eq 0 ]; then
	echo -e "\n\tThere are no tags available, quitting!\n"
	exit 0
else
	echo "There are $MAX tags available"
fi

read -p "Do you want to list them all sorted by datetime (Y / n)?"
if [[ "$REPLY" =~ ^[Yy]*$ ]]
then
  echo "Here's your list:"
  git tag | xargs -I@ git log --format=format:"%ai @%n" -1 @ | sort
fi

read -p "How many (last) tags do you want to keep? "
re='^[0-9]+$'
if ! [[ $REPLY =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi

DEL=`expr $MAX - $REPLY`

read -p "Are you sure you want to delete $DEL of $MAX tags? This action is not reversable! (Y / n)?"
if [[ "$REPLY" =~ ^[Yy]*$ ]]
then
  for t in `git tag | xargs -I@ git log --format=format:"%ai @%n" -1 @ | sort | awk '{print $4}'`
  do
   if [ "$num" -ge $DEL ]
     then
       break
   fi
   git push origin :$t
   git tag -d $t
   num=`expr $num + 1`
   echo "Removed $t"
  done
fi

