# GitHub

### *Basic Commands*

### Setup
`git init`
`git clone [url]`

### STAGE & SNAPSHOT

`git status`

show modified files in working directory, staged for your next commit

`git add [file]`

add a file as it looks now to your next commit (stage)

`git reset [file]`

unstage a file while retaining the changes in working directory

`git diff`

diff of what is changed but not staged

`git diff --staged`

diff of what is staged but not yet commited

`git commit -m “[descriptive message]”`

commit your staged content as a new commit snapshot

### BRANCH & MERGE

`git branch`

list your branches. a * will appear next to the currently active branch

`git branch [branch-name]`

create a new branch at the current commit

`git checkout`

switch to another branch and check it out into your working directory

`git merge [branch]`

merge the specified branch’s history into the current one

`git log`

### SHARE & UPDATE

`git remote add [alias] [url]`

add a git URL as an alias

`git fetch [alias]`

fetch down all the branches from that Git remote

show all commits in the current branch’s history

`git merge [alias]/[branch]`

merge a remote branch into your current branch to bring it up to date

`git push [alias] [branch]`

Transmit local branch commits to the remote repository branch

`git pull`

fetch and merge any commits from the tracking remote branch

### REWRITE HISTORY

`git rebase [branch]`

apply any commits of current branch ahead of specified one

`git reset --hard [commit]`

clear staging area, rewrite working tree from specified commit

### TEMPORARY COMMITS

`git stash`

Save modified and staged changes

`git stash list`

list stack-order of stashed file changes

`git stash pop`

write working from top of stash stack

`git stash drop`

discard the changes from top of stash stack

### INSPECT & COMPARE

`git log`

show the commit history for the currently active branch

`git log branchB..branchA`

show the commits on branchA that are not on branchB

`git log --follow [file]`

show the commits that changed file, even across renames

`git diff branchB...branchA`

show the diff of what is in branchA that is not in branchB

`git show [SHA]`

show any object in Git in human-readable format

### TRACKING PATH CHANGES

`git rm [file]`

delete the file from project and stage the removal for commit

`git mv [existing-path] [new-path]`

change an existing file path and stage the move

### *Advance Commands*

`git reset --hard origin/[target branch]`

Reset the local branch to the origin branch's state. Caution: your local changes will be lost

`git commit --amend`

Modify the most recent commit. Can be used to edit message or add more files to that commit. Caution, this changes the commit hash, so do this only while it was not yet pushed to a shared branch

`git revert HEAD~1`

Create a new commit undoing the last commit's changes

`git reflog`

List all the git actions that were executed before. Useful to find a lost commit, then you can try to recover it

`git bisect start`

Useful to find the buggy commit (that possible introduces some bug). After this, you use git bisect

`git clean -df`

Remove untracked files and directories from the working tree. Add n to the flags to list all files that would be removed

`git log --graph`

The --graph option draws an ASCII graph representing the branch structure of the commit history

`git log --graph --oneline --decorate`

This is commonly used in conjunction with the `--oneline` and `--decorate` commands to make it easier to see which commit belongs to which branch

### *Custom Formatting*

`git log --pretty=format:"%cn committed %h on %cd"`

For all of your other git log formatting needs, you can use the `--pretty=format:""` option. This lets you display each commit however you want using printf-style placeholders


### *Filtering the commit history*

`git log -3`

You can limit git log’s output by including the - option. For example, the following command will display only the 3 most recent commits

`git log --after="2014-7-1"`

If you’re looking for a commit from a specific time frame, you can use the `--after` or `--before` flags for filtering commits by date. These both accept a variety of date formats as a parameter. For example, the following command only shows commits that were created after July 1st, 2014 (inclusive)

`git log --after="yesterday"`

You can also pass in relative references like `"1 week ago"` and `"yesterday"`

`git log --after="2014-7-1" --before="2014-7-4"`

To search for a commits that were created between two dates, you can provide both a `--before` and `--after` date. 

`git log --author="John"`

When you’re only looking for commits created by a particular user, use the `--author` flag

`git log --grep="JRA-224:"`

To filter commits by their commit message, use the --grep flag. This works just like the `--author` flag discussed above, but it matches against the commit message instead of the author

`git log -- foo.py bar.py`

Many times, you’re only interested in changes that happened to a particular file. To show the history related to a file, all you have to do is pass in the file path. For example, the following returns all commits that affected either the foo.py or the `bar.py` file

`git log --no-merges` &&
`git log --merges`

You can prevent git log from displaying these merge commits by passing the `--no-merges` flag

### Some Concepts

## Merging vs. rebasing

The first thing to understand about git rebase is that it solves the same problem as git merge. Both of these commands are designed to integrate changes from one branch into another branch—they just do it in very different ways

![link](https://wac-cdn.atlassian.com/dam/jcr:1523084b-d05a-4f5a-bd1a-01866ec09ca3/01%20A%20forked%20commit%20history.svg?cdnVersion=2631)

### Merge Option

```
git checkout feature
git merge main
```
Or, you can condense this to a one-liner:

```
git merge feature main
```

This creates a new “merge commit” in the feature branch that ties together the histories of both branches, giving you a branch structure that looks like this:

![image](https://wac-cdn.atlassian.com/dam/jcr:4639eeb8-e417-434a-a3f8-a972277fc66a/02%20Merging%20main%20into%20the%20feature%20branh.svg?cdnVersion=2631)

Merging is nice because it’s a non-destructive operation. The existing branches are not changed in any way. 

### The rebase option

```
git checkout feature
git rebase main
```
This moves the entire feature branch to begin on the tip of the main branch, effectively incorporating all of the new commits in main. But, instead of using a merge commit, rebasing re-writes the project history by creating brand new commits for each commit in the original branch.

![image](https://wac-cdn.atlassian.com/dam/jcr:3bafddf5-fd55-4320-9310-3d28f4fca3af/03%20Rebasing%20the%20feature%20branch%20into%20main.svg?cdnVersion=2631)

The golden rule of rebasing:

Once you understand what rebasing is, the most important thing to learn is when not to do it. The golden rule of git rebase is to never use it on public branches.

For example, think about what would happen if you rebased main onto your feature branch:

![image](https://wac-cdn.atlassian.com/dam/jcr:2908e0e6-f74b-4425-b5d2-f5eca8cfcd99/05%20Rebasing%20the%20main%20branch.svg?cdnVersion=2631)