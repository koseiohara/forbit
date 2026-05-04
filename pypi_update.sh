#!/usr/bin/env bash
set -euo pipefail

# Run this script from the project root.

PROJECT_ROOT="$(pwd)"
DIST_DIR="${PROJECT_ROOT}/dist"

echo "[1/7] Checking pyproject.toml version..."
VERSION="$(
python - <<'PY'
import tomllib
with open("pyproject.toml", "rb") as f:
    data = tomllib.load(f)
print(data["project"]["version"])
PY
)"

echo "Version: ${VERSION}"

echo "[2/7] Removing old build artifacts..."
rm -rf build dist src/forbit.egg-info

echo "[3/7] Building sdist..."
python -m build --sdist

echo "[4/7] Running twine check..."
python -m twine check dist/*

echo "[5/7] Testing local install from sdist..."
TEST_ENV="${HOME}/python_test/forbit-release-test-${VERSION}"
rm -rf "${TEST_ENV}"
python -m venv "${TEST_ENV}"
source "${TEST_ENV}/bin/activate"
python -m pip install -U pip
python -m pip install "${DIST_DIR}/forbit-${VERSION}.tar.gz"
python -c "import forbit; print(forbit)"
deactivate

echo "[6/7] Git status..."
git status --short

echo
echo "If the version, test, and git status are OK, upload with:"
echo
echo "    python -m twine upload dist/*"
echo
echo "[7/7] Done. PyPI upload is intentionally manual."


