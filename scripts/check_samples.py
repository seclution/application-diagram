#!/usr/bin/env python3
import sys
import pathlib
import xml.etree.ElementTree as ET


def check_file(path: pathlib.Path):
    try:
        tree = ET.parse(path)
        root = tree.getroot()
        if root.tag != 'mxfile':
            return f"Root element is '{root.tag}', expected 'mxfile'"
        diagrams = root.findall('diagram')
        if not diagrams:
            return 'No <diagram> elements found'
        for d in diagrams:
            # Ensure the inner XML is well formed for both standard and lxml implementations
            ET.fromstring(ET.tostring(d))
    except Exception as e:
        return str(e)
    return None

def main():
    directory = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else pathlib.Path('samples')
    if not directory.is_dir():
        print(f"Directory not found: {directory}")
        sys.exit(1)
    errors = []
    for file in directory.glob('*.drawio'):
        error = check_file(file)
        if error:
            errors.append((file, error))
            print(f"FAIL: {file} -> {error}")
        else:
            print(f"OK: {file}")
    if errors:
        print(f"{len(errors)} diagram(s) failed")
        sys.exit(1)
    print('All sample diagrams loaded successfully.')

if __name__ == '__main__':
    main()
