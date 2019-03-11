#!/usr/bin/env sh
DIR="$HOME"/.scripts/.sshc
SCRIPT="$HOME"/.scripts/sshc

mkdir -p "$DIR"

cp "$(pwd)"/sshc.rb "$DIR"
chmod +x "$DIR"/sshc.rb

cp "$(pwd)"/sshc "$SCRIPT"
chmod +x "$SCRIPT"

if [ -f "$(pwd)"/aws-instances ]; then
  cp "$(pwd)"/aws-instances "$DIR"/aws-instances
else
  touch "$DIR"/aws-instances
fi

