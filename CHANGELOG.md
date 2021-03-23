# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [UNRELEASE]

### Added

- Handle allowlist in the file `.ad_licenselint.yml` ([#9](https://github.com/faberNovel/ad_licenselint/pull/9))

### Fixed

- Search pod specification in both `trunk` and `master` sources ([#8](https://github.com/faberNovel/ad_licenselint/pull/8))

## [1.1.0] - 2020-08-06

### Added

- New option `--only` to lint a subset of pods
- Add `Apache 2.0` to accepted licenses

### Fixed

- Fix report that was created twice
- Allow to pass optional parameters for `Runner.new`

## [1.0.0] - 2020-08-05

Initial version
