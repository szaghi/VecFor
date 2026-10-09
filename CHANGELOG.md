# Changelog

All notable changes to this project are documented here.
Versions follow [Semantic Versioning](https://semver.org/).
Format follows [Keep a Changelog](https://keepachangelog.com/).

## [1.5.1] — 2026-10-09
### Fixed
- **ci**: Run install smoke test from the release workflow

- **tests**: Update printf doctest for PENF exact compact str and exclude PENF docs/scripts


## [1.5.0] — 2026-10-02
### Added
- **openacc**: Implement device loop testing framework for vecfor library

- **openacc**: Add device-callable _oac API for FOSSIL distance-kernel ops

- **release**: Rebuild release pipeline around git-cliff and release.sh


### Fixed
- **fobos**: Correct gcov_analyzer flag syntax in coverage rule

- **coverage**: Update makecoverage rule to new FoBiS.py CLI syntax

- **coverage**: Drop source-based gcov call that fails on fresh CI builds

- **openacc**: Narrow device annotations to minimum-set tested on nvfortran 26.1

- **fobos**: Stop deldoc from wiping committed docs/api/

- **coverage**: Restore compute-coverage.sh call in makecoverage rule

- **docs**: Untrack package-lock and pin esbuild for lock-free vite build

- **vector**: Rename quad-precision guard from _R16P to PENF_R16P


## [1.4.7] — 2026-02-28
### Documentation
- Update install guides to use FoBiS fetch instead of submodules


## [1.4.5] — 2026-02-21
### Fixed
- **coverage**: Exclude aggregator module from gcov to prevent missing gcda error


## [1.4.4] — 2026-02-21
### Fixed
- **coverage**: Restrict gcov glob to .F90 to avoid INC filename mismatch


## [1.4.3] — 2026-02-20
### Fixed
- **doctests**: Preprocess .F90 files to expose INC-embedded doctests


## [1.4.2] — 2026-02-20
### Added
- Add vitepress docs site, release pipeline, and cliff changelog



