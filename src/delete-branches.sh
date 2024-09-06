#!/bin/bash
past_seconds=$(date -d "90 days ago" +"%s")
branches=($(git branch -a --format='%(refname:short),%(committerdate:short)' | awk '{print $1}'))
for b in ${branches[@]}; do
  refname=$(echo $b | awk -F',' '{print $1}')
  committerdate=$(echo $b | awk -F',' '{print $2}')
  committerseconds=$(date -d "$committerdate" +"%s")
  if [[ $committerseconds < $past_seconds ]]; then
    echo "Deleting: $refname ($committerdate)"
	git branch -d $refname
	git push origin -d $refname
  fi
done
