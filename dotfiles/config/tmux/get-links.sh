#!/bin/bash

COMMANDS=(run_tmux_command)

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
SCRIPT_NAME=$(basename "$SCRIPT_PATH")

has_param() {
	local term="$1"
	shift
	for arg; do
		if [[ $arg == "$term" ]]; then return 0; fi
	done
	return 1
}

function run_tmux_command() {
	local selected_command selected_item
	selected_command=$(echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
	selected_item="$2"

	if ! command -v "$selected_command" >/dev/null 2>&1; then
		tmux display-message "\`$selected_command\` is not a command."
		exit 0
	fi

	if [ -n "$selected_command" ]; then
		tmux confirm-before -p "Run \`${selected_command} ${selected_item}\`? (y/n)" "run-shell '${selected_command} ${selected_item}'"
		exit 0
	else
		tmux display-message "No command entered."
	fi
}

function default() {
	local mode current_path text regex matches selected_item unique_matches
	mode="open"
	current_path="$2"                                         # TMUX current pane path
	text="$(cat | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')" # Capture piped data

	# Check for the presence of a flag argument
	if [[ "$1" == "--prompt" ]] || [[ "$1" == "-P" ]]; then
		mode="prompt"
	fi

	# Check if text text is empty
	if [[ -z "$text" ]]; then
		tmux display-message "No data provided."
		exit
	fi

	# Get the Alacritty regex for parsing links
	regex="$(command grep 'regex =' ~/.config/alacritty/alacritty.toml | sed -E "s/.*= [\"'\'\`\`](.*)[\"'\'\`\`]$/\1/")"

	# Use regex to get the links
	matches=$(echo "$text" | perl -nle "print $& while m{$regex}g")

	# Filter out duplicates
	while IFS= read -r line; do
		if [[ ! ${unique_matches[*]} =~ $line ]]; then
			unique_matches+=("$line")
		fi
	done < <(echo "$matches")

	# Check if there are no unique matches found
	if [ ${#unique_matches[@]} -eq 0 ]; then
		tmux display-message "No links found."
		exit 0
	fi

	# Use fzf-tmux to select from the array
	selected_item=$(printf "%s\n" "${unique_matches[@]}" | fzf-tmux -d15 --multi --bind ctrl-a:select-all,ctrl-d:deselect-all | sed "s|^~|$HOME|" | sed "s|^\./|$current_path/|")

	# Exit if no selection is made
	if [ -z "$selected_item" ]; then
		tmux display-message "No selection made."
		exit 0
	fi

	if [ "$mode" == "prompt" ]; then
		tmux command-prompt -p "Command to run for \`${selected_item}\`:" "run-shell 'source '$SCRIPT_DIR/$SCRIPT_NAME' && run_tmux_command '%%' '$selected_item'"
	else
		tmux run-shell "xargs -I {} open '{}' <<< '$selected_item'"
	fi
}

if [[ $# -gt 0 ]]; then
	found=0
	for cmd in "${COMMANDS[@]}"; do
		if [[ "$cmd" == "$1" ]]; then
			found=1
			break
		fi
	done
	if [[ $found -eq 1 ]]; then
		"$1" "${@:2}"
	else
		default "${@}"
	fi
fi
