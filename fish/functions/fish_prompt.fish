

set fp_color_cwd (set_color yellow)
set fp_color_cwd_unedit (set_color -o red)
set fp_color (set_color blue)
set fp_reset (set_color normal)
set fp_color_branch (set_color -o black)
set fp_color_dirty (set_color red)
set fp_color_whoami (set_color green)
set fp_color_lo (set_color white)

function current_git_branch
  git rev-parse --abbrev-ref HEAD 2>/dev/null
end


function current_git_sha
  git rev-parse HEAD 2>/dev/null| cut -c 1-7
end

function git_dirty
  not git diff HEAD --quiet 2>/dev/null
end


function fp_git
  set -l branch (current_git_branch)
  if not test -z $branch
    echo -n "$fp_color_branch$branch$fp_color_lo@$fp_color_branch"(current_git_sha)

    if git_dirty
      printf ' %s+ ' $fp_color_dirty
    end
  end
end


function fp_hostname
  if test ! -z "$SSH_CONNECTION"
    printf '%s[%s] ' $fp_color_whoami (hostname -s)
  end
end

function fp_whoami
  set -l whoami (whoami)
  if test $whoami != "lachie"
    printf '%s%s:' $fp_color_whoami $whoami
  end
end

function fp_rvm
	printf '%s%s ' $fp_reset (bash -c ~/.rvm/bin/rvm-prompt g)
end


function fish_prompt --description 'Write out the prompt'
  printf '\n'

  printf '%s%s ' (date +"%T")
  fp_whoami

  # Write the process working directory
  if test -w "."
    printf '%s%s ' (basename $PWD)
  else
    printf '%s%s ' $fp_color_cwd_unedit (basename $PWD)
  end
 
  fp_rvm
  fp_git

  printf '\n%s➞%s  ' $fp_color_branch $fp_reset
end