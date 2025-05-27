# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!-- insertion marker -->
## [v0.5.0](https://github.com/smswithoutborders/assembler/releases/tag/v0.5.0) - 2025-05-27

<small>[Compare with v0.4.1](https://github.com/smswithoutborders/assembler/compare/v0.4.1...v0.5.0)</small>

### Features

- Add new volumes for adapters in docker-compose ([b5cc6ef](https://github.com/smswithoutborders/assembler/commit/b5cc6ef6324153e1b8af9996991ffb124757d5e6) by Promise Fru).
- Update volumes and environment variables for adapters in docker-compose ([cae7289](https://github.com/smswithoutborders/assembler/commit/cae7289cd955c31398d63eecaa59e874f4d09a32) by Promise Fru).

## [v0.4.1](https://github.com/smswithoutborders/assembler/releases/tag/v0.4.1) - 2025-03-13

<small>[Compare with v0.4.0](https://github.com/smswithoutborders/assembler/compare/v0.4.0...v0.4.1)</small>

### Features

- Adds MySQL database connection to bridge service. ([34de936](https://github.com/smswithoutborders/assembler/commit/34de936ef9d9973c9b9808c2b6beb04aedbb93bf) by Promise Fru).

## [v0.4.0](https://github.com/smswithoutborders/assembler/releases/tag/v0.4.0) - 2025-03-11

<small>[Compare with v0.3.0](https://github.com/smswithoutborders/assembler/compare/v0.3.0...v0.4.0)</small>

### Features

- Add SMTP allowed email addresses configuration. ([9f47435](https://github.com/smswithoutborders/assembler/commit/9f4743502d94fb47fc3fec69907cab5df8f2547d) by Promise Fru).
- Add config to disable bridge payloads over HTTP. ([994af89](https://github.com/smswithoutborders/assembler/commit/994af89abe9f29a264c000f01f193a513e06e4dc) by Promise Fru).
- Configure aggregator to use publisher service. ([b453857](https://github.com/smswithoutborders/assembler/commit/b453857cd1a3674d0eec45d5767db1bfdef9b093) by Promise Fru).
- Expose publisher service via HTTP. ([d49d023](https://github.com/smswithoutborders/assembler/commit/d49d023895e8a67a62c78c1b52de2de14b72c5dd) by Promise Fru).
- Add mock delivery SMS support ([65b9938](https://github.com/smswithoutborders/assembler/commit/65b993848759cbf36223d4e21cdabc7a3fd39cf7) by Promise Fru).
- Add rebuild flag to force image rebuilds. ([1ac2e32](https://github.com/smswithoutborders/assembler/commit/1ac2e3210146c011628b341517fbc9b657b9eb83) by Promise Fru).
- Add static keystore volume. ([74fac3c](https://github.com/smswithoutborders/assembler/commit/74fac3c15482606264172f390fb51d69d99bfe3f) by Promise Fru).
- Add Twilio integration to bridge_server. ([0800cc4](https://github.com/smswithoutborders/assembler/commit/0800cc48ed019f19e6158185c1e0e67d2c162709) by Promise Fru).
- Add IMAP support to bridge server. ([c7dd7d6](https://github.com/smswithoutborders/assembler/commit/c7dd7d6def0794e42fafa42ce776578fefbeb47f) by Promise Fru).

### Bug Fixes

- Use HTTP for publisher connection. ([619e093](https://github.com/smswithoutborders/assembler/commit/619e0938457980d3772870f2c0b0b3050b3d9fc4) by Promise Fru).
- export all service paths before using rebuild. ([4e8eeb0](https://github.com/smswithoutborders/assembler/commit/4e8eeb0cdeb5f7a6d345d580c13acf306ac4732f) by Promise Fru).

## [v0.3.0](https://github.com/smswithoutborders/assembler/releases/tag/v0.3.0) - 2024-12-09

<small>[Compare with v0.2.0](https://github.com/smswithoutborders/assembler/compare/v0.2.0...v0.3.0)</small>

### Features

- add Telemetry Aggregator service. ([dd64475](https://github.com/smswithoutborders/assembler/commit/dd6447581375ecbad790a5efbd777efd8266de6e) by Promise Fru).

## [v0.2.0](https://github.com/smswithoutborders/assembler/releases/tag/v0.2.0) - 2024-12-01

<small>[Compare with v0.1.0](https://github.com/smswithoutborders/assembler/compare/v0.1.0...v0.2.0)</small>

### Features

- remove sync socket functionality. ([6cd8f21](https://github.com/smswithoutborders/assembler/commit/6cd8f211e38c2960113f582fe2b5ff1a4c7b015e) by Promise Fru).

## [v0.1.0](https://github.com/smswithoutborders/assembler/releases/tag/v0.1.0) - 2024-11-13

<small>[Compare with v0.0.1](https://github.com/smswithoutborders/assembler/compare/v0.0.1...v0.1.0)</small>

### Features

- Integrate GlitchTip for error tracking. ([1414af1](https://github.com/smswithoutborders/assembler/commit/1414af15426ce5ddf3d7b3c464e8d58960c07ee4) by Promise Fru).
- add Bridge Server component. ([eff599e](https://github.com/smswithoutborders/assembler/commit/eff599ed9c339f4323f470313c2caa91c52727d5) by Promise Fru).

### Bug Fixes

- the assembler script to always pull from the 'main' branch and checkout the 'main' branch when `NO_VERSION_CHECK` is true. ([fab2af4](https://github.com/smswithoutborders/assembler/commit/fab2af4bba28de4d6dc638e10d083fef9159edb6) by Promise Fru).

## [v0.0.1](https://github.com/smswithoutborders/assembler/releases/tag/v0.0.1) - 2024-10-17

<small>[Compare with v0.0.0](https://github.com/smswithoutborders/assembler/compare/v0.0.0...v0.0.1)</small>

### Features

- Add option to skip version check. ([a5139a5](https://github.com/smswithoutborders/assembler/commit/a5139a5c1bfcb84484df1372ec476f331e5b032f) by Promise Fru).
- Introduce install, uninstall, and update commands. ([fed1a4c](https://github.com/smswithoutborders/assembler/commit/fed1a4cb32ad71c92acdc303b6c66814b7486c92) by Promise Fru).

## [v0.0.0](https://github.com/smswithoutborders/assembler/releases/tag/v0.0.0) - 2024-08-23

<small>[Compare with first commit](https://github.com/smswithoutborders/assembler/compare/1a5def3631992e34b86de43524beb9d6963ff3e1...v0.0.0)</small>

### Features

- Introduce automated database backups ([3352c99](https://github.com/smswithoutborders/assembler/commit/3352c99f8ff2142a066f67e2fe53e1af3d66e58c) by Promise Fru).
- Configure Nginx for dynamic configuration ([ccb1d81](https://github.com/smswithoutborders/assembler/commit/ccb1d81c1b6173061fc4ab9b270ba26ef687a733) by Promise Fru).
- Removed explicit worker process configuration ([416258b](https://github.com/smswithoutborders/assembler/commit/416258bf1800c8cd6e6c4ce0425e0a2981f6f3a5) by Promise Fru).
- Expose additional ports in proxy ([d5a3a25](https://github.com/smswithoutborders/assembler/commit/d5a3a2530bf3f49227098589fa195a4f0d34c6b4) by Promise Fru).
- Expose additional container ports ([824212f](https://github.com/smswithoutborders/assembler/commit/824212fdedb2d240a446d72ab7b6e02fb0493e5c) by Promise Fru).
- Enhance Nginx security configuration ([d6c0145](https://github.com/smswithoutborders/assembler/commit/d6c01450a90f6ce3ce29056db874f77875e034ba) by Promise Fru).
- Enable quieter deployment and removal scripts ([5ff0721](https://github.com/smswithoutborders/assembler/commit/5ff07211bcb527c5531308cf8c86407fb0cd3473) by Promise Fru).
- Migrate to custom Nginx for streamlined proxying ([37963bd](https://github.com/smswithoutborders/assembler/commit/37963bd4f4f2d9a93f89493fb4226e19e0d0f45c) by Promise Fru).
- Expose service ports in docker-compose ([061d5c1](https://github.com/smswithoutborders/assembler/commit/061d5c1aef8ed7602eb5226e1b35f6057db4f87f) by Promise Fru).
- Add installation script and improve project structure ([c48fd89](https://github.com/smswithoutborders/assembler/commit/c48fd89290ea14dc07b7f8f167961592a75fcd8e) by Promise Fru).
- Enable project-specific deployment and teardown ([1360382](https://github.com/smswithoutborders/assembler/commit/13603824abc698c42a9971b010b1ac60149fd5f6) by Promise Fru).
- Enhance certificate copying script with progress reporting ([0eb4e16](https://github.com/smswithoutborders/assembler/commit/0eb4e1649501c8eb8bc898666de71737a644b88a) by Promise Fru).
- Add certs and drop commands to assembler ([d6eb4f3](https://github.com/smswithoutborders/assembler/commit/d6eb4f389569fe06c0bc5eca60ebde3cea4f1f41) by Promise Fru).
- Isolate Nginx Proxy Manager database ([b575c3f](https://github.com/smswithoutborders/assembler/commit/b575c3f53023b18a315b1d910f9cb2e0cd52d9ca) by Promise Fru).
- Improve environment variable loading ([0d66765](https://github.com/smswithoutborders/assembler/commit/0d66765c6e4ae9945393efdc91fb47a66e26156b) by Promise Fru).
- Introduce environment variable configuration ([e64332d](https://github.com/smswithoutborders/assembler/commit/e64332d03af377510050a5e7e4df2fc5f7181065) by Promise Fru).
- Introduce deployment automation script and structure ([1a5def3](https://github.com/smswithoutborders/assembler/commit/1a5def3631992e34b86de43524beb9d6963ff3e1) by Promise Fru).

### Code Refactoring

- update config ([fcfb3a5](https://github.com/smswithoutborders/assembler/commit/fcfb3a541eaa631e579f106df1c8e3d818c17e0e) by Promise Fru).
- Enhance proxy documentation and configuration ([32897e7](https://github.com/smswithoutborders/assembler/commit/32897e77f605848dd28042f99363d3dbd1045d3e) by Promise Fru).
- refine Nginx configuration ([473e1cb](https://github.com/smswithoutborders/assembler/commit/473e1cb88a97006fb8a2310109605139372991b9) by Promise Fru).
- Optimize Docker Compose output during deployment ([bf75f92](https://github.com/smswithoutborders/assembler/commit/bf75f9266c0a534a4477d723606b11d52d4bf32f) by Promise Fru).

