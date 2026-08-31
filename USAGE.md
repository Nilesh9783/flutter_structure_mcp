# 🚀 Flutter Architect MCP: Complete Usage Guide

`flutter_architect_mcp` is a Model Context Protocol (MCP) server, command-line tool, and developer utility designed to streamline Flutter development. It automates **project scaffolding** (Clean, MVC, MVVM architectures), runs **codebase audits** (Security, Memory leaks, Performance, Code Quality), and hosts a **live Web Dashboard** for runtime app performance telemetry.

Now that the package is published on **pub.dev**, this guide explains how to install, configure, and use the MCP server in other projects.

---

## 📌 Table of Contents
1. [Prerequisites](#-prerequisites)
2. [Global Installation](#-global-installation)
3. [MCP Configuration (Claude Desktop, Cursor, VS Code)](#-mcp-configuration-claude-desktop-cursor-vs-code)
4. [Using the MCP Tools (AI Prompts)](#-using-the-mcp-tools-ai-prompts)
5. [Standalone Command Line Interface (CLI)](#-standalone-command-line-interface-cli)
6. [Configuring Automated Email Reports](#-configuring-automated-email-reports)
7. [Running the Runtime Performance Dashboard](#-running-the-runtime-performance-dashboard)

---

## ⚙️ Prerequisites

Before you begin, ensure you have the following installed on your machine:
* **Dart SDK** (3.10.3 or higher) or **Flutter SDK**
* **Git** (for code verification and applying fixes)
* **Node.js & npm** (optional, only if using the Mailman email dispatch utility)

Make sure the Dart/Flutter SDK is in your system's PATH. You can check this by running:
```bash
dart --version
```

---

## 📥 Global Installation

Install the package globally from **pub.dev**:
```bash
dart pub global activate flutter_architect_mcp
```

> [!NOTE]
> Once activated, Dart packages can be run globally using the `dart pub global run` command. If you want to use shortened commands directly (e.g. `flutter-architect`), make sure your system's PATH includes the Dart pub cache bin directory:
> * **macOS / Linux:** `~/.pub-cache/bin`
> * **Windows:** `%USERPROFILE%\.pub-cache\bin`

---

## 🔌 MCP Configuration (Claude Desktop, Cursor, VS Code)

To hook up the server with your LLM clients, add the configuration details below.

### 1. Claude Desktop
Open your Claude Desktop Configuration file:
* **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
* **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

Add the `flutter-architect` config block under `mcpServers`:

```json
{
  "mcpServers": {
    "flutter-architect": {
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "flutter_architect_mcp:server"
      ]
    }
  }
}
```

### 2. Cursor IDE
To integrate this directly in your IDE:
1. Go to **Cursor Settings** > **Features** > **MCP**.
2. Click **+ Add New MCP Server**.
3. Fill out the fields:
   * **Name:** `flutter-architect`
   * **Type:** `stdio`
   * **Command:** `dart pub global run flutter_architect_mcp:server`
4. Click **Save**.

### 3. VS Code (Cline / Roo Code / Continue Extensions)
If you are using VS Code extensions that support MCP:
Add the server entry to your extension's MCP configuration settings:
```json
"flutter-architect": {
  "command": "dart",
  "args": [
    "pub",
    "global",
    "run",
    "flutter_architect_mcp:server"
  ]
}
```

---

## 🤖 Using the MCP Tools (AI Prompts)

Once the MCP server is configured and active, you can instruct your AI client using natural language commands. Here are some examples:

### 🏗️ Scaffold a New Flutter Project
Ask the AI client:
> *"Scaffold a new Flutter app named `sales_portal` with `mvvm` architecture, `riverpod` state management, `hive` database, and `go_router` in `/Users/username/Desktop`."*

**What happens behind the scenes:**
* A fresh Flutter app is initialized.
* The default `lib` folder is replaced with custom MVVM templates.
* Dependencies are dynamically resolved and injected into the target project's `pubspec.yaml`.
* The master template cloner automatically rewrites hardcoded imports inside helper widgets/extensions to match your new package identifier.

---

### 🔍 Run Codebase Audits & Scans
Ask the AI client:
> *"Audit the Flutter project located at `/path/to/my/project`. Inspect it for security issues, memory leaks, and performance problems, and show me the summary."*

The MCP runs the following analysis modules:
* **Security & Secret Scanner:** Detects API keys, private tokens, and unsecure configuration files.
* **Memory Leak Scan:** Locates unclosed streams, unsubscribed controllers, and un-disposed animation controllers.
* **Performance Scan:** Identifies layout thrashing, non-optimized widgets, and network overhead.
* **Modularity Scan:** Evaluates file structure adherence to Clean/MVC/MVVM architectures.

---

### 🛠️ Suggest and Apply Fixes
Ask the AI client:
> *"Find the memory leaks and security issues in my current project directory, suggest fixes for them, and apply the safe fixes automatically."*

The MCP will:
1. Scan your project.
2. Formulate target replacement files.
3. Inject the correct closing/disposing boilerplate (e.g. adding `.dispose()` calls to controllers).
4. Run code formatting on modified files.

---

## 💻 Standalone Command Line Interface (CLI)

You can run the generator and analyzer CLI tools directly from the terminal without going through an LLM client:

### 1. Boilerplate Scaffolding Command
```bash
dart pub global run flutter_architect_mcp:flutter_architect_mcp \
  --name my_app_name \
  --arch mvvm \
  --state bloc \
  --db hive \
  --backend firebase \
  --network dio \
  --router go_router \
  --target /path/to/output/folder
```

**Available CLI Flags:**
* `--name`: (Required) Name of the Flutter project in snake_case.
* `--arch`: (Required) Architecture strategy: `clean`, `mvc`, `mvvm`, `layered`, or `feature-first`.
* `--state`: State management: `bloc`, `getx`, `provider`, `riverpod`, or `rxdart`.
* `--db`: Database configuration: `hive`, `isar`, or `drift`.
* `--backend`: Backend service integration: `firebase` or `supabase`.
* `--network`: HTTP Client integration: `dio` or `retrofit`.
* `--router`: Router setup: `go_router`, `auto_route`, or `own_extensions`.
* `--target`: Parent directory path to build the project inside (defaults to current directory).

---

### 2. Standalone Audit Analyzer
Run a full audit command-line scan of any project directory:
```bash
dart pub global run flutter_architect_mcp:run_audit --path /path/to/project --report-type html
```
**Options:**
* `--path`: The absolute path of the codebase folder to audit.
* `--report-type`: `html`, `json`, `markdown`, or `all`.

---

## 📬 Configuring Automated Email Reports

Your MCP server can automatically email static analysis reports directly to teammates, managers, or stakeholders.

### Option A: Mailman CLI (Recommended)
The `flutter_architect_mcp` server integrates directly with **Mailman**, a secure, local Node-based email CLI and MCP server that manages Gmail accounts, drafts, and email dispatches:

1. **Install Mailman globally:**
   ```bash
   npm install -g @integratex/mailman
   ```
   *(Or use `pnpm add -g @integratex/mailman`, `yarn global add @integratex/mailman`, or `bun add -g @integratex/mailman`)*

2. **Initialize and run the setup wizard:**
   ```bash
   mailman init
   ```
   This interactive setup wizard will guide you through connecting your Gmail/Email account:
   * **App Password:** Paste a 16-character Google App Password.
   * **OAuth2 Browser Flow:** Choose to sign in via your web browser.
   * **Register AI Tools:** Select which editors (Claude Code, Cursor, etc.) to automatically configure.

3. **Verify and test the connection:**
   * Run `mailman status` to check configured email accounts.
   * Run `mailman doctor` to perform live checks on keychains, node, logins, and Gmail reachability.

4. **MCP Configuration (Optional - for direct AI interaction):**
   If you want to talk to Mailman directly in your AI assistant, register it:
   ```bash
   mailman register --tools claude,cursor
   ```
   Or add it manually to your client config:
   ```json
   "mailman": {
     "command": "npx",
     "args": ["-y", "@integratex/mailman"]
   }
   ```

### Option B: Local SMTP Credentials
Create or edit `config/email_settings.yaml` under the project root of the MCP server:
```yaml
smtp:
  host: "smtp.gmail.com"
  port: 465
  username: "your-email@gmail.com"
  password: "your-app-specific-password"
  secure: true
  from_address: "your-email@gmail.com"
  from_name: "Flutter Architect MCP"
```

### Option C: Simulation Mode (Fallback)
If neither Mailman nor SMTP is set up, the email service will output a simulated email layout locally:
* HTML layout file: `reports/simulated_emails/email_<timestamp>.html`
* Attachment preview: `reports/simulated_emails/attachment_<timestamp>.pdf`

---

## 📊 Running the Runtime Performance Dashboard

The **Runtime Performance Monitor** starts a lightweight dashboard server. Your running mobile app (on emulator, simulator, or physical USB device) streams performance telemetry directly to it via WebSockets.

### 1. Launch the Server Dashboard
Run the following terminal command from anywhere:
```bash
dart pub global run flutter_architect_mcp:run_runtime_perf --port 8080
```
Open **`http://localhost:8080`** in your web browser to access the dashboard.

### 2. Integrate with Your Flutter App
Copy the code snippets provided on the dashboard page and add them to your Flutter application:

* **HTTP Request Interceptor (Dio):** Log performance latencies and API endpoint speeds.
* **Navigation Observer:** Log active screens and calculate render transition times.
* **Periodic RAM & Storage Streamer:** Launch a stream inside your app's `main()` function to report memory heap (RSS) changes and database file sizes.

### 3. Generate Runtime PDF Reports
When you finish testing your app flow:
1. Go to the dashboard website.
2. Click **Stop & Save PDF**.
3. A complete, beautifully formatted PDF report containing latency timelines, RAM heap consumption charts, and diagnostic tips will be saved to your `reports/` folder.
