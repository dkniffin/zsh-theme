path_color="blue"
ruby_color="red"
wip_color="yellow"

function path {
  echo "%{$reset_color%}%{$fg[$path_color]%}%~%{$reset_color%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="⎇ "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="dirty"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="ahead"

function wip_warning {
  git log -1 --pretty=%B | grep "WIP" > /dev/null
  if [[ $? == 0 ]]; then
    local color="%{$fg[$wip_color]%}"
    local text=" ⚠️  WIP"
    echo "%{$reset_color%}$color$text%{$reset_color%}"
  else
    return ""
  fi
}

function custom_git_prompt {
  local current_branch=$(git symbolic-ref --short -q HEAD 2>/dev/null)
  if [[ $current_branch == "" ]]; then
    return ""
  else
    local prompt="$ZSH_THEME_GIT_PROMPT_PREFIX$current_branch"

    if [[ $(parse_git_dirty) == $ZSH_THEME_GIT_PROMPT_DIRTY ]]; then
      local color="%{$fg[yellow]%}"
    elif [[ $(git_remote_status) == $ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE ]]; then
      local color="%{$fg[cyan]%}"
    else
      local color="%{$fg[green]%}"
    fi

    echo "(%{$reset_color%}$color$prompt%{$reset_color%}$(wip_warning))"
  fi
}

function ruby_version {
  local rbversion=$(ruby -e 'print RUBY_VERSION')
  echo "[%{$reset_color%}%{$fg[$ruby_color]%}RB:$rbversion%{$reset_color%}]"
}

PROMPT='%(?..%{$fg_bold[red]%}✘ %s)$(path) $(ruby_version) $(custom_git_prompt)%{$reset_color%} > '
