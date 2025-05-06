#!/usr/bin/env bash

UVENV_ROOT="${UVENV_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/uvenv}"
UV_VERSION_SCRIPT="${UVENV_ROOT}/uv-python-version"

source "${UVENV_ROOT}/uvenv-functions.sh"

# Initialize UV_PYTHON_VERSION if not set.
# If not set, set it to the most recent uv managed version
if [[ -z "${UV_PYTHON_VERSION}" ]]; then
  export UV_PYTHON_VERSION=$("${UV_VERSION_SCRIPT}")
fi

if [[ -f "${UVENV_ROOT}/.python-version" ]]; then
  export UV_PYTHON_VERSION=$(cat "${UVENV_ROOT}/.python-version")
else
  export UV_PYTHON_VERSION=$("${UV_VERSION_SCRIPT}")
fi

# --| Update local version -----------------
function update_local_version() {
  # Read directly from .uvenv file if it exists
  local uvenv_file
  if uvenv_file=$(find_uvenv); then
    local version=$(cat "$uvenv_file" | tr -d '[:space:]')
    if [[ -n "$version" ]]; then
      export UV_LOCAL_PY_VERSION="$version"
      return 0
    fi
  fi

  # Clear local version if no .uvenv found
  if [[ -n "${UV_LOCAL_PY_VERSION}" ]]; then
    unset UV_LOCAL_PY_VERSION
  fi
}

update_local_version

# --| uvenv user functions -----------------
function uv-python-install() {
  uv python install "$@"
  "$UVENV_ROOT"/uv-python-shims
}

function uv-python-uninstall() {
  uv python uninstall "$@"
  "$UVENV_ROOT"/uv-python-shims
}

function uv-python-default() {
  uv-python-install "$@"

  "$UVENV_ROOT"/uv-python-shims "$@"
  echo "$@" >"${UVENV_ROOT}/.python-version"

  export UV_PYTHON_VERSION="$@"
}

# --| Shell Hooks --------------------------
# Add to chpwd hook for zsh
if [[ -n "${ZSH_VERSION}" ]]; then
  autoload -U add-zsh-hook
  add-zsh-hook chpwd update_local_version
fi
