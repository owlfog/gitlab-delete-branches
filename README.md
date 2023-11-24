# Removing old branches

This Bash script is designed for managing Git branches in a project hosted on GitLab. Here's a detailed description of its functionality:

Initialization: The script starts by defining three variables: GITLAB_API_TOKEN (your GitLab private token), GITLAB_PROJECT_ID (the ID of your GitLab project), and GITLAB_API_URL (the URL of your GitLab instance).

Branch Listing: It fetches a list of all remote branches in the Git repository, excluding the HEAD reference, which is typically used internally by Git.

Date Calculation: The script calculates the current date, which is used later to determine the age of each branch.

Branch Processing:

Branch Filtering: The script iterates over each branch, excluding those not associated with the origin remote (i.e., local branches or those from other remotes).
Last Commit Date: For each remote branch, it retrieves the date of the last commit.
Age Calculation: The script calculates the age of each branch in days by comparing the last commit date to the current date.
Branch Evaluation:

Stale Branches: Branches older than 30 days are considered for deletion.
Merge Request Check: Before marking a branch for deletion, the script checks if there are any open merge requests associated with that branch in GitLab. This is done using a curl request to the GitLab API.
Deletion List: If a branch is older than 30 days and has no open merge requests, it is added to a list of branches to be deleted.
User Confirmation: Before proceeding with deletion, the script displays the list of branches to be deleted and asks the user for confirmation.

Branch Deletion: If the user confirms, each branch in the deletion list is removed using the git push origin --delete command.

Overall, this script automates the process of cleaning up old branches in a GitLab project, ensuring that branches with ongoing work (as indicated by open merge requests) are not inadvertently deleted.
