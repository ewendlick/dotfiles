# For installing rbenv, getting a version of Ruby, and detecting paths etc

# yum install -y openssl-devel readline-devel zlib-devel
# git clone rbenv
# run the command to find out what to add to paths in bashrc/ zshrc
# install the rbenv install thing
# install ruby 2.4.1 via rbenv
# Then there is no global version set, so do that 'rbenv global 2.4.1'

# Get the name of the shell

sudo yum install -y openssl-devel readline-devel zlib-devel

cd ~
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src

# message asking if they want to add this to bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile

# message asking if they want to add this to zsh


# message telling them to add something to their shell later

# catch the echo and use it for the next step??

"ok, so this next step is going to add
eval "$(rbenv init -)" to your .bash_profile
and
eval "$(rbenv init -)" to your .zshrc if it exists"

"From here,
exec bash -l"

# ok, allow for installations of Ruby versions
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# Let's install Ruby 2.4.1, which is newest at the time of the creation of this
rbenv install 2.4.1

# Set it as global, otherwise nothing happens and you go looking for answers for the fourth time and finally find the solution buried in some Mozilla thread
rbenv global 2.4.1
