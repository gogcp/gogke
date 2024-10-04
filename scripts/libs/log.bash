set -e

function log::error {
  local log="$1"

  printf "Error: %s\n" "${log}"
}

function log::info {
  local log="$1"

  printf "Info: %s\n" "${log}"
}
