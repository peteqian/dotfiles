#!/bin/bash

location="Wuerzburg,97080,Germany"

weather=$(curl -fsS --max-time 4 "https://wttr.in/${location}?format=%l|%t|%w" 2>/dev/null | tr -d '\n')

if [[ -z $weather ]]; then
  echo "Weather unavailable"
  exit 1
fi

IFS='|' read -r place temperature wind <<< "$weather"
place=${place%%,*}
place=${place^}
temperature=${temperature#+}

echo "$place  ·  Temp $temperature  ·  Wind $wind"
