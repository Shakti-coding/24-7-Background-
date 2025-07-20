#!/data/data/com.termux/files/usr/bin/bash

# ✅ Keep device awake
termux-wake-lock

# ✅ Kill any old tmux sessions
tmux kill-session -t server1 2>/dev/null
tmux kill-session -t server2 2>/dev/null
tmux kill-session -t telegrambot 2>/dev/null

# ✅ Start Flask App 1 (port 5000)
tmux new-session -d -s server1 "
cd ~/ncert_web
while true; do
  echo '▶️ Starting Flask App 1...'
  python app.py
  echo '❌ Flask App 1 crashed. Restarting in 5 seconds...'
  sleep 5
done
"

# ✅ Start Flask App 2 (port 8000)
tmux new-session -d -s server2 "
cd ~/ncert_web2
while true; do
  echo '▶️ Starting Flask App 2...'
  python app.py
  echo '❌ Flask App 2 crashed. Restarting in 5 seconds...'
  sleep 5
done
"

# ✅ Start Telegram Bot (~/testing/d.py)
tmux new-session -d -s telegrambot "
cd ~/testing
while true; do
  echo '▶️ Starting Telegram Bot...'
  python d.py
  echo '❌ Bot crashed. Restarting in 5 seconds...'
  sleep 5
done
"

# ✅ Setup crontab: restart if any service is down
(crontab -l 2>/dev/null | grep -v 'start.sh'; echo "* * * * * pgrep -f 'ncert_web/app.py' > /dev/null || bash ~/.termux/boot/start.sh"; echo "* * * * * pgrep -f 'ncert_web2/app.py' > /dev/null || bash ~/.termux/boot/start.sh"; echo "* * * * * pgrep -f 'testing/d.py' > /dev/null || bash ~/.termux/boot/start.sh") | crontab -

# ✅ Add auto-run in .bashrc (when Termux manually opened)
if ! grep -q "bash ~/.termux/boot/start.sh" ~/.bashrc; then
  echo "bash ~/.termux/boot/start.sh" >> ~/.bashrc
fi

# ✅ Get local IP (ignore localhost)
LOCAL_IP=$(ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | head -n 1)

# ✅ Final success message
echo "✅ All services are running in background (24x7)"
echo "🌐 Flask App 1 → http://127.0.0.1:5000 or http://$LOCAL_IP:5000"
echo "🌐 Flask App 2 → http://127.0.0.1:8000 or http://$LOCAL_IP:8000"
echo "🤖 Telegram Bot is running in tmux session: telegrambot"
echo "🛑 Stop all: tmux kill-session -t server1 && tmux kill-session -t server2 && tmux kill-session -t telegrambot"
