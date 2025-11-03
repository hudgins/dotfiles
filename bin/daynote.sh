daynote() {
  local daynote_dir="${HOME}/.daynote"
  local template_path="${daynote_dir}/daynote_template.md"
  local entries_dir="${daynote_dir}/entries"
  # These temporaries support editing and detecting whether anything changed.
  local tmp
  local tmp_orig
  local today
  local weekday
  local prev_entry_file
  local prev_entry_date
  local entry_date
  local nvim_status

  # Ensure we have a place to collect finalized entries.
  mkdir -p "$entries_dir"

  if [ ! -f "$template_path" ]; then
    echo "daynote: missing template at ${template_path}" >&2
    return 1
  fi

  # Create a scratch file that nvim will edit, and clean it up no matter how we exit.
  tmp=$(mktemp -t daynote.XXXXXX)
  tmp_orig="${tmp}.orig"
  trap 'rm -f "$tmp" "$tmp_orig"' EXIT
  today=$(date '+%Y-%m-%d')
  weekday=$(date '+%A')

  # Render the template with today’s date placeholders.
  awk -v date="$today" -v weekday="$weekday" '{
    gsub("{{DATE}}", date)
    gsub("{{WEEKDAY}}", weekday)
    print
  }' "$template_path" > "$tmp"

  # If the last saved entry is from a prior day, append it so unfinished work carries forward.
  prev_entry_file=$(find "$entries_dir" -type f -name '*.md' -print 2>/dev/null | sort | tail -n1)
  if [ -n "$prev_entry_file" ]; then
    prev_entry_date=$(basename "$prev_entry_file" .md)
    if [ "$prev_entry_date" != "$today" ]; then
      if [ -s "$prev_entry_file" ]; then
        printf "\n\n## Carryover from %s\n\n" "$prev_entry_date" >> "$tmp"
        cat "$prev_entry_file" >> "$tmp"
      fi
    fi
  fi

  # Remember the pre-edit state so we can tell if anything was saved.
  cp "$tmp" "$tmp_orig"

  nvim "$tmp"
  nvim_status=$?

  if [ $nvim_status -ne 0 ]; then
    echo "daynote: nvim exited with status ${nvim_status}; aborting." >&2
    return $nvim_status
  fi

  if cmp -s "$tmp_orig" "$tmp"; then
    echo "daynote: no changes saved; skipping Day One entry." >&2
    return 0
  fi

  if [ ! -s "$tmp" ]; then
    # Guard against accidentally wiping the note before submission.
    return 0
  fi

  # Use the first ISO date in the file (usually from the header) to back-date the entry if needed.
  entry_date=$(grep -Eo '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$tmp" | head -n1)
  if [ -z "$entry_date" ]; then
    entry_date="$today"
  fi

  # Push the note into Day One and stash a copy for tomorrow’s carryover logic.
  if dayone new --date "$entry_date" --journal "Retreat Guru" < "$tmp"; then
    cp "$tmp" "${entries_dir}/${entry_date}.md"
  else
    echo "daynote: failed to create Day One entry." >&2
    cp "$tmp" "${entries_dir}/${entry_date}.md"
  fi

  # Clear the carryover file once the new entry is saved under its date.
  if [ -n "$prev_entry_file" ] && [ "$prev_entry_date" != "$entry_date" ]; then
    rm -f "$prev_entry_file"
  fi

  rm -f "$tmp" "$tmp_orig"
  trap - EXIT
}
