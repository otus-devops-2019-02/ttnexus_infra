#!/bin/bash
set -e

su appuser -c "cd ~ && \
git clone -b monolith https://github.com/express42/reddit.git && \
cd ~/reddit && \
bundle install"

echo "[Unit]
Description=Puma HTTP Server
After=network.target

# Uncomment for socket activation (see below)
# Requires=puma.socket

[Service]
# Foreground process (do not use --daemon in ExecStart or config.rb)
Type=simple

# Preferably configure a non-privileged user
# User=

# The path to the your application code root directory.
# Also replace the YOUR_APP_PATH place holders below with this path.
# Example /home/username/myapp
WorkingDirectory=/home/appuser/reddit

# Helpful for debugging socket activation, etc.
# Environment=PUMA_DEBUG=1

# SystemD will not run puma even if it is in your path. You must specify
# an absolute URL to puma. For example /usr/local/bin/puma
# Alternatively, create a binstub with bundle binstubs puma --path ./sbin in the WorkingDirectory
ExecStart=/usr/local/bin/puma

# Variant: Rails start.
# ExecStart=/<FULLPATH>/bin/puma -C <YOUR_APP_PATH>/config/puma.rb ../config.ru

# Variant: Use bundle exec --keep-file-descriptors puma instead of binstub
# Variant: Specify directives inline.
# ExecStart=/<FULLPATH>/puma -b tcp://0.0.0.0:9292 -b ssl://0.0.0.0:9293?key=key.pem&cert=cert.pem


Restart=always

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/puma.service


systemctl enable puma

