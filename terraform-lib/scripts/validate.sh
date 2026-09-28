#!/usr/bin/env bash
set -euo pipefail
LIB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
terraform fmt -check -recursive "$LIB_ROOT"
init_args=(-backend=false -input=false -no-color)
if [[ -n "${TF_LIB_PLUGIN_DIR:-}" ]]; then
  init_args+=("-plugin-dir=$TF_LIB_PLUGIN_DIR")
fi
for directory in "$LIB_ROOT"/modules/* "$LIB_ROOT"/examples/*; do
  echo "Validating ${directory#"$LIB_ROOT/"}"
  terraform -chdir="$directory" init "${init_args[@]}" > /dev/null
  terraform -chdir="$directory" validate -no-color
  if [[ -d "$directory/tests" ]]; then
    terraform -chdir="$directory" test -no-color
  fi
done
