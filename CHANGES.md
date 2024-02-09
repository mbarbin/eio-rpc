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
