#! /bin/sh
# For bringing back common tabs when tmux crashes

# 2
tmux new-window -n 'intra'
cd /home/vagrant/code/intra

# 3
tmux new-window -n 'intra-run'
cd /home/vagrant/code/intra

# 4
tmux new-window -n 'front'
cd /home/vagrant/code/front

# 5
tmux new-window -n 'front-run'
cd /home/vagrant/code/front

# 6
tmux new-window -n 'choose'
cd /home/vagrant/code/choose
