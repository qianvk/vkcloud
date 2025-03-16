#!/bin/bash

set -e # Exit on error

# Define specific submodules and their versions
declare -A SUBMODULES
SUBMODULES["third_party/jsoncpp"]="tags/1.9.6"

BOOST_LIBS=("asio" "system" "throw_exception" "core" "assert" "config" "date_time" "smart_ptr" "utility" "static_assert" "type_traits" "numeric/conversion" "mpl" "preprocessor"
	"beast" "optional" "mp11" "bind" "intrusive" "move" "logic" "static_string" "container_hash" "describe" "io" "endian")

# Function to update a specific submodule
update_submodule() {
	local path=$1
	local version=$2

	echo "🔄 Updating submodule: $path to version/tag: $version"
	# Fetch latest tags and checkout the specified version
	cd "$path"
	git fetch --tags
	git checkout "$version" || {
		echo "❌ Failed to checkout $version for $path"
		exit 1
	}
	cd - >/dev/null
}

git submodule update --init

for ITEM in "${BOOST_LIBS[@]}"; do
	cd "third_party/boost"
	git submodule update --init --recursive "libs/${ITEM}"
	cd - >/dev/null
	path="third_party/boost/libs/${ITEM}"
	update_submodule "$path" "boost-1.87.0"
done

# Loop through specific submodules and update them
for path in "${!SUBMODULES[@]}"; do
	update_submodule "$path" "${SUBMODULES[$path]}"
done

echo "✅ Finished updating specific submodules!"
