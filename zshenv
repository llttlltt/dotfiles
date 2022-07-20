# WRITE FUNCTIONS
## Checks if a command exists
function exists() {
  command -v $1 >/dev/null 2>&1
}