

# setup.py

import re
from pathlib import Path
import shutil
import subprocess
import sys

from setuptools import Extension, setup
from setuptools.command.build_ext import build_ext


class ForbitBuildExt(build_ext):
    def run(self):
        root = Path(__file__).parent.resolve()
        src = root / "src"

        subprocess.check_call(
            ["make", f"PYTHON={sys.executable}"],
            cwd=src,
        )

        for ext in self.extensions:
            self.build_extension(ext)


    def build_extension(self, ext):
        root = Path(__file__).parent.resolve()
        src = root / "src"

        ext_path = Path(self.get_ext_fullpath(ext.name))
        ext_path.parent.mkdir(parents=True, exist_ok=True)

        built = src / ext_path.name

        if not built.exists():
            raise RuntimeError(f"Could not find built extension module: {built}")

        shutil.copy2(built, ext_path)

def read_project_metadata():
    text = Path("pyproject.toml").read_text(encoding="utf-8")

    project_match = re.search(
        r"(?ms)^\[project\]\s*(.*?)(?=^\[|\Z)",
        text,
    )
    if project_match is None:
        raise RuntimeError("Could not find [project] section in pyproject.toml")

    project_text = project_match.group(1)

    name_match = re.search(r'(?m)^name\s*=\s*"([^"]+)"\s*$', project_text)
    version_match = re.search(r'(?m)^version\s*=\s*"([^"]+)"\s*$', project_text)

    if name_match is None:
        raise RuntimeError("Could not find project.name in pyproject.toml")
    if version_match is None:
        raise RuntimeError("Could not find project.version in pyproject.toml")

    return name_match.group(1), version_match.group(1)

proj_name, proj_version = read_project_metadata()
# print(f"{proj_name} version{proj_version}")

setup(
    name=proj_name,
    version=proj_version,
    ext_modules=[
        Extension("forbit", sources=[]),
    ],
    cmdclass={
        "build_ext": ForbitBuildExt,
    },
)



