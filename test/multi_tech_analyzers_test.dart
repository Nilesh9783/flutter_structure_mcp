import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:flutter_architect_mcp/technologies/node/node_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/vue/vue_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/laravel/laravel_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/python/python_analyzer.dart';
import 'package:flutter_architect_mcp/technologies/analyzer_hub.dart';

void main() {
  group('Multi-Technology Scanners Tests', () {
    late Directory tempDir;

    setUpAll(() {
      tempDir = Directory(Directory.systemTemp.createTempSync('mcp_multi_tech_test').resolveSymbolicLinksSync());
    });

    tearDownAll(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('NodeAnalyzer should detect secrets, eval, exec, and sync fs operations', () async {
      final nodeProj = Directory(p.join(tempDir.path, 'node_project'))..createSync();
      File(p.join(nodeProj.path, 'package.json')).writeAsStringSync('''
      {
        "name": "mock-node-app",
        "version": "1.0.0",
        "dependencies": {
          "express": "4.16.0",
          "lodash": "4.17.21"
        }
      }
      ''');

      File(p.join(nodeProj.path, 'server.js')).writeAsStringSync('''
      const express = require('express');
      const fs = require('fs');
      const cp = require('child_process');
      const app = express();

      const apiKey = "AKIA1234567890ABCDEF"; // Secret

      app.get('/run', (req, res) => {
        const cmd = req.query.cmd;
        cp.exec(cmd); // Command Injection

        const code = req.query.code;
        eval(code); // Eval injection
        
        const data = fs.readFileSync('config.json'); // Sync FS
        res.send(data);
      });
      ''');

      final analyzer = NodeAnalyzer();
      expect(analyzer.canAnalyze(nodeProj.path), isTrue);

      final findings = await analyzer.analyze(nodeProj.path);
      
      // We expect SEC-001 (Secret), SEC-NODE-001 (Eval), SEC-NODE-002 (Exec), PERF-NODE-001 (Sync FS), DEP-001 (Vulnerable deps)
      final ids = findings.map((f) => f.id).toList();
      expect(ids, contains('SEC-001'));
      expect(ids, contains('SEC-NODE-001'));
      expect(ids, contains('SEC-NODE-002'));
      expect(ids, contains('PERF-NODE-001'));
      expect(ids, contains('DEP-001'));

      final metadata = await analyzer.getMetadata(nodeProj.path);
      expect(metadata.projectName, equals('mock-node-app'));
      expect(metadata.detectedRouter, equals('Express'));
    });

    test('VueAnalyzer should detect v-html, unscoped styles, missing keys, and secrets', () async {
      final vueProj = Directory(p.join(tempDir.path, 'vue_project'))..createSync();
      File(p.join(vueProj.path, 'package.json')).writeAsStringSync('''
      {
        "name": "mock-vue-app",
        "dependencies": {
          "vue": "^3.2.0",
          "pinia": "^2.0.0"
        }
      }
      ''');

      File(p.join(vueProj.path, 'Component.vue')).writeAsStringSync('''
      <template>
        <div>
          <div v-html="untrustedContent"></div> <!-- XSS -->
          <div v-for="item in items"> <!-- missing key -->
            {{ item }}
          </div>
        </div>
      </template>

      <script setup>
      const secretToken = "xoxb-1234567890-abcdef"; // Slack token secret
      const untrustedContent = "<script>alert(1)</script>";
      </script>

      <style>
      /* global unscoped style */
      h1 { color: red; }
      </style>
      ''');

      final analyzer = VueAnalyzer();
      expect(analyzer.canAnalyze(vueProj.path), isTrue);

      final findings = await analyzer.analyze(vueProj.path);
      final ids = findings.map((f) => f.id).toList();

      expect(ids, contains('SEC-001'));
      expect(ids, contains('SEC-VUE-001')); // v-html
      expect(ids, contains('CQ-VUE-002')); // unscoped style
      expect(ids, contains('CQ-VUE-003')); // v-for no key

      final metadata = await analyzer.getMetadata(vueProj.path);
      expect(metadata.detectedStateManagement, equals('Pinia'));
    });

    test('LaravelAnalyzer should detect APP_DEBUG, SQL Injection raw queries, empty guarded, and Blade queries', () async {
      final laravelProj = Directory(p.join(tempDir.path, 'laravel_project'))..createSync();
      File(p.join(laravelProj.path, 'artisan')).writeAsStringSync('');
      File(p.join(laravelProj.path, '.env')).writeAsStringSync('''
      APP_NAME=Laravel
      APP_DEBUG=true
      APP_KEY=
      ''');

      final controllersDir = Directory(p.join(laravelProj.path, 'app/Http/Controllers'))..createSync(recursive: true);
      File(p.join(controllersDir.path, 'UserController.php')).writeAsStringSync(r'''
      <?php
      namespace App\Http\Controllers;
      use Illuminate\Support\Facades\DB;

      class UserController extends Controller {
          public function show($id) {
              // SQL injection risk
              $user = DB::raw("SELECT * FROM users WHERE id = " . $id);
              return view('user.profile', ['user' => $user]);
          }
      }
      ''');

      final modelsDir = Directory(p.join(laravelProj.path, 'app/Models'))..createSync(recursive: true);
      File(p.join(modelsDir.path, 'User.php')).writeAsStringSync(r'''
      <?php
      namespace App\Models;
      use Illuminate\Database\Eloquent\Model;

      class User extends Model {
          protected $guarded = []; // Mass assignment risk
      }
      ''');

      final viewsDir = Directory(p.join(laravelProj.path, 'resources/views'))..createSync(recursive: true);
      File(p.join(viewsDir.path, 'profile.blade.php')).writeAsStringSync(r'''
      <div>
          <h1>User Profile</h1>
          @php
              // DB query in view
              $stats = DB::select("select * from user_stats");
          @endphp
      </div>
      ''');

      final analyzer = LaravelAnalyzer();
      expect(analyzer.canAnalyze(laravelProj.path), isTrue);

      final findings = await analyzer.analyze(laravelProj.path);
      final ids = findings.map((f) => f.id).toList();

      expect(ids, contains('SEC-LAR-001')); // APP_DEBUG
      expect(ids, contains('SEC-LAR-002')); // APP_KEY empty
      expect(ids, contains('SEC-LAR-003')); // SQL injection DB::raw
      expect(ids, contains('SEC-LAR-004')); // Empty guarded model
      expect(ids, contains('ARC-LAR-001')); // DB query inside Blade view

      final metadata = await analyzer.getMetadata(laravelProj.path);
      expect(metadata.projectName, equals('laravel_project'));
    });

    test('PythonAnalyzer should detect eval, unsafe subprocess shell, insecure pickle deserialization, and debug mode', () async {
      final pythonProj = Directory(p.join(tempDir.path, 'python_project'))..createSync();
      File(p.join(pythonProj.path, 'requirements.txt')).writeAsStringSync('''
      requests==2.25.0
      Flask==1.1.0
      ''');

      File(p.join(pythonProj.path, 'app.py')).writeAsStringSync('''
      import os
      import subprocess
      import pickle
      from flask import Flask, request

      app = Flask(__name__)
      secret_key = "super_api_secret_key_12345" # Secret

      @app.route('/run')
      def run():
          cmd = request.args.get('cmd')
          os.system(cmd) # Command injection via os.system
          
          # Subprocess shell command injection
          subprocess.run(cmd, shell=True)

          # Eval safety
          eval(request.args.get('expr'))

          # Pickle safety
          pickle.loads(request.args.get('data').encode())

          return "OK"

      if __name__ == '__main__':
          app.run(debug=True) # debug mode active
      ''');

      final analyzer = PythonAnalyzer();
      expect(analyzer.canAnalyze(pythonProj.path), isTrue);

      final findings = await analyzer.analyze(pythonProj.path);
      final ids = findings.map((f) => f.id).toList();

      expect(ids, contains('SEC-001')); // Secret Key
      expect(ids, contains('SEC-PY-001')); // eval
      expect(ids, contains('SEC-PY-002')); // os.system / subprocess.run shell=True
      expect(ids, contains('SEC-PY-003')); // pickle.loads
      expect(ids, contains('SEC-PY-004')); // debug=True
      expect(ids, contains('DEP-001')); // Outdated requests/flask

      final metadata = await analyzer.getMetadata(pythonProj.path);
      expect(metadata.detectedArchitecture, contains('Flask'));
    });

    test('AnalyzerHub should detect correct technology automatically', () {
      final hub = AnalyzerHub();

      final nodeProj = Directory(p.join(tempDir.path, 'node_project'));
      final vueProj = Directory(p.join(tempDir.path, 'vue_project'));
      final laravelProj = Directory(p.join(tempDir.path, 'laravel_project'));
      final pythonProj = Directory(p.join(tempDir.path, 'python_project'));

      expect(hub.detectTechnology(nodeProj.path)?.technologyId, equals('node'));
      expect(hub.detectTechnology(vueProj.path)?.technologyId, equals('vue'));
      expect(hub.detectTechnology(laravelProj.path)?.technologyId, equals('laravel'));
      expect(hub.detectTechnology(pythonProj.path)?.technologyId, equals('python'));
    });
  });
}
