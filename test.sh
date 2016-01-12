#!/usr/bin/env bash

# RUN THIS ON YOUR OWN RISK IF THIS SCRIPT DELETES ALL OF YOUR TAGS I WASH MY HANDS OFF OF IT :P

num=0
MAX=$(git tag | xargs -I@ git log --format=format:"%ai @%n" -1 @ | sort | wc -l)
echo "There are $MAX tags available"
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

