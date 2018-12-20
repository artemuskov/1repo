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
# Create stack in AWS.
#--------------------------------------------------------------------------------------------------
function deploy() {
  local version="${1}"
  local region="${2}"
  local stack_name="${3}"

  local params=""
  params="${params:+${params} }ParameterKey=Version,ParameterValue=${version}"

  aws cloudformation create-stack                       \
    --stack-name "${stack_name}"                        \
    --region "${region}"                                \
    --template-body file://$(dirname $0)/cfn.yaml       \
    --parameters ${params}
}

#-------------------------------------------------------------------------------
# Emit the program's usage to the console.
#-------------------------------------------------------------------------------
function usage() {
    cat <<EOF
Usage: ${0#./} [OPTION]...

Options:

  --stack-name
      [Optional] Name of created stack. "S3bucket" is default.

  --bucket-name
      [Optional] The name of created bucket

  -h/--help
      Display this help message.
EOF
}

#-------------------------------------------------------------------------------
# Main program.
#-------------------------------------------------------------------------------
function main() {
  local version=""
  local stack_name="S3bucket"
  local region="us-east-1"

  # Parse the arguments from the commandline.
  while [[ ${#} -gt 0 ]]; do
    case "${1}" in
      --version)              version="${2}"; shift;;
      --stack-name)           stack_name="${2}"; shift;;
      -h|--help)              usage; exit 0;;
      --)                     break;;
      -*)                     usage_error "Unrecognized option ${1}";;
    esac

    shift
  done

  # Finally create the stack
  deploy                  \
    "${version}"          \
    "${region}"           \
    "${stack_name}"       \
}

main "${@:-}"
