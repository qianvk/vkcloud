#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to add or update a git submodule to a specific tag
add_or_update_submodule() {
    local REPO_URL=$1
    local SUBMODULE_PATH=$2
    local TAG=$3

    if [ -d "$SUBMODULE_PATH" ]; then
        echo "Updating existing submodule: $SUBMODULE_PATH"
        cd "$SUBMODULE_PATH"
        git fetch --tags
        git checkout "$TAG"
        cd - > /dev/null
    else
        echo "Adding new submodule: $SUBMODULE_PATH"
        git submodule add "$REPO_URL" "$SUBMODULE_PATH"
        cd "$SUBMODULE_PATH"
        git checkout "$TAG"
        cd - > /dev/null
    fi
}

# Ensure we are in the root of the Git repository
if [ ! -d ".git" ]; then
    echo "Error: This script must be run from the root of a Git repository."
    exit 1
fi

# echo "Initializing and updating submodules..."
# git submodule update --init --recursive

# Add or update Boost (only Asio & Beast required)
add_or_update_submodule "https://github.com/boostorg/boost.git" "third_party/boost" "boost-1.84.0"
cd third_party/boost
git submodule update --init --recursive libs/asio libs/system libs/throw_exception libs/core libs/assert libs/config libs/date_time libs/smart_ptr libs/utility libs/static_assert libs/type_traits libs/numeric/conversion libs/mpl libs/preprocessor \
  libs/beast libs/optional libs/mp11 libs/bind libs/intrusive libs/move libs/logic libs/static_string libs/container_hash libs/describe libs/io libs/endian
cd -

# Add or update JsonCpp
add_or_update_submodule "https://github.com/open-source-parsers/jsoncpp.git" "third_party/jsoncpp" "1.9.6"

echo "All submodules initialized successfully!"

# Update all submodules to ensure correct versions
# git submodule update --recursive --remote

