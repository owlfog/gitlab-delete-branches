#!/bin/bash

GITLAB_API_TOKEN="your token here"
GITLAB_PROJECT_ID="project id"
GITLAB_API_URL="https://git.domain.com/api/v4"

# Get a list of all branches
branches=$(git branch -r | grep -v HEAD)

# Current date for comparison
current_date=$(date +%s)

# Array to store branches to be deleted
branches_to_delete=()

for branch in $branches; do
    # Skip remote repository branches
    if [[ $branch == "origin/"* ]]; then
        branch=${branch#"origin/"}

        # Get the date of the last commit in the branch
        last_commit_date=$(git log -1 --format=%ct origin/$branch)
        # Difference in days
        diff=$(( (current_date - last_commit_date) / 86400 ))

        if [ $diff -gt 30 ]; then
            # Check for open merge requests
            merge_requests=$(curl --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_API_URL/projects/$GITLAB_PROJECT_ID/merge_requests?state=opened&source_branch=$branch")

            if [ -z "$merge_requests" ] || [ "$merge_requests" == "[]" ]; then
                # Add branch to the deletion list
                branches_to_delete+=($branch)
            else
                echo "Branch $branch has open merge requests. Skipping."
            fi
        else
            echo "Branch $branch was updated less than 30 days ago. Skipping."
        fi
    fi
done

# Output the list of branches for deletion
echo "The following branches will be deleted: ${branches_to_delete[@]}"

# Confirmation before deletion
read -p "Are you sure you want to delete these branches? (y/n) " -n 1 -r
echo    # (optional) move cursor to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    for branch in "${branches_to_delete[@]}"; do
        echo "Deleting branch: $branch"
        git push origin --delete $branch
    done
fi
