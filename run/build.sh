#!/bin/env bash
set -e

usage() {
  echo "Usage: $0 -m <main_file>"
  exit 1
}

# Parse arguments
while getopts ":m:" opt; do
  case ${opt} in
    m )
      LF_MAIN=$OPTARG
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument" 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if LF_MAIN is set
if [ -z "${LF_MAIN}" ]; then
  usage
fi

# Check if an environment variable is set
if [ -z "${REACTOR_UC_PATH}" ]; then
  echo "Environment variable REACTOR_UC_PATH is not set"
  exit 1
fi

LF_MAIN_NAME=$(basename ${LF_MAIN} .lf)
SRC_DIR=$(dirname ${LF_MAIN})
SRC_GEN_PATH=$(echo ${SRC_DIR} | sed "s/src/src-gen/")


echo "Generating source files for ${LF_MAIN_NAME} into ${SRC_GEN_PATH}"

${REACTOR_UC_PATH}/lfc/bin/lfc-dev ${LF_MAIN}

cmake -Bbuild -DLF_SRC_GEN_PATH=${SRC_GEN_PATH} -DLF_MAIN_NAME=${LF_MAIN_NAME}