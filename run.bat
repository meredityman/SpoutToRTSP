@echo off

set ip_address_string="IPv4 Address"

for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
echo IP Address: %NetworkIP%

cd .\happytime-rtsp-server-x64\
start cmd /k .\RtspServer.exe -c .\spout-config.xml

cd ..\
timeout /t 2

cd .\ffmpeg-4.1.1-win32-static\bin\

set pusher_address=rtsp://%NetworkIP%/pusher.rtsp

set ffmpeg_cmd=.\ffmpeg.exe -re -f dshow -rtbufsize 100M -i video="Spout Cam" -movflags faststart -vcodec libx264 -preset fast -profile:v baseline -acodec mp3 -channels 2  -ar 44100 -pix_fmt yuv420p -b:v 500k -b:a 128k -g 5 -f rtsp %pusher_address%

start cmd /k %ffmpeg_cmd%
pause