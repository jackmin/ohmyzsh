RSYNC_REPO_INTERVAL=${RSYNC_REPO_INTERVAL:=30}
RSYNC_REPO_REMOTE_ROOT=${RSYNC_REPO_REMOTE_ROOT}

function rsync-repo-code-sync-full {
  (`command git rev-parse --is-inside-work-tree 2>/dev/null` &&
  dir=`command git rev-parse --git-dir` &&
  [[ -f $dir/ENABLE_RSYNC_REPO ]] &&
  [[ ! -z $RSYNC_REPO_REMOTE_ROOT ]] &&
  repo_name=`command git rev-parse --show-toplevel` &&
  exclude_file=`command git rev-parse --git-path info/exclude` &&
  command rsync -rlptzv --progress --delete --delete-excluded -e "ssh -o 'ControlPath=$HOME/.ssh/master-socket/%r@%h:%p'" --exclude-from=$exclude_file \
    $repo_name $RSYNC_REPO_REMOTE_ROOT/. 2>/dev/null &>! $dir/RSYNC_REPO_LOG )
}

function rsync-repo-code-sync-force {
  (`command git rev-parse --is-inside-work-tree 2>/dev/null` &&
  dir=`command git rev-parse --git-dir` &&
  [[ -f $dir/ENABLE_RSYNC_REPO ]] &&
  [[ ! -z $RSYNC_REPO_REMOTE_ROOT ]] &&
  repo_name=`command git rev-parse --show-toplevel` &&
  exclude_file=`command git rev-parse --git-path info/exclude` &&
  command rsync -rlptzv --progress --delete -e "ssh -o 'ControlPath=$HOME/.ssh/master-socket/%r@%h:%p'" --exclude-from=$exclude_file \
    $repo_name $RSYNC_REPO_REMOTE_ROOT/. 2>/dev/null &>! $dir/RSYNC_REPO_LOG )
}

function rsync-repo-code-sync {
  (`command git rev-parse --is-inside-work-tree 2>/dev/null` &&
  dir=`command git rev-parse --git-dir` &&
  [[ -f $dir/ENABLE_RSYNC_REPO ]] &&
  [[ ! -z $RSYNC_REPO_REMOTE_ROOT ]] &&
  rebase0=`command git rev-parse --git-path rebase-merge` &&
  rebase1=`command git rev-parse --git-path rebase-apply` &&
  [[ ! -d $rebase0 ]] && [[ ! -d $rebase1 ]] &&
  repo_name=`command git rev-parse --show-toplevel` &&
  exclude_file=`command git rev-parse --git-path info/exclude` &&
  command rsync -rlptzv --progress --delete -e "ssh -o 'ControlPath=$HOME/.ssh/master-socket/%r@%h:%p'" --exclude-from=$exclude_file \
    $repo_name $RSYNC_REPO_REMOTE_ROOT/. 2>/dev/null &>! $dir/RSYNC_REPO_LOG )
}

function rsync-repo-code {
  (`command git rev-parse --is-inside-work-tree 2>/dev/null` &&
  dir=`command git rev-parse --git-dir` &&
  [[ -f $dir/ENABLE_RSYNC_REPO ]] &&
  [[ ! -z $RSYNC_REPO_REMOTE_ROOT ]] &&
  rebase0=`command git rev-parse --git-path rebase-merge` &&
  rebase1=`command git rev-parse --git-path rebase-apply` &&
  [[ ! -d $rebase0 ]] && [[ ! -d $rebase1 ]] &&
  repo_name=`command git rev-parse --show-toplevel` &&
  exclude_file=`command git rev-parse --git-path info/exclude` &&
  (( `date +%s` - `date -r $dir/RSYNC_REPO_LOG +%s 2>/dev/null || echo 0` > $RSYNC_REPO_INTERVAL )) &&
  command rsync -rlptzv --progress --delete --exclude-from=$exclude_file \
    $repo_name $RSYNC_REPO_REMOTE_ROOT/. 2>/dev/null &>! $dir/RSYNC_REPO_LOG &)
}

function rsync-repo {
  `command git rev-parse --is-inside-work-tree 2>/dev/null` || return
  guard="`command git rev-parse --git-dir`/ENABLE_RSYNC_REPO"

  (rm $guard 2>/dev/null &&
    echo "${fg_bold[red]}disabled${reset_color}")  ||
  (touch $guard &&
    echo "${fg_bold[green]}enabled${reset_color}")
}

function rsync-repo-prompt-info {
   local dir rsync_status
   if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" != "true" ]]; then
       return 0
   fi
   dir=`command git rev-parse --git-dir`
   if [[ -f $dir/ENABLE_RSYNC_REPO && -f $dir/RSYNC_REPO_LOG ]]; then
	   rsync_status=`command grep -i 'rsync\serror\|total\ssize\sis'\
		   $dir/RSYNC_REPO_LOG 2>/dev/null`
   fi
   if [[ ! -f $dir/ENABLE_RSYNC_REPO ]]; then
       echo "$RSYNC_REPO_PROMPT_NA"
   elif [[ $rsync_status =~ "rsync\serror" ]]; then
       echo "$RSYNC_REPO_PROMPT_N"
   elif [[ $rsync_status =~ "total\ssize\sis" ]]; then
       echo "$RSYNC_REPO_PROMPT_S"
   else
       echo "$RSYNC_REPO_PROMPT_SS"
   fi
}

# Override zle-line-init if it exists
#if (( $+functions[zle-line-init] )); then
#  eval "override-rsync-repo-$(declare -f zle-line-init)"

#  function zle-line-init () {
#    rsync-repo-code
#    override-rsync-repo-zle-line-init
#  }
#else
#  function zle-line-init () {
#    rsync-repo-code
#  }
#fi

#zle -N zle-line-init
