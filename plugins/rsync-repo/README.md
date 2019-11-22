# Rsync Git Repo

Automatically rsync git files to remote host while you are working in git-initialized directory.

#### Usage

Add `rsync-repo` to the plugins array in your zshrc file:

```shell
plugins=(... rsync-repo)
```

Every time you launch a command in your shell all git files will be rsynced in background.
By default autorsync will be triggered only if last rsync was done at least 30 seconds ago.
You can change fetch interval in your .zshrc:
```
RSYNC_REPO_INTERVAL=300 #in seconds
```
Log of `rsync` will be saved into `.git/RSYNC_REPO_LOG`


#### Toggle auto fetch per folder
If you are using mobile connection or for any other reason you can disable rsync-repo for any folder:

```shell
$ cd to/your/project
$ rsync-repo
disabled
$ rsync-repo
enabled
```
