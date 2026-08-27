class PerfPdfGenerator {
  static String generate(Map<String, dynamic> session) {
    final projectName = session['projectName'] ?? 'Unknown Flutter App';
    final startTimeVal = session['startTime'] as int;
    final startTimeStr = DateTime.fromMillisecondsSinceEpoch(startTimeVal).toLocal().toString().split('.')[0];
    final endTimeStr = DateTime.now().toLocal().toString().split('.')[0];
    
    final durationMs = DateTime.now().millisecondsSinceEpoch - startTimeVal;
    final durationSecStr = (durationMs / 1000).toStringAsFixed(1) + 's';

    final List<dynamic> apiCalls = session['apiCalls'] ?? [];
    final List<dynamic> memoryHistory = session['memoryHistory'] ?? [];
    final List<dynamic> screenHistory = session['screenHistory'] ?? [];
    final double peakRam = session['peakRam'] ?? 0.0;

    // Calculate latency metrics
    int avgLatency = 0;
    int slowCount = 0;
    if (apiCalls.isNotEmpty) {
      final sum = apiCalls.fold<int>(0, (acc, call) => acc + (call['latency'] as int));
      avgLatency = (sum / apiCalls.length).round();
      slowCount = apiCalls.where((c) => (c['latency'] as int) > 200).length;
    }

    // Calculate score
    int perfScore = 100;
    // Deduct 5 points per slow API call (> 200ms)
    perfScore -= slowCount * 5;
    // Deduct 15 points if Peak RAM exceeds 150MB
    if (peakRam > 150.0) perfScore -= 15;
    // Deduct 10 points if RAM grows consistently
    bool ramGrowth = false;
    if (memoryHistory.length >= 3) {
      final double first = memoryHistory.first['ram'] as double;
      final double last = memoryHistory.last['ram'] as double;
      if (last > first + 10.0) {
        ramGrowth = true;
        perfScore -= 10;
      }
    }
    if (perfScore < 0) perfScore = 0;

    // Build API rows HTML
    final apiRowsBuffer = StringBuffer();
    if (apiCalls.isEmpty) {
      apiRowsBuffer.write('<tr><td colspan="5" class="text-center">No HTTP requests logged during this session.</td></tr>');
    } else {
      for (final call in apiCalls) {
        final String method = call['method'] ?? 'GET';
        final String url = call['url'] ?? '';
        final int status = call['status'] ?? 200;
        final int latency = call['latency'] ?? 0;
        final timeStr = DateTime.fromMillisecondsSinceEpoch(call['timestamp']).toLocal().toString().split(' ')[1].split('.')[0];
        
        final statusClass = status < 400 ? 'status-green' : 'status-red';
        final latencyClass = latency > 200 ? 'text-red font-bold' : '';

        apiRowsBuffer.write('''
          <tr>
            <td><code>$method</code></td>
            <td class="font-mono" style="word-break: break-all;">${_escape(url)}</td>
            <td><span class="status-badge $statusClass">$status</span></td>
            <td class="$latencyClass">$latency ms</td>
            <td>$timeStr</td>
          </tr>
        ''');
      }
    }

    // Build Screen Lifecycles list HTML
    final screenTimelineBuffer = StringBuffer();
    if (screenHistory.isEmpty) {
      screenTimelineBuffer.write('<p class="text-muted">No route navigation events captured.</p>');
    } else {
      for (int i = 0; i < screenHistory.length; i++) {
        final s = screenHistory[i];
        final String screenName = s['screenName'] ?? 'Unknown';
        final int sTime = s['timestamp'];
        final sTimeStr = DateTime.fromMillisecondsSinceEpoch(sTime).toLocal().toString().split(' ')[1].split('.')[0];
        
        // Find APIs called while this screen was active
        final int nextTime = (i + 1 < screenHistory.length) ? screenHistory[i + 1]['timestamp'] : DateTime.now().millisecondsSinceEpoch;
        final screenApis = apiCalls.where((c) => c['timestamp'] >= sTime && c['timestamp'] < nextTime).toList();

        final apisListBuffer = StringBuffer();
        if (screenApis.isEmpty) {
          apisListBuffer.write('<p class="text-muted" style="font-size: 0.8rem; margin-top: 4px;">No API requests recorded while active.</p>');
        } else {
          apisListBuffer.write('<table style="margin-top: 8px; width:100%;">');
          apisListBuffer.write('<thead><tr><th>Method</th><th>Endpoint</th><th>Latency</th></tr></thead><tbody>');
          for (final c in screenApis) {
            final String m = c['method'] ?? 'GET';
            final String u = c['url'] ?? '';
            final int lat = c['latency'] ?? 0;
            final cleanUrl = u.split('?')[0];
            apisListBuffer.write('<tr><td><code>$m</code></td><td class="font-mono">${_escape(cleanUrl)}</td><td><strong>$lat ms</strong></td></tr>');
          }
          apisListBuffer.write('</tbody></table>');
        }

        screenTimelineBuffer.write('''
          <div class="screen-item">
            <div class="screen-title-row">
              <span class="screen-title">$screenName</span>
              <span class="text-muted font-mono">$sTimeStr</span>
            </div>
            <div class="screen-body">
              <strong>Initial/Triggered APIs:</strong>
              $apisListBuffer
            </div>
          </div>
        ''');
      }
    }

    // Build Memory utilization logs
    final memoryRowsBuffer = StringBuffer();
    if (memoryHistory.isEmpty) {
      memoryRowsBuffer.write('<tr><td colspan="3" class="text-center">No RAM utilization points captured.</td></tr>');
    } else {
      for (final m in memoryHistory) {
        final double ram = m['ram'] ?? 0.0;
        final double storage = m['storage'] ?? 0.0;
        final timeStr = DateTime.fromMillisecondsSinceEpoch(m['timestamp']).toLocal().toString().split(' ')[1].split('.')[0];
        memoryRowsBuffer.write('''
          <tr>
            <td>$timeStr</td>
            <td><strong>${ram.toStringAsFixed(2)} MB</strong></td>
            <td>${storage.toStringAsFixed(1)} MB</td>
          </tr>
        ''');
      }
    }

    // Build Recommendations action plan
    final actionPlanBuffer = StringBuffer();
    int actionCount = 1;
    if (slowCount > 0) {
      actionPlanBuffer.write('''
        <div class="tip-card warning">
          <div class="tip-title">Recommendation ${actionCount++}: Optimize Slow API Latencies (${slowCount} Warning(s))</div>
          <div class="tip-body">
            You have APIs with latencies exceeding 200ms. Consider incorporating:
            <ul>
              <li><strong>Local Caching:</strong> Use packages like <code>dio_cache_interceptor</code> to cache database list requests.</li>
              <li><strong>API Payload Reduction:</strong> Minimize response size by fetching paginated records only.</li>
              <li><strong>Network Pooling:</strong> Keep connection alive by reusing HTTP Clients.</li>
            </ul>
          </div>
        </div>
      ''');
    }
    if (ramGrowth) {
      actionPlanBuffer.write('''
        <div class="tip-card danger">
          <div class="tip-title">Recommendation ${actionCount++}: Address Continuous RAM Heap Growth (Potential Memory Leak)</div>
          <div class="tip-body">
            RAM heap consumption increased from ${memoryHistory.first['ram'].toStringAsFixed(1)} MB to ${memoryHistory.last['ram'].toStringAsFixed(1)} MB. Fixes include:
            <ul>
              <li><strong>Cancel Streams:</strong> Always invoke <code>streamSubscription.cancel()</code> in <code>dispose()</code> blocks.</li>
              <li><strong>Dispose Controllers:</strong> Ensure <code>TextEditingController</code>, <code>AnimationController</code>, and <code>ScrollController</code> invoke <code>.dispose()</code>.</li>
              <li><strong>Image Memory:</strong> Resize and scale network images using <code>cacheWidth</code> or <code>cacheHeight</code> properties.</li>
            </ul>
          </div>
        </div>
      ''');
    }
    if (actionCount == 1) {
      actionPlanBuffer.write('''
        <div class="tip-card success">
          <div class="tip-title">Excellent Performance Metrics Verified</div>
          <div class="tip-body">
            No severe latency issues, heap leaks, or storage warnings were detected during this profiling window. Keep up the high standards!
          </div>
        </div>
      ''');
    }

    return """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Flutter Runtime Performance Audit Report</title>
    <!-- Include html2pdf library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        :root {
            --primary: #0f172a;
            --primary-light: #1e293b;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --bg-light: #f8fafc;
            --border: #e2e8f0;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            padding: 40px;
            margin: 0;
            line-height: 1.5;
        }

        /* Floating action bar for PDF print */
        .print-bar {
            position: fixed;
            top: 20px;
            right: 40px;
            background-color: white;
            padding: 10px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            z-index: 1000;
            display: flex;
            gap: 12px;
        }

        .print-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .print-btn:hover {
            opacity: 0.9;
        }

        /* Content Page layout */
        .report-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }

        header {
            background-color: var(--primary);
            color: white;
            border-radius: 10px;
            padding: 24px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h1 {
            font-size: 1.35rem;
            margin: 0 0 6px 0;
            font-weight: 700;
        }

        header p {
            font-size: 0.85rem;
            margin: 0;
            color: #cbd5e1;
        }

        .score-circle {
            background: rgba(255,255,255,0.08);
            border: 2px solid white;
            border-radius: 50%;
            width: 70px;
            height: 70px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: 800;
        }

        .score-val {
            font-size: 1.4rem;
        }

        .score-lbl {
            font-size: 0.6rem;
            text-transform: uppercase;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            border-bottom: 2px solid var(--border);
            padding-bottom: 8px;
            margin-top: 32px;
            margin-bottom: 16px;
            color: var(--primary);
        }

        /* Summary Grid */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .summary-card {
            background-color: var(--bg-light);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 16px;
            text-align: center;
        }

        .summary-card .val {
            font-size: 1.35rem;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .summary-card .lbl {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            font-weight: 600;
        }

        /* Lists & Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.8rem;
            margin-bottom: 20px;
        }

        th {
            background-color: var(--bg-light);
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.7rem;
            padding: 10px 14px;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        td {
            padding: 10px 14px;
            border-bottom: 1px solid var(--border);
        }

        code {
            background-color: var(--bg-light);
            padding: 2px 6px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 0.8rem;
            border: 1px solid var(--border);
        }

        .font-mono {
            font-family: monospace;
        }

        .text-center { text-align: center; }
        .text-red { color: var(--danger); }
        .font-bold { font-weight: 700; }

        .status-badge {
            font-size: 0.7rem;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 4px;
        }
        .status-green { background-color: rgba(16,185,129,0.1); color: var(--success); }
        .status-red { background-color: rgba(239,68,68,0.1); color: var(--danger); }

        /* Timeline in PDF */
        .screen-item {
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 16px;
        }

        .screen-title-row {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
            padding-bottom: 6px;
            margin-bottom: 10px;
        }

        .screen-title {
            font-weight: 700;
            color: var(--primary);
        }

        .screen-body {
            font-size: 0.8rem;
        }

        /* Troubleshooting Tips */
        .tip-card {
            border-left: 4px solid var(--primary);
            background-color: var(--bg-light);
            border: 1px solid var(--border);
            border-left-width: 4px;
            border-radius: 6px;
            padding: 16px;
            margin-bottom: 16px;
        }

        .tip-card.warning { border-left-color: var(--warning); }
        .tip-card.danger { border-left-color: var(--danger); }
        .tip-card.success { border-left-color: var(--success); }

        .tip-title {
            font-weight: 700;
            font-size: 0.85rem;
            margin-bottom: 6px;
        }

        .tip-body {
            font-size: 0.8rem;
            color: var(--text-dark);
        }

        .tip-body ul {
            margin: 6px 0 0 16px;
            padding: 0;
        }

        /* Hiding print bar in printable layouts */
        @media print {
            .print-bar {
                display: none !important;
            }
            body {
                background: white;
                padding: 0;
            }
            .report-container {
                box-shadow: none;
                border: none;
                padding: 0;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Floating Print Bar -->
    <div class="print-bar">
        <button class="print-btn" onclick="downloadPdf()">Save PDF Report</button>
        <button class="print-btn" style="background-color: var(--text-muted);" onclick="window.print()">Print Report</button>
    </div>

    <!-- Main Container -->
    <div class="report-container" id="printableReport">
        <!-- Header -->
        <header>
            <div>
                <h1>Flutter Runtime Performance Report</h1>
                <p>App: <strong>$projectName</strong> | Duration: $durationSecStr</p>
                <p style="font-size:0.75rem; margin-top:4px;">Session: $startTimeStr to $endTimeStr</p>
            </div>
            <div class="score-circle">
                <span class="score-val">$perfScore</span>
                <span class="score-lbl">Score</span>
            </div>
        </header>

        <!-- Executive Summary -->
        <div class="section-title">Session Executive Summary</div>
        <div class="summary-grid">
            <div class="summary-card">
                <div class="val">${apiCalls.length}</div>
                <div class="lbl">API Requests</div>
            </div>
            <div class="summary-card">
                <div class="val">$avgLatency ms</div>
                <div class="lbl">Avg Response Time</div>
            </div>
            <div class="summary-card">
                <div class="val">${peakRam.toStringAsFixed(1)} MB</div>
                <div class="lbl">Peak RAM usage</div>
            </div>
            <div class="summary-card">
                <div class="val">${memoryHistory.isNotEmpty ? memoryHistory.last['storage'].toStringAsFixed(1) : '0.0'} MB</div>
                <div class="lbl">Database Storage</div>
            </div>
        </div>

        <!-- Screens to APIs Lifecycle Map -->
        <div class="section-title">Screen Lifecycle &amp; API Mapping</div>
        <div id="lifecycleList">
            $screenTimelineBuffer
        </div>

        <!-- Network APIs details -->
        <div class="section-title">Session HTTP Logs</div>
        <table>
            <thead>
                <tr>
                    <th style="width: 12%;">Method</th>
                    <th style="width: 50%;">URL</th>
                    <th style="width: 10%;">Status</th>
                    <th style="width: 15%;">Latency</th>
                    <th style="width: 13%;">Time</th>
                </tr>
            </thead>
            <tbody>
                $apiRowsBuffer
            </tbody>
        </table>

        <!-- Memory Stats -->
        <div class="section-title">Memory Allocation Log</div>
        <table>
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Heap Memory (RAM)</th>
                    <th>Storage Cache / Database Size</th>
                </tr>
            </thead>
            <tbody>
                $memoryRowsBuffer
            </tbody>
        </table>

        <!-- Architecture Action Plan -->
        <div class="section-title">Architecture Action Plan &amp; Solutions</div>
        <div id="recsList">
            $actionPlanBuffer
        </div>
    </div>

    <!-- Script to execute auto PDF download -->
    <script>
        function downloadPdf() {
            const element = document.getElementById('printableReport');
            const opt = {
                margin:       10,
                filename:     'runtime-perf-report-${projectName.toLowerCase().replaceAll(' ', '_')}.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2, useCORS: true },
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };

            // New window or loader indicator can be handled
            html2pdf().from(element).set(opt).save();
        }

        // Auto trigger download prompt when opened directly via download hook
        window.addEventListener('load', () => {
            const params = new URLSearchParams(window.location.search);
            if (params.get('autodownload') === 'true') {
                setTimeout(downloadPdf, 1000);
            }
        });
    </script>
</body>
</html>
""";
  }

  static String _escape(String str) {
    return str
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#039;');
  }
}
