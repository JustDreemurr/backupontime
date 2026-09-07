#!/bin/bash
# Eagle (eagle.cool) Wine 启动脚本 — Arch / niri / XWayland
#
# 做的事：
# 1. 用独立容器 ~/.wine-eagle、--disable-gpu 启动 Eagle（防白屏）
# 2. 后台守护：自动 unmap Eagle 的隐形辅助窗口和 Wine 托盘代理窗口
#    （这些窗口靠 _NET_WM_WINDOW_OPACITY=0 隐身，xwayland-satellite 不认，
#     在 niri 下会显示为白色方块且无法关闭）
# 3. 可选：41595 -> 41593 本地中继（Eagle 的扩展服务器实际绑在 41593，
#    而更新器和浏览器扩展硬编码访问 41595；不需要可注释掉 RELAY 行）
# 4. 确保 xembedsniproxy 在运行：把 Wine 的 XEmbed 托盘图标转成 SNI，
#    让 Eagle 托盘图标能显示在 Noctalia 托盘里

#export WINEPREFIX="$HOME/.wine-eagle"
#export DISPLAY=:1
#export GDK_SCALE=2
#export QT_SCALE_FACTOR=2
#RELAY_SCRIPT="$HOME/bin/relay41595.py"

# --- 41595 中继（更新器 / 浏览器扩展需要）---
#if [ -f "$RELAY_SCRIPT" ] && ! ss -tlnH 'sport = :41595' | grep -q .; then
#  nohup python3 "$RELAY_SCRIPT" >/tmp/relay.log 2>&1 &
#fi

# --- XEmbed -> SNI 桥（让 Eagle 托盘图标进 Noctalia 托盘）---
#pgrep -x xembedsniproxy >/dev/null || setsid -f env DISPLAY=:1 xembedsniproxy >/tmp/xembedsniproxy.log 2>&1

# --- 隐形窗口清理守护 ---
# 先等 Eagle 进程出现，避免脚本先于 Eagle 启动时立即退出
(
  until pgrep -f 'Eagle[.]exe' >/dev/null; do sleep 1; done
  while pgrep -f 'Eagle[.]exe' >/dev/null; do
    for w in $(xdotool search --onlyvisible --class '[Ee]agle\.exe' 2>/dev/null); do
      op=$(xprop -id "$w" _NET_WM_WINDOW_OPACITY 2>/dev/null | grep -oP '[0-9]+$')
      [ "$op" = "0" ] && xdotool windowunmap "$w" 2>/dev/null
    done
    sleep 1
  done
) &

exec flatpak run --command=bottles-cli 'com.usebottles.bottles' run -p Eagle -b Eagle -- "$@"

#exec wine "C:\Program Files\Eagle\Eagle.exe" --disable-gpu "$@"
#exec wine explorer /Desktop=Eagle,3840x2160 "C:\Program Files\Eagle\Eagle.exe" --disable-gpu "$@"
