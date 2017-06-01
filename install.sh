#!/bin/bash

##### check zsh and oh-my-zsh existence
if ! which 'zsh' > /dev/null 2>&1; then  
  read -p "Zsh not found. Install Zsh? (y/n)" choice
  case "$choice" in 
    y|Y ) echo "yes"; yum install zsh; chsh -s `which zsh`;;
    n|N ) echo "no"; quit 1;;
    * ) echo "invalid";;
  esac
fi

if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  echo "installing oh-my-zsh"
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh;   
  #curl -L http://install.ohmyz.sh | sh #older one
  mv "${HOME}/.zshrc.pre-oh-my-zsh" "${HOME}/.zshrc"
fi

##### check tmux existence
if ! which 'tmux' > /dev/null 2>&1; then  
  read -p "Tmux not found. Install it? (y/n)" choice
  case "$choice" in 
    y|Y ) echo "yes"; yum install tmux;;
    n|N ) echo "no"; quit 1;;
    * ) echo "invalid";;
  esac
fi
# TODO: figure out a way to copy to a decent location and reload it with CTRL+t :source-file /etc/tmux.conf

##### check vim existence
if ! which 'vim' > /dev/null 2>&1; then  
  read -p "Vim not found. Install it? (y/n)" choice
  case "$choice" in 
    y|Y ) echo "yes"; yum install vim;;
    n|N ) echo "no"; quit 1;;
    * ) echo "invalid";;
  esac
fi
#TODO: move this?
mkdir -p "$(dirname "${HOME}/.vim/bundle/neobundle.vim")"
if [ ! -d "${HOME}/.vim/bundle/neobundle.vim" ]; then
  echo "clone neobundle: 'https://github.com/Shougo/neobundle.vim' into ${HOME}/.vim/bundle/neobundle.vim"
  git clone 'https://github.com/Shougo/neobundle.vim' "${HOME}/.vim/bundle/neobundle.vim"
  [[ $? -ne 0 ]] && exit 10
fi



##### check git existence
if ! which 'git' > /dev/null 2>&1; then  
  read -p "Git not found. Install it? (y/n)" choice
  case "$choice" in 
    y|Y ) echo "yes"; yum install git;;
    n|N ) echo "no"; quit 1;;
    * ) echo "invalid";;
  esac
fi

##### detect environment
#is_rakuten=0
#if [[ $HOSTNAME = *rakuten* ]] || [[ $HOSTNAME = *.jp.local ]]; then
#  readonly DOTFILES_REPOSITORY="ssh://git@git.dev.db.rakuten.co.jp:7999/~atsushi.tobe/dotfiles.git"
#  is_rakuten=1
#else
#  readonly DOTFILES_REPOSITORY="ssh://git@git.rakuten-it.com:7999/~atsushi.tobe/dotfiles.git"
#fi

#is_local=0
#if [[ $HOSTNAME = localhost.localdomain ]]; then
#  is_local=1
#fi

readonly DOTFILES_REPOSITORY="https://github.com/ewendlick/dotfiles.git"


##### fetch original dotfiles from stash
if [[ ! -d "${HOME}/dotfiles" ]]; then
  echo git clone "$DOTFILES_REPOSITORY" "${HOME}/dotfiles"
  git clone "$DOTFILES_REPOSITORY" "${HOME}/dotfiles"
fi
cd "${HOME}/dotfiles"
git fetch
git checkout remotes/origin/master

readonly ROOT="${HOME}/dotfiles"


##### copy configurations in the repository
#TODO: what happens when the dotfiles don't exist in the repo?
link_files=('.vimrc' '.tmux.conf' '.gitconfig' '.zsh' '.zshrc' '.bashrc' '.irbrc' '.pryrc')
while true; do
  echo -ne 'Do you want to create dotfiles as symbolic link? [yes/copy/skip] '
  read confirmation
  if [ "$confirmation" = 'yes' ]; then
    copy_command='ln -s'
    break
  elif [ "$confirmation" = 'copy' ]; then
    copy_command='cp -r'
    break
  elif [ "$confirmation" = 'skip' ]; then
    copy_command=''
    break
  else
    echo -n 'Please input "yes", "copy" or "skip". '
    continue
  fi
done

#if [ -n "$copy_command" ]; then
#  for ((i = 0; i < ${#link_files[@]}; i++)); do
#    link_file=${link_files[i]}
#    source_path=$(readlink -f "${ROOT}/${link_file}")
#    dest_path=$(readlink -f "${HOME}/${link_file}")
#
#    if [[ "$source_path" == "$dest_path" ]]; then
#      continue
#    fi
#
#    if [[ -e "${HOME}/${link_file}" ]]; then
#      backup_suffix=$(date '+%Y%m%d%H%M%S')
#      echo "move to backup: ${dest_path} -> ${dest_path}.${backup_suffix}"
#      mv "${dest_path}" "${dest_path}.${backup_suffix}"
#    fi
#
#    echo "copy: ${source_path} -> ${dest_path}"
#    $copy_command "${source_path}" "${dest_path}"
#  done
#fi



mkdir -p "$(dirname "${HOME}/.vim/bundle/neobundle.vim")"
if [ ! -d "${HOME}/.vim/bundle/neobundle.vim" ]; then
  echo "clone neobundle: 'https://github.com/Shougo/neobundle.vim' into ${HOME}/.vim/bundle/neobundle.vim"
  git clone 'https://github.com/Shougo/neobundle.vim' "${HOME}/.vim/bundle/neobundle.vim"
  [[ $? -ne 0 ]] && exit 10
fi

mkdir -p "$(dirname "${HOME}/.nvm")"
if [[ ! -d "${HOME}/.nvm" ]]; then
  echo "clone nvm: 'https://github.com/creationix/nvm.git' into ${HOME}/.nvm"
  git clone 'https://github.com/creationix/nvm.git' "${HOME}/.nvm"
  [[ $? -ne 0 ]] && exit 20
fi



#PUBLIC_PATH="${HOME}/public_html"
#if [[ "$is_local" -eq 1 ]] && [[ ! -d "$PUBLIC_PATH" ]]; then
#  echo "create public directory: ${PUBLIC_PATH}"
#  mkdir -m755 "$PUBLIC_PATH"
#  ln -s "${HOME}/.vim/bundle/previm/preview" "${PUBLIC_PATH}/previm"
#  echo "Please change configuration of nginx/apache"
#fi

#default_shell=$(getent passwd $LOGNAME | cut -d':' -f7)
#if [[ -f '/etc/passwd' ]] && [[ "$default_shell" != '/bin/zsh' ]] && [[ -f '/bin/zsh' ]]; then
#  chsh -s /bin/zsh
#fi

# Add this to the zshrc file, it starts tmux on login
#case $- in *i*)
#    [ -z "$TMUX" ] && exec tmux
#esac

# Add all the things I fuck up
# alias sl='ls'
# Add this line to make easier navigation (however, this has been checked and determined not to work quite right)
#cd() { if [[ "$1" =~ ^\.\.+$ ]];then local a dir;a=${#1};while [ $a -ne 1 ];do dir=${dir}"../";((a--));done;builtin cd $dir;else builtin cd "$@";fi ;}
