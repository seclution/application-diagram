# Integration Notes

This document explains how the Diagram Application integrates draw.io with XWiki.

## Macros

The diagram content is displayed using the `Diagram.DiagramMacro` page which defines a wiki macro. The Velocity code inside this macro loads the diagram from the referenced page and shows an edit button when allowed. If no diagram exists, the macro proposes creating one from a template.

## WebJar Paths

Both the edit and view sheets reference JavaScript resources packaged as WebJars. The base paths are computed with the `webjars` service, e.g.

```javascript
var diagramEditorBasePath = "$services.webjars.url('org.xwiki.contrib:draw.io', '')";
var mxBasePath = "$services.webjars.url('org.xwiki.contrib:mxgraph-client', '')";
```

These paths are used to load the draw.io scripts and configure RequireJS modules. The viewer sheet uses a similar `diagramViewerBasePath` variable to locate the viewer files. By relying on WebJars, the application serves the draw.io code directly from XWiki without external dependencies.


