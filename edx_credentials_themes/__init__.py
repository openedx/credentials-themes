from importlib.metadata import PackageNotFoundError, version

try:
    __version__ = version("edx_credentials_themes")
except PackageNotFoundError:  # pragma: no cover
    __version__ = "unknown"
