#!/bin/bash

# Function to check if a directory is a Git repository
is_git_repository() {
  if [ -d "$1/.git" ] || git -C "$1" rev-parse --is-inside-work-tree &> /dev/null; then
    return 0
  else
    return 1
  fi
}

# Function to get and print the current branch name
get_current_branch() {
  local branch
  branch=$(git -C "$1" symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "$1 -> $branch"
  else
    echo "$1 -> detached HEAD"
  fi
}

# Main script
current_directory=$(pwd)

echo "Listing directories and their Git branch status in the current path:"
echo "---------------------------------------------------------------"

DIRECTORIES=`find . -maxdepth 1 -type d`
for d in $DIRECTORIES; do
	if [ "$d" != "." ]; then
		if is_git_repository "$d"; then
			get_current_branch "$d"
		fi
	fi
done;

echo "---------------------------------------------------------------"
