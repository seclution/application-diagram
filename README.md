Diagram Application
===================

Create various types of diagrams using [draw.io](https://www.draw.io/).

This is a simple application created using [AppWithinMinutes](https://extensions.xwiki.org/xwiki/bin/view/Extension/App+Within+Minutes+Application) and integrating [jgraph/draw.io](https://github.com/jgraph/draw.io/). It supports both editing and viewing diagrams. Each diagram is stored in a wiki page. It doesn't require any external services in order to work properly.
See [docs/integration.md](docs/integration.md) for integration details.

## Development Notes

All updates to this application should be documented in this file to keep track
of integration work and upgrade steps. Always mention the draw.io version in use
and note any important changes or debugging improvements.

* Project Lead: [Oana-Lavinia Florean](https://www.xwiki.org/xwiki/bin/view/XWiki/OanaLaviniaFlorean)
* [Documentation & Download](https://extensions.xwiki.org/xwiki/bin/view/Extension/Diagram+Application)
* [Issue Tracker](https://jira.xwiki.org/browse/XADIAGRAM)
* Communication: [Mailing List](https://dev.xwiki.org/xwiki/bin/view/Community/MailingLists), [IRC](https://dev.xwiki.org/xwiki/bin/view/Community/IRC)
* [Development Practices](https://dev.xwiki.org)
* Minimal XWiki version supported: XWiki 14.10
* License: LGPL 2.1+ for the application code. **But** since the application code uses draw.io API that is licensed under GPLv3 the combination [is also **GPLv3**](http://www.gnu.org/licenses/gpl-faq.html#AllCompatibility). This means that if you want to distribute a package that bundles the Diagram Application and its draw.io dependency then that package must be licensed under GPLv3.
* Translations: English strings provided; partial French translation available
* Sonar Dashboard: N/A
* Continuous Integration Status: [![Build Status](https://ci.xwiki.org/job/XWiki%20Contrib/job/application-diagram/job/master/badge/icon)](https://ci.xwiki.org/view/Contrib/job/XWiki%20Contrib/job/application-diagram/job/master/)
* Build environment updated to **Java 17**
* After cloning run `git submodule update --init` to populate `drawio_sources/drawio`

The `drawio_sources` directory stores a copy of the upstream draw.io source
code. These files are provided **only** as a reference when upgrading the
embedded draw.io WebJar and they are *not* used during the build of the Diagram
Application. Contributors should not attempt to run Maven inside this folder.
Instead, clone the dedicated [seclution/draw.io](https://github.com/seclution/draw.io)
repository when building a new WebJar.
When upgrading, do not commit the libraries located under `src/main/webapp/WEB-INF/lib`. They are produced by the draw.io build and should remain outside version control.
Use `scripts/update-drawio-sources.sh` to refresh the sources when upgrading.
You can pass a second argument to specify the tag or commit to check out.
The files under `drawio_sources/drawio` are kept as a **Git submodule** pointing
to the official [`jgraph/drawio`](https://github.com/jgraph/drawio) repository.
`scripts/update-drawio-sources.sh` updates this submodule automatically and
removes the JARs. You can also run `git submodule update --remote` to fetch the
latest upstream changes. A `Refresh draw.io sources` workflow is provided to run
the script and push the updates.
The current reference snapshot corresponds to tag `v27.1.6`
(commit `7114e2037b400fabce0824bfc8f20703eeda5fd4`). Update this note whenever
the sources are refreshed.


## draw.io-api

The `draw.io-api` library is built from the draw.io packaging repository and
contains server-side Java helpers (servlets, import tools, etc.). It is currently
not used by the Diagram Application but it may be handy for building custom
integrations.

## Updating to a newer draw.io version

This repository used to bundle an outdated `draw.io` WebJar (`6.5.7`).
The dependency was later switched to `24.5.5` and now targets `27.1.6`.
The WebJar should be built using the
[`seclution/draw.io`](https://github.com/seclution/draw.io)
repository which contains the updated packaging. When upgrading the application
make sure to:

1. Replace the old WebJar dependency in `pom.xml` with a WebJar built from
   `seclution/draw.io`.
2. Keep the current integration logic (editor initialization, macro code, storage format) so that diagrams
   created with older versions can still be opened and saved without changes.
3. Verify that existing diagrams render correctly with the new editor and that saving them doesn't break
   compatibility with earlier versions of the application.
4. Ensure that no additional external services are enabled in the new `draw.io` build to preserve the
   self-contained nature of this application.


To build a WebJar locally perform the following steps:

1. Clone `https://github.com/seclution/draw.io`.
2. Run `mvn -pl draw.io-webjar -am clean package` inside the cloned repository.
3. Optionally run `mvn -pl draw.io-webjar -am install` to install the jar in your
   local Maven cache.
4. Run `scripts/update-webjar-version.sh /path/to/draw.io-webjar/target/*.jar`
   to update the `drawio.version` property in `pom.xml`.
   This script relies on `xmlstarlet` being available in your `PATH`.

The forked repository keeps the draw.io sources up to date and can be used as
a starting point for additional build customization.

The `draw.io-api` module is not required for this application unless you need
server-side features.

These guidelines will help updating the code base while maintaining full backward compatibility with
existing XWiki installations.

## Validating Sample Diagrams

Sample diagrams created with older draw.io versions are stored under the `samples/` directory. A small script is provided to parse these diagrams and ensure they can be loaded by the current viewer/editor.

Run the following command from the repository root:

```bash
python3 scripts/check_samples.py
```

The script exits with a non-zero status if any of the sample diagrams fail to load.


## Building the Diagram Application

The project is built with **Java 17** and **Maven 3.8+**. The workflow used by
CI relies on these versions. To produce a XAR package locally you need to first build
the draw.io WebJar from the [`seclution/draw.io`](https://github.com/seclution/draw.io)
packaging repository as described in the *Updating to a newer draw.io version*
section above.

1. Clone the repository and run `mvn -pl draw.io-webjar -am clean package`.
2. Optionally install the generated jar with `mvn -pl draw.io-webjar -am install` so
   that it can be resolved by this project.
3. Run `scripts/update-webjar-version.sh /path/to/draw.io-webjar/target/*.jar`
   to update the `drawio.version` property with the WebJar version you just built.
   Ensure `xmlstarlet` is installed before executing this script.
4. From the root of this repository run `mvn package` to generate the XAR under
   `target/`.

The upstream draw.io sources no longer include the `js/grapheditor` directory.
The packaging repository already bundles the resources required by this
application.

For detailed instructions on building the WebJar see the lines 43&ndash;72 of
this README.

## Release Process

The GitHub release workflow automatically builds the draw.io WebJar and
publishes the Diagram Application as a XAR when a tag or release is
created. Ensure the `pom.xml` contains the correct draw.io version before
tagging a release.

1. Update the `drawio.version` property in `pom.xml` using
   `scripts/update-webjar-version.sh` after building the WebJar from the
   [`seclution/draw.io`](https://github.com/seclution/draw.io) packaging
   repository.
2. Commit all changes and create a tag for the release, e.g.
   `git tag 1.2.3 && git push --tags`.
3. GitHub Actions will build the WebJar with the same version, install it
   locally, build the XAR and attach it to the GitHub Release.
4. The release workflow includes a `workflow_dispatch` trigger so it can be executed manually from the **Actions** tab using *Run workflow*. The
   workflow reads the draw.io version from `pom.xml` to build the WebJar
   so make sure this file is up to date before running it.


## GitHub Actions

- **Scheduled draw.io update** runs every Sunday. It checks the latest draw.io release tag, updates the sources and version if needed, and triggers a build.
- **Commit checks** execute unit tests and sample validation on pushes and pull requests to provide quick feedback.
