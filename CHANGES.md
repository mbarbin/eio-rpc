## 0.0.6 (2024-07-26)

### Added

- Added dependabot config for automatically upgrading action files.

### Changed

- Upgrade `ppxlib` to `0.33` - activate unused items warnings.
- Upgrade `ocaml` to `5.2`.
- Upgrade `dune` to `3.16`.
- Upgrade `ocaml-protoc` to `3.1`, the required changes from the previous fork have now been upstreamed.
- Upgrade base & co to `0.17`.

### Removed

- Remove `qcheck` & `protoc-quickcheck` dependencies.

## 0.0.5 (2024-03-13)

### Changed

- Upgrade `fpath-base` to `0.0.9` (was renamed from `fpath-extended`).
- Upgrade `eio` to `1.0` (no change required).
- Uses `expect-test-helpers` (reduce core dependencies).
- Upgrade `eio` to `0.15`.
- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

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
