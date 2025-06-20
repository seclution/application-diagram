Diagram Application
===================

Create various types of diagrams using [draw.io](https://www.draw.io/).

This is a simple application created using [AppWithinMinutes](http://extensions.xwiki.org/xwiki/bin/view/Extension/App+Within+Minutes+Application) and integrating [jgraph/draw.io](https://github.com/jgraph/draw.io/). It supports both editing and viewing diagrams. Each diagram is stored in a wiki page. It doesn't require any external services in order to work properly.

## Development Notes

All updates to this application should be documented in this file to keep track
of integration work and upgrade steps. Always mention the draw.io version in use
and note any important changes or debugging improvements.

* Project Lead: [Oana-Lavinia Florean](https://www.xwiki.org/xwiki/bin/view/XWiki/OanaLaviniaFlorean)
* [Documentation & Download](https://extensions.xwiki.org/xwiki/bin/view/Extension/Diagram+Application)
* [Issue Tracker](https://jira.xwiki.org/browse/XADIAGRAM)
* Communication: [Mailing List](http://dev.xwiki.org/xwiki/bin/view/Community/MailingLists), [IRC](http://dev.xwiki.org/xwiki/bin/view/Community/IRC)
* [Development Practices](https://dev.xwiki.org)
* Minimal XWiki version supported: XWiki 14.10
* License: LGPL 2.1+ for the application code. **But** since the application code uses draw.io API that is licensed under GPLv3 the combination [is also **GPLv3**](http://www.gnu.org/licenses/gpl-faq.html#AllCompatibility). This means that if you want to distribute a package that bundles the Diagram Application and its draw.io dependency then that package must be licensed under GPLv3.
* Translations: N/A
* Sonar Dashboard: N/A
* Continuous Integration Status: [![Build Status](https://ci.xwiki.org/job/XWiki%20Contrib/job/application-diagram/job/master/badge/icon)](https://ci.xwiki.org/view/Contrib/job/XWiki%20Contrib/job/application-diagram/job/master/)

The `drawio_sources` directory stores a copy of the upstream draw.io source code.
These files are provided only as a reference when upgrading the embedded
draw.io WebJar and they are **not** used during the build of the Diagram
Application.

## draw.io-api

The `draw.io-api` library is built from the draw.io packaging repository and
contains server-side Java helpers (servlets, import tools, etc.). It is currently
not used by the Diagram Application but it may be handy for building custom
integrations.

## Updating to a newer draw.io version

This repository used to bundle an outdated `draw.io` WebJar (`6.5.7`).
The dependency was later switched to `24.5.5` and now targets `27.0.9` using the
sources under `drawio_sources`. When upgrading the application make sure to:

1. Replace the old WebJar dependency in `pom.xml` with a WebJar built from the provided sources.
2. Keep the current integration logic (editor initialization, macro code, storage format) so that diagrams
   created with older versions can still be opened and saved without changes.
3. Verify that existing diagrams render correctly with the new editor and that saving them doesn't break
   compatibility with earlier versions of the application.
4. Ensure that no additional external services are enabled in the new `draw.io` build to preserve the
   self-contained nature of this application.

To build a WebJar locally run the following commands inside `drawio_sources/drawio`:

```
mvn -Pwebjar clean package
mvn install:install-file -Dfile=target/draw.io-webjar-27.0.9.jar \
    -DgroupId=org.xwiki.contrib -DartifactId=draw.io -Dversion=27.0.9 -Dpackaging=jar
```

The second command installs the freshly built WebJar in your local Maven repository so
that the Diagram Application can depend on it during development.

These guidelines will help updating the code base while maintaining full backward compatibility with
existing XWiki installations.
