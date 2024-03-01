## 0.0.5 (unreleased)

### Added

### Changed

- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

### Deprecated

### Fixed

### Removed

## 0.0.4 (2024-02-14)

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

## 0.0.3 (2024-02-09)

### Added

- Add helper library for roundtrip tests with quickcheck.

### Changed

- Internal changes related to the release process.
- Upgrade dune and internal dependencies.
- Improve `bisect_ppx` setup for test coverage.

## 0.0.2 (2024-01-29)

### Added

- Add initial testing facility.
- Enable code coverage with bisect_ppx.
- Add protoc quickcheck roundtrip tests.

### Changed

- Refactor stdout I/O, replace Stdio by Eio_writer.
- Improved documentation.
- Switched to first class module based API (breaking change).

### Fixed

- Fix #1 serialization issue. Changed wire representation.

## 0.0.1 (2024-01-18)

Initial release.
