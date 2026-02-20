# Changelog
## [Unreleased]
### Miscellaneous
- Update makefile ([`72f89e3`](https://github.com/szaghi/FLAP/commit/72f89e332ebf4b4a17760dd4c9e9d4d6b0d99e39))

## [v1.4.1](https://github.com/szaghi/FLAP/tree/v1.4.1) (2022-07-06)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.4.0...v1.4.1)
### Bug fixes
- Fix doctests preprocessing issues and clean fobos ([`3e9bee2`](https://github.com/szaghi/FLAP/commit/3e9bee29b8bad25c7aba29f1749e33a96ce55670))
- Fix default kind vector issues ([`a5547a3`](https://github.com/szaghi/FLAP/commit/a5547a3982203a162977668177ee1b85084c24c2))
- Fix default kind vector issues again ([`fbfe0df`](https://github.com/szaghi/FLAP/commit/fbfe0df44ba4b5b04169b643417121c654faaf8b))
- Fix default kind issues again and again ([`81e82db`](https://github.com/szaghi/FLAP/commit/81e82db16f977857d01700202dc7fd1996b9030d))

### Miscellaneous
- Merge tag 'v1.4.0' into develop

Refactor library fixing entities renaming

Completely refactor the library: the previous entities renaming to
obtain multiprecision was non standard thus a deep refactoring has been
necessary.

Why:

Being standard compliant

This change addresses the need by:

Remove `use, only` aliases relaying much more on preprocessing macros.

Side effects:

Public API should be backward compatible, but internally many changes
happen, it is not clear of possible side effects on third party
libraries that consume VecFor for now. ([`34f87c1`](https://github.com/szaghi/FLAP/commit/34f87c19e0558f3afb783e31a17a70380799b305))
- Update submodules ([`c019117`](https://github.com/szaghi/FLAP/commit/c01911714c8cb569da67c5245f4017925e24c97c))
- Merge branch 'master' into develop ([`ad4391d`](https://github.com/szaghi/FLAP/commit/ad4391da024fd3d61bf96de24fa71f14651c0859))
- Add missing vector default kind ([`e3a0d3c`](https://github.com/szaghi/FLAP/commit/e3a0d3cad3a4b2bc2b31fe8928cfdaf0569ac439))
- Merge branch 'master' into develop ([`56e7d3e`](https://github.com/szaghi/FLAP/commit/56e7d3e052466b9263609eb6568c9c6bdcff52ff))
- Merge branch 'master' into develop ([`12d7f82`](https://github.com/szaghi/FLAP/commit/12d7f824416b55756d51624a363b60295af361e0))
- Re-add pre-processing flag for unsupported R16P ([`9f8e4a0`](https://github.com/szaghi/FLAP/commit/9f8e4a035004e4b2ca15bce280baf76144e1fc9e))
- Minor change to enable NVFortran compilation ([`c0bb99e`](https://github.com/szaghi/FLAP/commit/c0bb99e5f325c0e70eb5b60bdc30337cef168bca))
- Switch to GH actions ([`6f11190`](https://github.com/szaghi/FLAP/commit/6f11190dded2456f1ee0f26cf273677e8283fb97))

## [v1.4.0](https://github.com/szaghi/FLAP/tree/v1.4.0) (2019-09-10)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.3.0...v1.4.0)
### Miscellaneous
- Merge tag 'v1.3.0' into develop

Stable release. add support concurrent multi-kind vector

Add support for (concurrent) multi-kind vectors: now vectors can be
defined with real32, real64 and real128 kind concurrently, vector_R4P,
vector_R8P and vector_R16P respectively. There is still the default
vector with the default kind (R8P if no otherwise defined). ([`3186e56`](https://github.com/szaghi/FLAP/commit/3186e5693a7509030865588200dc53316bec4c30))
- Quick and dirty fix for intel compiling issue: disabled default kind if compiled with other than gfortran ([`5a2d55b`](https://github.com/szaghi/FLAP/commit/5a2d55b5c40a4c41ee9a56c1392cac2fb2e24051))
- Make operators methods public to fix issue with unknown operators errors... ([`9d6efc0`](https://github.com/szaghi/FLAP/commit/9d6efc094b97410429dbc832d63dd2365c51357d))
- Add rotate/mirror/matrixprodruct methods ([`98a1c10`](https://github.com/szaghi/FLAP/commit/98a1c1049f0fa55ecbd42671c73f961345f349ca))
- Merge branch 'master' into develop ([`d90c6a2`](https://github.com/szaghi/FLAP/commit/d90c6a25f532fde93794c814bb2efc294cd15bd6))
- Cosmetic fix ([`6b58a08`](https://github.com/szaghi/FLAP/commit/6b58a08e7ddf174c2d1bd61e07b1803923a8aa90))
- Update PENF ([`4b0c4ff`](https://github.com/szaghi/FLAP/commit/4b0c4ff5f8e35270182b0cc0a26ada0cea8da38b))
- Typos

print has changed to printf

ponint1 -> point1 ([`86b5306`](https://github.com/szaghi/FLAP/commit/86b5306351dff91b7444adf4b25a7391d8166878))
- Merge pull request [#9](https://github.com/szaghi/FLAP/issues/9) from pdebuyl/master

Minor updates (typos and update of PENF) ([`11ea0aa`](https://github.com/szaghi/FLAP/commit/11ea0aadc6346f29ecabcacc38697a61492f44be))
- Add test for front module usage ([`2451967`](https://github.com/szaghi/FLAP/commit/24519672d29dc441d6bcc1f6d5dc533d70203ae2))
- Merge branch 'master' into develop ([`1a52446`](https://github.com/szaghi/FLAP/commit/1a52446d270c3a287714e07cc317ccbf13851214))
- Remove entities aliasing

Remove entities aliasing being not useful and non standard compliant if
imported (used) by others units. ([`bd6d455`](https://github.com/szaghi/FLAP/commit/bd6d4550ec73aaa0be0b1549461361f48ca915a6))
- Refactor library fix entities renaming

Completely refactor the library: the previous entities renaming to
obtain multiprecision was non standard thus a deep refactoring has been
necessary.

Why:

Being standard compliant

This change addresses the need by:

Remove `use, only` aliases relaying much more on preprocessing macros.

Side effects:

Public API should be backward compatible, but internally many changes
happen, it is not clear of possible side effects on third party
libraries that consume VecFor for now. ([`7072547`](https://github.com/szaghi/FLAP/commit/7072547a15842b77f944beb7db2d1d09d2b224f3))
- Merge branch 'feature/fix-entity-rename-use-module' into develop ([`e92230a`](https://github.com/szaghi/FLAP/commit/e92230a70744dd7aad5ff224b78b445337eb054f))
- Merge branch 'release/1.4.0' ([`4305335`](https://github.com/szaghi/FLAP/commit/43053359ca16cbad05c08a253c7990a86926be02))

## [v1.3.0](https://github.com/szaghi/FLAP/tree/v1.3.0) (2018-04-11)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.2.2...v1.3.0)
### Miscellaneous
- Merge tag 'v1.2.2' into develop

Add parametrized KIND for vector members

Add parametrized KIND for vector members: now the kind of the members of
the vector can be "parametrized", namely this kind can be selected at
compiled time specifying the proper pre-processing flag. ([`b7304b4`](https://github.com/szaghi/FLAP/commit/b7304b4fb258b3c9bd2de1ca3739a826bb8a9064))
- Add multi-kind vector types ([`589cad1`](https://github.com/szaghi/FLAP/commit/589cad1529fe6b9c26ee6aa8552dc12009327083))
- Merge branch 'release/1.3.0' ([`69a6694`](https://github.com/szaghi/FLAP/commit/69a6694deedf2b0e701b84ed2eed2ee6d2f8aa3d))

## [v1.2.2](https://github.com/szaghi/FLAP/tree/v1.2.2) (2017-11-23)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.2.1...v1.2.2)
### Miscellaneous
- Merge tag 'v1.2.1' into develop

Add angle method and function

Compute the angle between two vectors
using accurate formula based on both sin and cos functions.

Stable release, fully backward compatible. ([`13024ef`](https://github.com/szaghi/FLAP/commit/13024ef06e293578394b0c110d4d044e1424d047))
- Add parametrized KIND for vector members

Add parametrized KIND for vector members: now the kind of the members of
the vector can be "parametrized", namely this kind can be selected at
compiled time specifying the proper pre-processing flag. ([`205f0de`](https://github.com/szaghi/FLAP/commit/205f0de4bcd88ecfc328836d8a2ecb47c7f95f69))
- Update makecoverage rule in fobos ([`798f25d`](https://github.com/szaghi/FLAP/commit/798f25d5fd3992ef986382ab61b7875d15b7386b))
- Merge branch 'release/1.2.2' ([`8c347b5`](https://github.com/szaghi/FLAP/commit/8c347b5dfafa16def93b69161c6753390737d041))

## [v1.2.1](https://github.com/szaghi/FLAP/tree/v1.2.1) (2017-09-13)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.2.0...v1.2.1)
### Miscellaneous
- Merge tag 'v1.2.0' into develop

Add new vectorial methods, sanitize library, improve coverage

Add new vectorial methods:

+ distance_to_line
+ distance_to_plane
+ distance_vectorial_to_plane
+ is_collinear
+ is_concyclic
+ projection_onto_plane

Expose all TB functions thus they can be used as standalone procedures.

Sanitize the library: space names, code duplications, comments...

Highly improve code coverage by means of FoBiS doctests: each procedure
has its own doctest(s) that is automatically checked by the
*introspection* provided by FoBiS! No more need to handle separate test
files, each test is *attached* to its procedure directly into the
procedure comments. For sake of convenience, the tests have been also
*extracted* (automatically by FoBiS.py --keep-volatile-doctests) into
the `src/tests` directory in order to be easily compiled by means of the
provided makefile. ([`3081723`](https://github.com/szaghi/FLAP/commit/3081723b6ef1fedeb74ccce98b3cd474ef2db123))
- Update submodules ([`1ecfa72`](https://github.com/szaghi/FLAP/commit/1ecfa72a3c6e71ee9cec26e83243251ffeb96dc4))
- Update for the new PENF API ([`e450518`](https://github.com/szaghi/FLAP/commit/e45051874073fde539c34b7ef883ef8519740303))
- Merge branch 'master' into develop ([`d8d427b`](https://github.com/szaghi/FLAP/commit/d8d427b5b72605d2cb100d063a4e03fb76d93180))
- Add angle method and function

Add angle method and function: compute the angle between two vectors
using accurate formula based on both sin and cos functions. ([`e4d64db`](https://github.com/szaghi/FLAP/commit/e4d64db3cca4ba29fcd07bf757a25af4a5352f09))
- Merge branch 'release/1.2.1' ([`16a225a`](https://github.com/szaghi/FLAP/commit/16a225a1c40455a8540a240f70b8a77c0a64e1e0))

## [v1.2.0](https://github.com/szaghi/FLAP/tree/v1.2.0) (2017-06-21)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.1.0...v1.2.0)
### Miscellaneous
- Merge tag 'v1.1.0' into develop

Sanitize exploitation of R16P/R8P kinds

Sanitize exploitation of R16P/R8P kinds by means of PENF library: now
vector's components are defined as R_P thus they can be easily change
between R16P and R8P kinds precision.

Stable release, fully backward compatible. ([`3344432`](https://github.com/szaghi/FLAP/commit/3344432feb48b4eb44f0d693921addaa17ce738f))
- Add install script ([`af36ce1`](https://github.com/szaghi/FLAP/commit/af36ce1e00577cc30c21471fee6e9e8d9484150f))
- Merge branch 'master' into develop ([`ae6edf6`](https://github.com/szaghi/FLAP/commit/ae6edf6751d3567ec4f7438af1fe9e820edd8682))
- Update submodules2 ([`fd54cc9`](https://github.com/szaghi/FLAP/commit/fd54cc97142b6a94335f7705420c4810cea79321))
- Add distance to plane methods ([`7c0b7f6`](https://github.com/szaghi/FLAP/commit/7c0b7f6993319f2963573f98bd1b907e77756005))
- Sanitize and add a lot of doctests ([`ea7eddf`](https://github.com/szaghi/FLAP/commit/ea7eddfe6dbc84643d04d2246ad4cd4f8f23b5b8))
- Add all doctests, coverage at 98%, good ([`d976dd2`](https://github.com/szaghi/FLAP/commit/d976dd2ccf3d6d641eb1279645fa426c0b1c240f))
- Add some new methods ([`30505fe`](https://github.com/szaghi/FLAP/commit/30505fe609820b3c123365c77c6abdfcb0edebcd))
- Add standalone tests and makefile for them ([`efd0e70`](https://github.com/szaghi/FLAP/commit/efd0e7084531d2faccbba49b34769ba241c06aed))
- Merge branch 'feature/add-point-to-plane_line-distance-methods' into develop ([`f802ed2`](https://github.com/szaghi/FLAP/commit/f802ed2593f4c84f31a83c29358262a2bc2148d8))
- Merge branch 'release/1.2.0' ([`367702e`](https://github.com/szaghi/FLAP/commit/367702e80036d8d7852a181c01cd2944b0da2149))

## [v1.1.0](https://github.com/szaghi/FLAP/tree/v1.1.0) (2017-04-12)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.2...v1.1.0)
### Miscellaneous
- Merge tag 'v1.0.2' into develop

Complete coverage analysis and documentation. Stable release. ([`d46fa5f`](https://github.com/szaghi/FLAP/commit/d46fa5f8d9268b67adfb655e429df0d45b9235dc))
- Update travis config ([`2b0d471`](https://github.com/szaghi/FLAP/commit/2b0d471e138f46b97103ad47ee286b7fa98f27b3))
- Trim out dangerous recursive git clone/update ([`f1ef102`](https://github.com/szaghi/FLAP/commit/f1ef1024d7f6546d118983cecadd9d3ae2b4d53d))
- Merge branch 'master' into develop ([`56d33e6`](https://github.com/szaghi/FLAP/commit/56d33e6ac9a0ce45a1267b20e454185c17796f7f))
- Sanitize R16P exploitation ([`ba22c26`](https://github.com/szaghi/FLAP/commit/ba22c268ef1a73a0b5f12de26e945a357fcbc09d))
- Update travis deploy ([`76f586b`](https://github.com/szaghi/FLAP/commit/76f586b8cddc585b208cad44d0e45c5f29eb2aab))
- Merge branch 'release/1.1.0' ([`0ffe2cc`](https://github.com/szaghi/FLAP/commit/0ffe2ccdc50bd7a2e129058d8a40931f4fec641d))

## [v1.0.2](https://github.com/szaghi/FLAP/tree/v1.0.2) (2015-11-06)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.1...v1.0.2)
### Miscellaneous
- Merge tag 'v1.0.1' into develop

Improve coverage analysis (now close to 100% of library). Stable release. ([`792fe6a`](https://github.com/szaghi/FLAP/commit/792fe6a38660b5d9d12bf8b09221de14f49ccf34))
- Minor fixes ([`7a5f575`](https://github.com/szaghi/FLAP/commit/7a5f57532b20ff14019afd3e09e6578e30efe623))
- Merge branch 'release/1.0.2' ([`8bf2612`](https://github.com/szaghi/FLAP/commit/8bf26124c13baeaea7c9651248793de4e3802a7d))

## [v1.0.1](https://github.com/szaghi/FLAP/tree/v1.0.1) (2015-11-05)
[Full Changelog](https://github.com/szaghi/FLAP/compare/v1.0.0...v1.0.1)
### Miscellaneous
- Update README ([`03d0d42`](https://github.com/szaghi/FLAP/commit/03d0d42062064ed74e4fb223d67f83aa2bc5d93a))
- Add API doc ([`22726df`](https://github.com/szaghi/FLAP/commit/22726df6f955cc1a3babe42b663afd2f53c30820))
- Add kinds regression test

Add kinds regression test.

Why:

Test operators with all kinds supported.

This change addresses the need by:

Add kinds.f90 program test.

Side effects:

Nothing. ([`fad7fc4`](https://github.com/szaghi/FLAP/commit/fad7fc45b09e33936050f3a6f4ec4e4fddf1cdd5))
- Merge branch 'release/1.0.1' ([`f792c3b`](https://github.com/szaghi/FLAP/commit/f792c3bb15193971f3fec5e15cc510cabfdd4845))

## [v1.0.0](https://github.com/szaghi/FLAP/tree/v1.0.0) (2015-11-03)
### Miscellaneous
- Init versioning ([`020a237`](https://github.com/szaghi/FLAP/commit/020a237e6c1f325cf5825f01b54091b818f371d1))


