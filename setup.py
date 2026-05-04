

# setup.py

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


setup(
    ext_modules=[
        Extension("forbit", sources=[]),
    ],
    cmdclass={
        "build_ext": ForbitBuildExt,
    },
)
