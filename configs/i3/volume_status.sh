#!/bin/bash

if pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes; then
  echo "MUTE"
else
  echo "VOL"
fi
