// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/**
 * Some utilty methods for stagehand.
 */
library stagehand.utils;

const int _RUNE_SPACE = 32;

/**
 * A common `.gitignore` file for Dart projects.
 */
String gitIgnoreContents = '''
.DS_Store
build/
packages
pubspec.lock
''';

/**
 * Convert a directory name into a reasonably legal pub package name.
 */
String normalizeProjectName(String name) {
  name = name.replaceAll('-', '_');

  // Strip any extension (like .dart).
  if (name.contains('.')) {
    name = name.substring(0, name.indexOf('.'));
  }

  return name;
}

/**
 * Given a String [str] with mustache templates, and a [Map] of String key /
 * value pairs, substitute all instances of `{{key}}` for `value`. I.e.,
 *
 *     Foo {{projectName}} baz.
 *
 * and
 *
 *     {'projectName': 'bar'}
 *
 * becomes:
 *
 *     Foo bar baz.
 */
String substituteVars(String str, Map<String, String> vars) {
  vars.forEach((key, value) {
    String sub = '{{${key}}}';
    str = str.replaceAll(sub, value);
  });
  return str;
}

/**
 * Convert the given String into a String with newlines wrapped at an 80 column
 * boundary, with 2 leading spaces for each line.
 */
String convertToYamlMultiLine(String str) {
  return wrap(str, 78).map((line) => '  ${line}').join('\n');
}

/**
 * Break the given String into lines wrapped on a [col] boundary.
 */
List<String> wrap(String str, [int col = 80]) {
  List<String> lines = [];

  while (str.length > col) {
    int index = col;

    while (index > 0 && str.codeUnitAt(index) != _RUNE_SPACE) {
      index--;
    }

    if (index == 0) {
      index = str.indexOf(' ');

      if (index == -1) {
        lines.add(str);
        str = '';
      } else {
        lines.add(str.substring(0, index).trim());
        str = str.substring(index).trim();
      }
    } else {
      lines.add(str.substring(0, index).trim());
      str = str.substring(index).trim();
    }
  }

  if (str.length > 0) {
    lines.add(str);
  }

  return lines;
}
