#!/bin/bash


if [ "$EUID" -e 0 ]
  then echo "You are probably running this as root. You should probably run this as a user with sudo priveleges."
  exit
fi
##### check zsh and oh-my-zsh existence
if ! which 'zsh' > /dev/null 2>&1; then
  read -p "Zsh not found. Install Zsh? (y/n)" choice
  case "$choice" in 
    y|Y ) echo "yes"; sudo yum install zsh; chsh -s `which zsh`;;
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
  read -p "Tmux not found. Install Tmux? (y/n)" choice
  case "$choice" in
    y|Y ) echo "yes";
      sudo yum install gcc
      wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz;
      tar xzvf libevent-2.0.21-stable.tar.gz;
      cd libevent-2.0.21-stable;
      ./configure && make;
      sudo make install;
      sudo yum install ncurses-devel libevent-devel automake;
      wget https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz;
      tar -xvzf tmux-2.2.tar.gz;
      cd tmux-2.2;
      LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local;
      make;
      sudo make install;
      sudo cp /usr/local/bin/tmux /usr/bin/tmux;;
    n|N ) echo "no"; quit 1;;
    * ) echo "invalid";;
  esac
fi
# TODO: figure out a way to copy to a decent location and reload it so it uses CTRL+t :source-file /etc/tmux.conf

##### check vim existence
if ! which 'vim' > /dev/null 2>&1; then
  read -p "Vim not found. Install it? (y/n)" choice
  case "$choice" in
    y|Y ) echo "yes"; sudo yum install vim;;
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
# Some sort of install needs to happen in vim I think


##### check git existence
if ! which 'git' > /dev/null 2>&1; then
  read -p "Git not found. Install it? (y/n)" choice
  case "$choice" in
    y|Y ) echo "yes"; sudo yum install git;;
    n|N ) echo "no"; quit 1;;
    * ) echo "invalid";;
  esac
fi

readonly DOTFILES_REPOSITORY="https://github.com/ewendlick/dotfiles.git"
##### fetch original dotfiles from GitHub
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
  echo -ne 'Do you want to create dotfiles as symbolic links, copy them, or skip this step? [symlink/copy/skip] '
  read confirmation
  if [ "$confirmation" = 'symlink' ]; then
    copy_command='ln -s'
    break
  elif [ "$confirmation" = 'copy' ]; then
    copy_command='cp -r'
    break
  elif [ "$confirmation" = 'skip' ]; then
    copy_command=''
    break
  else
    echo -n 'Please input "symlink", "copy" or "skip". '
    continue
  fi
done

if [ -n "$copy_command" ]; then
  for ((i = 0; i < ${#link_files[@]}; i++)); do
    link_file=${link_files[i]}
    source_path=$(readlink -f "${ROOT}/${link_file}")
    dest_path=$(readlink -f "${HOME}/${link_file}")

    if [[ "$source_path" == "$dest_path" ]]; then
      continue
    fi

    if [[ -e "${HOME}/${link_file}" ]]; then
      backup_suffix=$(date '+%Y%m%d%H%M%S')
      echo "move to backup: ${dest_path} -> ${dest_path}.${backup_suffix}"
      mv "${dest_path}" "${dest_path}.${backup_suffix}"
    fi

    echo "copy: ${source_path} -> ${dest_path}"
    $copy_command "${source_path}" "${dest_path}"
  done
fi

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
