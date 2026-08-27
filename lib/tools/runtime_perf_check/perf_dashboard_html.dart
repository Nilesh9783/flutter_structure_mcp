const String dashboardHtml = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flutter Runtime Performance Monitor</title>
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: #151d30;
            --sidebar-bg: #090c15;
            --text-color: #e2e8f0;
            --text-muted: #94a3b8;
            --primary: #38bdf8;
            --primary-glow: rgba(56, 189, 248, 0.15);
            --border: #222e4a;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar styling */
        .sidebar {
            width: 280px;
            background-color: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            padding: 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .brand h2 {
            font-size: 1.25rem;
            font-weight: 700;
            background: linear-gradient(135deg, #38bdf8 0%, #818cf8 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }

        .brand p {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .session-status {
            margin: 32px 0;
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
        }

        .status-header {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: var(--success);
            box-shadow: 0 0 10px var(--success);
        }

        .status-dot.stopped {
            background-color: var(--danger);
            box-shadow: 0 0 10px var(--danger);
        }

        .timer {
            font-size: 1.75rem;
            font-weight: 700;
            font-family: monospace;
            color: var(--text-color);
        }

        .btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid transparent;
            transition: all 0.2s;
            text-decoration: none;
            gap: 8px;
        }

        .btn-primary {
            background-color: var(--danger);
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
        }

        .btn-primary:hover {
            background-color: #dc2626;
        }

        .btn-secondary {
            background-color: transparent;
            border-color: var(--border);
            color: var(--text-color);
            margin-top: 8px;
        }

        .btn-secondary:hover {
            background-color: rgba(255,255,255,0.05);
        }

        /* Main Area styling */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100%;
            overflow: hidden;
        }

        .nav-tabs {
            display: flex;
            background-color: var(--sidebar-bg);
            border-bottom: 1px solid var(--border);
            padding: 0 24px;
            height: 56px;
            align-items: center;
            gap: 16px;
        }

        .tab-link {
            color: var(--text-muted);
            font-size: 0.9rem;
            font-weight: 600;
            padding: 16px 8px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: all 0.2s;
        }

        .tab-link:hover, .tab-link.active {
            color: var(--primary);
        }

        .tab-link.active {
            border-bottom-color: var(--primary);
        }

        .tab-panel {
            flex: 1;
            padding: 24px;
            overflow-y: auto;
            display: none;
        }

        .tab-panel.active {
            display: block;
        }

        /* Overview grid widgets */
        .overview-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .widget-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .widget-lbl {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.05em;
            margin-bottom: 6px;
        }

        .widget-val {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-color);
        }

        /* Tables & Lists */
        .card-header {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .data-table-wrapper {
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 24px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.85rem;
        }

        th {
            background-color: rgba(255,255,255,0.02);
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.03em;
            padding: 12px 16px;
            border-bottom: 1px solid var(--border);
        }

        td {
            padding: 12px 16px;
            border-bottom: 1px solid var(--border);
            color: var(--text-color);
        }

        tr:last-child td {
            border-bottom: none;
        }

        .badge {
            display: inline-block;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            padding: 3px 8px;
            border-radius: 4px;
        }

        .badge-success { background-color: rgba(16, 185, 129, 0.15); color: var(--success); border: 1px solid var(--success); }
        .badge-warning { background-color: rgba(245, 158, 11, 0.15); color: var(--warning); border: 1px solid var(--warning); }
        .badge-danger { background-color: rgba(239, 68, 68, 0.15); color: var(--danger); border: 1px solid var(--danger); }

        /* Timelines */
        .timeline {
            display: flex;
            flex-direction: column;
            gap: 16px;
            margin-top: 12px;
        }

        .timeline-item {
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            position: relative;
        }

        .timeline-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .timeline-time {
            font-size: 0.75rem;
            color: var(--text-muted);
            font-family: monospace;
        }

        .timeline-apis {
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid var(--border);
        }

        .timeline-api-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        /* Guide styling */
        .code-box {
            background-color: #090c15;
            padding: 16px;
            border-radius: 8px;
            border: 1px solid var(--border);
            font-family: monospace;
            font-size: 0.8rem;
            color: #38bdf8;
            overflow-x: auto;
            margin: 12px 0 24px 0;
            line-height: 1.4;
        }

        .integration-section h3 {
            font-size: 1rem;
            font-weight: 700;
            margin-top: 20px;
            margin-bottom: 8px;
            color: var(--primary);
        }

        .integration-section p {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 8px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div>
            <div class="brand">
                <h2>Flutter DevTools</h2>
                <p>Runtime Profiler Session</p>
            </div>

            <div class="session-status">
                <div class="status-header">
                    <div class="status-dot" id="statusDot"></div>
                    <span id="statusTxt">Active Monitoring</span>
                </div>
                <div class="timer" id="sessionTimer">00:00:00</div>
            </div>
        </div>

        <div>
            <button class="btn btn-primary" onclick="stopSession()">Stop &amp; Save PDF</button>
            <button class="btn btn-secondary" onclick="restartSession()">Reset Session</button>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Tab Bar -->
        <div class="nav-tabs">
            <div class="tab-link active" onclick="switchTab('overview')">Overview</div>
            <div class="tab-link" onclick="switchTab('screens')">Screens Lifecycle</div>
            <div class="tab-link" onclick="switchTab('network')">Network Logger</div>
            <div class="tab-link" onclick="switchTab('memory')">Memory Trends</div>
            <div class="tab-link" onclick="switchTab('guide')">Integration Guide</div>
        </div>

        <!-- Overview Tab -->
        <div class="tab-panel active" id="overview">
            <div class="overview-grid">
                <div class="widget-card">
                    <div class="widget-lbl">Active Screen</div>
                    <div class="widget-val" id="widgetScreen">None</div>
                </div>
                <div class="widget-card">
                    <div class="widget-lbl">Memory Usage (Heap)</div>
                    <div class="widget-val" id="widgetMemory">0.0 MB</div>
                </div>
                <div class="widget-card">
                    <div class="widget-lbl">API Calls</div>
                    <div class="widget-val" id="widgetApiCount">0</div>
                </div>
                <div class="widget-card">
                    <div class="widget-lbl">Avg Response Time</div>
                    <div class="widget-val" id="widgetLatency">0ms</div>
                </div>
            </div>

            <div class="card-header">
                <h3>Latest Network Requests</h3>
            </div>
            <div class="data-table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 15%;">Method</th>
                            <th style="width: 50%;">Endpoint</th>
                            <th style="width: 15%;">Status</th>
                            <th style="width: 20%;">Latency</th>
                        </tr>
                    </thead>
                    <tbody id="overviewNetworkBody">
                        <tr>
                            <td colspan="4" style="text-align: center; color: var(--text-muted);">No requests recorded yet. Pinging active application...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Screens Tab -->
        <div class="tab-panel" id="screens">
            <div class="card-header">
                <h3>Screens Navigation Timeline &amp; Initial APIs</h3>
            </div>
            <div class="timeline" id="screensTimeline">
                <div style="text-align: center; padding: 32px; color: var(--text-muted);">
                    No navigation timeline recorded. Run your app and navigate screens to populate.
                </div>
            </div>
        </div>

        <!-- Network Tab -->
        <div class="tab-panel" id="network">
            <div class="card-header">
                <h3>All Session Request Logs</h3>
            </div>
            <div class="data-table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 12%;">Method</th>
                            <th style="width: 48%;">URL</th>
                            <th style="width: 15%;">Status</th>
                            <th style="width: 13%;">Duration</th>
                            <th style="width: 12%;">Time</th>
                        </tr>
                    </thead>
                    <tbody id="fullNetworkBody">
                        <tr>
                            <td colspan="5" style="text-align: center; color: var(--text-muted);">No network requests captured yet.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Memory Tab -->
        <div class="tab-panel" id="memory">
            <div class="card-header">
                <h3>RAM Utilization Timeline</h3>
            </div>
            <div style="background-color: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; padding: 24px; margin-bottom: 24px;">
                <div style="display: flex; gap: 40px; margin-bottom: 24px;">
                    <div>
                        <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 4px;">PEAK HEAP MEMORY</div>
                        <div style="font-size: 2rem; font-weight: 700; color: var(--warning);" id="memPeak">0.0 MB</div>
                    </div>
                    <div>
                        <div style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 4px;">CURRENT HEAP</div>
                        <div style="font-size: 2rem; font-weight: 700; color: var(--success);" id="memCurrent">0.0 MB</div>
                    </div>
                </div>
                <div class="card-header">
                    <h4>Heap Growth Log</h4>
                </div>
                <div id="memoryLogList" style="max-height: 300px; overflow-y: auto; font-family: monospace; font-size: 0.85rem; color: var(--text-muted); line-height: 1.6;">
                    No memory captures recorded. Memory tracks are pushed every few seconds by the client app.
                </div>
            </div>
        </div>

        <!-- Guide Tab -->
        <div class="tab-panel" id="guide">
            <div class="integration-section">
                <h2>How to Connect Your Flutter Application</h2>
                <p>To record metrics in real time and capture them in this web panel, integrate the helper codes in your Flutter project. Make sure you target the correct server host address depending on your environment:</p>
                <div style="background-color: rgba(255,255,255,0.02); border: 1px solid var(--border); border-radius: 8px; padding: 12px 16px; margin: 12px 0 20px 0; font-size: 0.85rem;">
                    <strong style="color: var(--primary);">Network Host URL Settings:</strong>
                    <ul style="margin-left: 20px; margin-top: 8px; line-height: 1.6; color: var(--text-muted);">
                        <li><strong>iOS Simulator (Mac):</strong> Use <code>http://localhost:8080/api/record</code></li>
                        <li><strong>Android Emulator:</strong> Use <code>http://10.0.2.2:8080/api/record</code></li>
                        <li><strong>Physical Android (USB):</strong> Run <code>adb reverse tcp:8080 tcp:8080</code> in terminal, then use <code>http://localhost:8080/api/record</code></li>
                        <li><strong>Physical iOS/Android (Wi-Fi):</strong> Connect both to the same Wi-Fi network, then use <code>http://&lt;your-computer-ip&gt;:8080/api/record</code></li>
                    </ul>
                </div>

                <h3>1. Record API Network Requests</h3>
                <p>Add a Custom Interceptor in your Dio client setup to POST timings to `http://localhost:8080/api/record`:</p>
                <div class="code-box">
class PerfInterceptor extends Interceptor {
  final String serverUrl = 'http://localhost:8080/api/record';
  final Map<RequestOptions, DateTime> _startTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTimes[options] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _startTimes.remove(response.requestOptions);
    if (startTime != null) {
      final latency = DateTime.now().difference(startTime).inMilliseconds;
      _sendMetric({
        'type': 'network',
        'method': response.requestOptions.method,
        'url': response.requestOptions.uri.toString(),
        'status': response.statusCode ?? 200,
        'latency': latency,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = _startTimes.remove(err.requestOptions);
    if (startTime != null) {
      final latency = DateTime.now().difference(startTime).inMilliseconds;
      _sendMetric({
        'type': 'network',
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'status': err.response?.statusCode ?? 500,
        'latency': latency,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
    super.onError(err, handler);
  }

  void _sendMetric(Map<String, dynamic> data) async {
    try {
      await Dio().post(serverUrl, data: data);
    } catch (_) {}
  }
}</div>

                <h3>2. Track Active Screens</h3>
                <p>Register a NavigatorObserver in your `MaterialApp` to log screen routing changes:</p>
                <div class="code-box">
class PerfNavigatorObserver extends NavigatorObserver {
  final String serverUrl = 'http://localhost:8080/api/record';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      _sendMetric({
        'type': 'screen',
        'screenName': route.settings.name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  void _sendMetric(Map<String, dynamic> data) async {
    try {
      await Dio().post(serverUrl, data: data);
    } catch (_) {}
  }
}</div>

                <h3>3. Periodically Stream RAM / Heap Memory &amp; Storage</h3>
                <p>Run a timer task inside your app startup to fetch and push memory metrics:</p>
                <div class="code-box">
Timer.periodic(Duration(seconds: 4), (timer) async {
  // RAM / Heap Profile
  final double ramMb = (ProcessInfo.currentRss) / (1024 * 1024);
  
  // Storage usage estimation
  final double storageMb = 2.1; // Estimate database file size

  try {
    await Dio().post('http://localhost:8080/api/record', data: {
      'type': 'memory',
      'ram': ramMb,
      'storage': storageMb,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  } catch (_) {}
});</div>
            </div>
        </div>
    </div>

    <!-- WebSockets and Dynamic JavaScript -->
    <script>
        let startTime = Date.now();
        let timerInterval;

        function startTimer() {
            clearInterval(timerInterval);
            timerInterval = setInterval(() => {
                const diff = Date.now() - startTime;
                const hrs = Math.floor(diff / 3600000).toString().padStart(2, '0');
                const mins = Math.floor((diff % 3600000) / 60000).toString().padStart(2, '0');
                const secs = Math.floor((diff % 60000) / 1000).toString().padStart(2, '0');
                document.getElementById('sessionTimer').innerText = hrs + ':' + mins + ':' + secs;
            }, 1000);
        }

        // Connect WebSocket
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const ws = new WebSocket(protocol + '//' + window.location.host + '/ws');
        
        ws.onopen = () => {
            console.log('Connected to metrics streaming server.');
            startTimer();
        };

        ws.onmessage = (event) => {
            const data = JSON.parse(event.data);
            if (data.type === 'session_state') {
                updateDashboard(data.payload);
            }
        };

        function updateDashboard(payload) {
            // Update duration and start times
            startTime = payload.startTime;
            if (payload.isRecording === false) {
                clearInterval(timerInterval);
                document.getElementById('statusDot').className = 'status-dot stopped';
                document.getElementById('statusTxt').innerText = 'Session Stopped';
            } else {
                document.getElementById('statusDot').className = 'status-dot';
                document.getElementById('statusTxt').innerText = 'Active Monitoring';
                startTimer();
            }

            // Overview widgets
            document.getElementById('widgetScreen').innerText = payload.activeScreen || 'None';
            document.getElementById('widgetMemory').innerText = payload.currentRam.toFixed(1) + ' MB';
            document.getElementById('widgetApiCount').innerText = payload.apiCalls.length;
            
            // Calculate average latency
            if (payload.apiCalls.length > 0) {
                const sum = payload.apiCalls.reduce((acc, call) => acc + call.latency, 0);
                const avg = Math.round(sum / payload.apiCalls.length);
                document.getElementById('widgetLatency').innerText = avg + 'ms';
            } else {
                document.getElementById('widgetLatency').innerText = '0ms';
            }

            // Memory page
            document.getElementById('memCurrent').innerText = payload.currentRam.toFixed(1) + ' MB';
            document.getElementById('memPeak').innerText = payload.peakRam.toFixed(1) + ' MB';
            
            const memoryList = document.getElementById('memoryLogList');
            if (payload.memoryHistory.length > 0) {
                memoryList.innerHTML = payload.memoryHistory.map(m => {
                    const time = new Date(m.timestamp).toLocaleTimeString();
                    return '<div>[' + time + '] &nbsp; Heap Size: <strong>' + m.ram.toFixed(2) + ' MB</strong> &nbsp; (Storage DB estimate: ' + m.storage.toFixed(1) + ' MB)</div>';
                }).join('');
            }

            // Network Tables
            const overviewBody = document.getElementById('overviewNetworkBody');
            const fullBody = document.getElementById('fullNetworkBody');

            if (payload.apiCalls.length === 0) {
                overviewBody.innerHTML = '<tr><td colspan="4" style="text-align: center; color: var(--text-muted);">No requests recorded yet. Pinging active application...</td></tr>';
                fullBody.innerHTML = '<tr><td colspan="5" style="text-align: center; color: var(--text-muted);">No network requests captured yet.</td></tr>';
            } else {
                // Map latest 5 requests to overview
                const latest = [...payload.apiCalls].reverse().slice(0, 5);
                overviewBody.innerHTML = latest.map(c => {
                    const badgeClass = c.status < 400 ? 'badge-success' : 'badge-danger';
                    return '<tr>' +
                        '<td><code>' + c.method + '</code></td>' +
                        '<td style="font-family: monospace;">' + escapeHtml(c.url) + '</td>' +
                        '<td><span class="badge ' + badgeClass + '">' + c.status + '</span></td>' +
                        '<td><strong>' + c.latency + 'ms</strong></td>' +
                        '</tr>';
                }).join('');

                // Map all requests to full grid
                fullBody.innerHTML = [...payload.apiCalls].reverse().map(c => {
                    const badgeClass = c.status < 400 ? 'badge-success' : 'badge-danger';
                    const timeStr = new Date(c.timestamp).toLocaleTimeString();
                    return '<tr>' +
                        '<td><code>' + c.method + '</code></td>' +
                        '<td style="font-family: monospace;">' + escapeHtml(c.url) + '</td>' +
                        '<td><span class="badge ' + badgeClass + '">' + c.status + '</span></td>' +
                        '<td><strong>' + c.latency + 'ms</strong></td>' +
                        '<td style="color: var(--text-muted); font-size: 0.8rem;">' + timeStr + '</td>' +
                        '</tr>';
                }).join('');
            }

            // Timeline Tab
            const timeline = document.getElementById('screensTimeline');
            if (payload.screenHistory.length === 0) {
                timeline.innerHTML = '<div style="text-align: center; padding: 32px; color: var(--text-muted);">No navigation timeline recorded. Run your app and navigate screens to populate.</div>';
            } else {
                timeline.innerHTML = payload.screenHistory.map(s => {
                    const idx = payload.screenHistory.indexOf(s);
                    const nextScreen = payload.screenHistory[idx + 1];
                    const startTime = s.timestamp;
                    const endTime = nextScreen ? nextScreen.timestamp : Date.now();

                    const screenApis = payload.apiCalls.filter(c => c.timestamp >= startTime && c.timestamp < endTime);
                    
                    let apiRows = '<div style="font-size: 0.8rem; color: var(--text-muted); padding-top: 4px;">No API calls logged during this screen.</div>';
                    if (screenApis.length > 0) {
                        apiRows = screenApis.map(c => {
                            const badgeClass = c.status < 400 ? 'badge-success' : 'badge-danger';
                            const cleanUrl = c.url.split('?')[0];
                            return '<div class="timeline-api-row">' +
                                '<span><code>' + c.method + '</code> &nbsp; ' + escapeHtml(cleanUrl) + '</span>' +
                                '<strong>' + c.latency + 'ms <span class="badge ' + badgeClass + '" style="font-size: 0.65rem; padding: 1px 4px;">' + c.status + '</span></strong>' +
                                '</div>';
                        }).join('');
                    }

                    const timeStr = new Date(s.timestamp).toLocaleTimeString();
                    return '<div class="timeline-item">' +
                        '<div class="timeline-header">' +
                        '<span style="color: var(--primary); font-size: 0.95rem;">' + s.screenName + '</span>' +
                        '<span class="timeline-time">' + timeStr + '</span>' +
                        '</div>' +
                        '<div class="timeline-apis">' +
                        '<div style="font-size: 0.7rem; font-weight: bold; text-transform: uppercase; color: var(--text-muted); margin-bottom: 8px; letter-spacing: 0.05em;">API Requests on Screen:</div>' +
                        apiRows +
                        '</div>' +
                        '</div>';
                }).reverse().join('');
            }
        }

        function escapeHtml(str) {
            return str
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        function switchTab(tabId) {
            document.querySelectorAll('.tab-link').forEach(link => {
                link.classList.remove('active');
                if (link.innerText.toLowerCase().includes(tabId.substring(0,3))) {
                    link.classList.add('active');
                }
            });

            document.querySelectorAll('.tab-panel').forEach(panel => {
                panel.classList.remove('active');
            });
            document.getElementById(tabId).classList.add('active');
        }

        function stopSession() {
            if (!confirm('Are you sure you want to stop the recording session and compile the PDF performance report?')) {
                return;
            }

            fetch('/api/stop', { method: 'POST' })
            .then(res => res.text())
            .then(htmlContent => {
                const blob = new Blob([htmlContent], { type: 'text/html' });
                const url = URL.createObjectURL(blob);
                
                // Open report in new window to print/save
                const printWindow = window.open(url, '_blank');
                if (printWindow) {
                    printWindow.focus();
                } else {
                    // Fallback to direct download link if blocked
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = 'runtime-performance-report.html';
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                }
            });
        }

        function restartSession() {
            if (!confirm('This will wipe all currently recorded metrics. Reset session?')) {
                return;
            }
            fetch('/api/reset', { method: 'POST' })
            .then(() => {
                location.reload();
            });
        }
    </script>
</body>
</html>
""";
