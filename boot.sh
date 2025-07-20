#!/data/data/com.termux/files/usr/bin/bash
tmux new-session -d -s server1 "cd ~/myapp1 && python app.py"
tmux new-session -d -s server2 "cd ~/myapp2 && python app.py"    












