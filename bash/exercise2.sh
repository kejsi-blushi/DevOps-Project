#!/bin/bash

# Get the latest commit hash on the main and develop branch
MAIN_COMMIT=$(git rev-parse main)
DEVELOP_COMMIT=$(git rev-parse develop)


# Check if the develop branch is an ancestor of the main branch
if git merge-base --is-ancestor $DEVELOP_COMMIT $MAIN_COMMIT; then

# If there are new commits to merge into main, increment the release number and update the latest commit
  RELEASE_NUMBER=$(cat react-todo-app/Release.txt | awk '/App_version/{print $3}' | cut -d '.' -f3)
  NEW_RELEASE_NUMBER=$(($RELEASE_NUMBER+1))
  NEW_VERSION="App_version : 1.0.$NEW_RELEASE_NUMBER"
  NEW_COMMIT="Latest_commit: $(git rev-parse --short main)"

# Update the Release.txt file with the new release number and latest commit hash
  sed -i "s/App_version :.*/$NEW_VERSION/" react-todo-app/Release.txt
  sed -i "s/Latest_commit:.*/$NEW_COMMIT/" react-todo-app/Release.txt

# Commit the changes and push to the repository
  git add react-todo-app/Release.txt
  git commit -m "Incremented release number to $NEW_VERSION and updated latest commit hash to $(git rev-parse --short HEAD)"
  git push origin main
else
# If the devs branch is an ancestor of the main branch, exit the script
  echo "No new commits on main branch. Exiting."
  exit 0
fi
 