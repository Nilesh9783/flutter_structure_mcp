import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('scratch/tools_list.json');
  if (!file.existsSync()) {
    print('Error: tools_list.json does not exist');
    return;
  }
  
  final rawJson = file.readAsStringSync();
  final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
  final result = decoded['result'] as Map<String, dynamic>;
  final tools = result['tools'] as List<dynamic>;
  
  for (final tool in tools) {
    final name = tool['name'];
    if (name == 'draft_email' || name == 'confirm_send') {
      print('=== TOOL: $name ===');
      print(JsonEncoder.withIndent('  ').convert(tool));
    }
  }
}
