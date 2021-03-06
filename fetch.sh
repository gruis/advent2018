#!/usr/bin/env bash

# Almost a 100% copy of https://github.com/petertseng/adventofcode-rb-2018/blob/master/fetch.sh

yes=

if [ "$1" = "--yes" ]; then
  yes=1
  shift
fi

day=$1

if [ $# -eq 0 ]; then
  day=$(TZ=UTC date +%-d)
  echo "OK, we have to guess the day, let's guess $day???"
else
  shift
  if [ "$1" = "--yes" ]; then
    yes=1
    shift
  fi
fi

daypad=$(seq -f %02g $day $day)
daypad="${daypad}_$1"

if [ "$yes" = "1" ]; then
  if [ -f input$day ]; then
    echo "THE INPUT ALREADY EXISTS!!!"
  else
    curl --cookie session=$(cat session) -o input$day https://adventofcode.com/2018/day/$day/input
  fi
else
  curl -o input$day http://example.com
fi

if [ -f $daypad.rb ]; then
  backup="$daypad-$(date +%s).rb"
  echo "I think we should back up $daypad.rb to $backup!"
  mv $daypad.rb $backup
fi

if [ -f TEMPLATE.rb ]; then
  cat TEMPLATE.rb input$day > $daypad.rb
  rm input$day
elif [ -f t.rb ]; then
  cat t.rb input$day > $daypad.rb
  rm input$day
fi

chmod +x $daypad.rb
