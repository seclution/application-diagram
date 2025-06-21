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


# Diagram Editor Integration

This document explains how `DiagramEditSheet.xml` embeds the draw.io editor, stores diagrams inside wiki pages and disables external services for offline usage.

## Editor initialization

`DiagramEditSheet.xml` defines a JavaScript extension that configures RequireJS and loads the draw.io modules. The editor paths are computed from the embedded WebJars:

```
var mxGraphEditorBasePath = "$services.webjars.url('org.xwiki.contrib:mxgraph-editor', '')";
var diagramEditorBasePath = "$services.webjars.url('org.xwiki.contrib:draw.io', '')";
```

A custom `diagramEditor` module creates an `EditorUi` instance and loads the diagram file from the current page using `diagramStore.createFile`.

## Storing diagrams

The `diagramStore` module (defined in the same file) reads the diagram XML from a hidden input field and updates it whenever the graph model changes. Only a single diagram is stored per page, so `updateFileData()` simply serializes the current `graphXml` back into the input element.

## Disabling external services

To keep the application self‑contained, URL parameters and global variables disable online integrations:

```
var urlParams = {
  'splash': '0',
  'pages': '0',
  'gh': '0',   // GitHub
  'db': '0',   // Dropbox
  'gapi': '0', // Google Drive
  'analytics': '0',
  'od': '0'    // OneDrive
};
var DriveFile = DropboxFile = GitHubFile = OneDriveFile = false;
```

These settings ensure that the editor does not attempt to contact external APIs.

## Source reference

See [`src/main/resources/Diagram/DiagramEditSheet.xml`](../src/main/resources/Diagram/DiagramEditSheet.xml) for the full Velocity and JavaScript code used to integrate draw.io.
