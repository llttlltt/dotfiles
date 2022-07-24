#!/usr/bin/env zsh

echo "\n<<< STARTING LPORG (LAUNCHPAD) SETUP >>>\n"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup Launchpad using lporg.

if exists lporg; then
  echo "lporg detected, continuing... "
  echo "Loading lporg configuration from $BASEDIR/preferences/lporg_launchpad.yaml.\n"
  lporg load $BASEDIR/preferences/lporg_launchpad.yaml --backup
  mv ~/.launchpad.yaml $BASEDIR/preferences/lporg_launchpad_backup.yaml && echo "Launchpad backed up to $BASEDIR/preferences/lporg_launchpad_backup.yaml.\n" || echo "Could not locate lporg launchpad.yaml file.\n"
else
  echo "lporg was not found, skipping step...\n"
fi