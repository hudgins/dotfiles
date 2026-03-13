#!/bin/zsh
mkdir -p ~/.calendars
curl -fsSL "https://calendar.google.com/calendar/ical/allan%40retreat.guru/private-8795b8ff5909dce5fbd7931c5fc6e638/basic.ics" \
  -o ~/.calendars/rg-allan.ics
curl -fsSL "https://calendar.google.com/calendar/ical/bluemandala.com_f57fvqibs957oqlvo3s0cepnno%40group.calendar.google.com/private-fc172e4675d6e3fd567a84a22c0a07b4/basic.ics" \
  -o ~/.calendars/rg-team.ics
