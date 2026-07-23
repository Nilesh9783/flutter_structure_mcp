import 'dart:io';
import 'package:yaml/yaml.dart';

class YamlService {
  Map<String, dynamic> loadYamlFile(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      return {};
    }
    try {
      final content = file.readAsStringSync();
      final doc = loadYaml(content);
      if (doc is YamlMap) {
        return _convertYamlMap(doc);
      }
    } catch (_) {}
    return {};
  }

  Map<String, dynamic> _convertYamlMap(YamlMap yamlMap) {
    final Map<String, dynamic> map = {};
    for (var key in yamlMap.keys) {
      final value = yamlMap[key];
      if (value is YamlMap) {
        map[key.toString()] = _convertYamlMap(value);
      } else if (value is YamlList) {
        map[key.toString()] = _convertYamlList(value);
      } else {
        map[key.toString()] = value;
      }
    }
    return map;
  }

  List<dynamic> _convertYamlList(YamlList yamlList) {
    final List<dynamic> list = [];
    for (var value in yamlList) {
      if (value is YamlMap) {
        list.add(_convertYamlMap(value));
      } else if (value is YamlList) {
        list.add(_convertYamlList(value));
      } else {
        list.add(value);
      }
    }
    return list;
  }
}
