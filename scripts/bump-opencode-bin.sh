#!/bin/bash

set -euo pipefail

repo_root=$(dirname "$(dirname "$(readlink -f "$0")")")
pkg_dir="${repo_root}/dev-util/opencode-bin"

version=${1:-}
if [[ -z "${version}" ]]; then
	tag=$(gh api repos/anomalyco/opencode/releases/latest --jq '.tag_name')
	gh api repos/anomalyco/opencode/releases/latest \
		--jq '.assets[] | select(.name == "opencode-desktop-linux-amd64.deb") | .browser_download_url' \
		> /dev/null
	version=${tag#v}
fi

new_ebuild="${pkg_dir}/opencode-bin-${version}.ebuild"
if [[ -e "${new_ebuild}" ]]; then
	printf 'ebuild already exists: %s\n' "${new_ebuild}"
	exit 0
fi

latest_ebuild=$(printf '%s\n' "${pkg_dir}"/opencode-bin-*.ebuild | sort -V | tail -n1)
cp "${latest_ebuild}" "${new_ebuild}"

"${repo_root}/scripts/build-manifest.sh"
