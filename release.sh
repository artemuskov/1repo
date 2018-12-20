#!/usr/bin/env bash
set -o errexit
set -o nounset

#-------------------------------------------------------------------------------
# Emit an error message and then usage information and then exit the program.
#-------------------------------------------------------------------------------
function error() {
  echo 1>&2 "ERROR: $@"
}

#-------------------------------------------------------------------------------
# Emit an error message and then usage information and then exit the program.
#-------------------------------------------------------------------------------
function usage_error() {
  error "$@"
  echo 1>&2
  usage
  exit 1
}

#--------------------------------------------------------------------------------------------------
function release() {
  local version="${1}"

  git tag -a v"${version}" -m "my version ${version}"
  git push origin v"${version}"
}

#-------------------------------------------------------------------------------
# Main program.
#-------------------------------------------------------------------------------
function main() {
  local version=""

  # Parse the arguments from the commandline.
  while [[ ${#} -gt 0 ]]; do
    case "${1}" in
      --version)              version="${1}"; shift;;
      -h|--help)              usage; exit 0;;
      --)                     break;;
      -*)                     usage_error "Unrecognized option ${1}";;
    esac
    shift
  done

  release ${version}
}

main "${@:-}"
