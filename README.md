Diagram Application
===================

Create various types of diagrams using [draw.io](https://www.draw.io/).

This is a simple application created using [AppWithinMinutes](http://extensions.xwiki.org/xwiki/bin/view/Extension/App+Within+Minutes+Application) and integrating [jgraph/draw.io](https://github.com/jgraph/draw.io/). It supports both editing and viewing diagrams. Each diagram is stored in a wiki page. It doesn't require any external services in order to work properly.

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

Troubleshooting
---------------

Diagrams created with other versions of the draw.io editor can sometimes be stored as a `<mxfile>` element. If the `<mxfile>` element is saved with `compressed="true"` then the content is compressed and only the draw.io editor can decompress it. Such diagrams require the updated editor shipped with this application in order to be edited properly. If you open a diagram and only see XML content or gibberish, verify whether the diagram uses the compression attribute and, if so, use the draw.io editor to decompress it.

When importing the XAR in XWiki, use **Replace Document**. This restores `Diagram.DiagramMacro` and ensures that the macros continue to work after the import.
