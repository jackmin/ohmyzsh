PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%X]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info) $(rsync-repo-prompt-info)\
%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
RSYNC_REPO_PROMPT_NA="%{$fg[gray]%}[NA]%{$reset_color%}"
RSYNC_REPO_PROMPT_N="%{$fg[red]%}[N]%{$reset_color%}"
RSYNC_REPO_PROMPT_S="%{$fg[green]%}[S]%{$reset_color%}"
RSYNC_REPO_PROMPT_SS="%{$fg[yellow]%}[Ss]%{$reset_color%}"
