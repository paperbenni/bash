#!/usr/bin/env bash
spamtext(){
  sleep 3 && loop 200 "xdotool type $1 && xdotool sleep 0.010 key Return && sleep 0.01"
}
