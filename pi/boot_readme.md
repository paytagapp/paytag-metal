sudo nano /etc/xdg/lxsession/LXDE-pi/autostart

@xset s off
@xset -dpms
@xset s noblank
@unclutter -idle 0.1 -root # This make the mouse disappear
@chromium-browser --kiosk http://localhost:8080  # load chromium after boot and open the website in full screen mode
