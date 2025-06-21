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
