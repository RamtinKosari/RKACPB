#!/bin/bash

# - Definitions
YELLOW='\033[1m\033[38;2;255;255;0m'
RED='\033[1m\033[38;2;255;0;0m'
RESET='\033[0m'

# - Log Terminal Messages
WARNING="${YELLOW}[WARNING]${RESET}"
FAILED="${RED}[FAILED]${RESET}"

# - Default Extensions List
EXTENSION_LIST=( "*.cpp" "*.hpp" )

# - User Extensions List
USER_EXTENSION_LIST=()

if [ ! -d "../build" ]; then
    mkdir ../build
else
    echo -e "$WARNING Build Directory Already Exists. Clearing the Build Directory."
    rm -rf ../build/*
fi

# - Copy Prepared CMakeLists.txt File to Root Directory
cp CMakeLists.txt ../

# - Go to Previous Directory
cd ..

# - Parse Input Options Using getopt
OPTS=$(getopt -o e:p: -l extensions:,packages: -n "$0" -- "$@")
eval set -- "$OPTS"
while true; do
  case "$1" in
    -e|--extensions)
      USER_EXTENSION_LIST+=("$2")
      shift 2
      ;;
    -p|--packages)
      PACKAGES="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo -e "$FAILED Invalid Option"
      exit 1
  esac
done

# Extracti Extensions from the Command Line Arguments
for extended in "$@"; do
  if [[ "$extended" == *"."* ]]; then
    USER_EXTENSION_LIST+=("$extended")
  fi

# - Find All Files with Given Extensions
if [ ${#USER_EXTENSION_LIST[@]} -ne 0 ]; then
  find_expression=()
  for ext in "${USER_EXTENSION_LIST[@]}"; do
    find_expression+=("-name" "$ext" "-o")
  done
  find_expression=("${find_expression[@]:0:$((${#find_expression[@]}-1))}")
else
  find_expression=()
  for ext in "${EXTENSION_LIST[@]}"; do
    find_expression+=("-name" "$ext" "-o")
  done
  find_expression=("${find_expression[@]:0:$((${#find_expression[@]}-1))}")
fi
source_files=$(find . -type f \( "${find_expression[@]}" \))


# - Check if Source List is Empty
if [ -z "$source_files" ]; then
    echo -e "$WARNING No Files with Used Extensions Found in the Project Directory."
    exit 1
fi

# - Change directory to the build folder
cd build

# - Replace Spaces with Semicolons in the Source Files List
source_files=$(echo $source_files | tr ' ' ';')

# - Run the CMake Command with the Modified File List
cmake -D_SRC="$source_files" -D_USE_PACKAGES="$PACKAGES" ..
make
