#!/bin/bash

# Get the current sleep setting for the hard disk
sleep_setting=$(pmset -g | grep "disksleep" | awk '{print $2}')

if [ "$sleep_setting" == "0" ]; then
  echo "Hard disk sleep is currently disabled."
else
  echo "Hard disk sleep is currently set to ${sleep_setting} minutes."
fi
