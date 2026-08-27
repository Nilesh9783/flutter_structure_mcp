# Flutter Engineering MCP Analysis Report

## Project Overview
- **Project Name:** flutter_architect_mcp
- **Flutter SDK:** 3.38.4
- **Dart SDK:** ^3.10.3
- **State Management:** setState
- **Database:** None
- **Router:** Navigator (Default)
- **Network Client:** HttpClient (Default)

## Security Score: **69/100**
```
Calculated from security/dependency findings:
- Initial Base Score: 100
- Critical Findings: 0 (Penalty: -25 points each => 0)
- High Findings: 1 (Penalty: -15 points each => -15)
- Medium Findings: 2 (Penalty: -7 points each => -14)
- Low Findings: 1 (Penalty: -2 points each => -2)
- Total Deductions: 31
- Final Score: 69
```

## Summary of Findings
- **Critical:** 0
- **High:** 1
- **Medium:** 2
- **Low:** 1

## Analysis Criteria Observed
The analysis was performed based on the following dynamic sheet and local configuration criteria:

### Code Quality
- **Proper use of const and final** (Maintainability - Static): If widget not updated once declear and vaeriable value will never change once declear then use const and final with decration [Threshold: const_possible == true
assignment_count == 1]
- **Large File LOC** (Complexity - Static): Trigger when a file has more than 500 non-empty, non-comment code lines [Threshold: file_code_loc > 500]
- **Large Class LOC** (Complexity - Static): Trigger when a class exceeds configured LOC threshold [Threshold: class_code_loc > 300]
- **Large Function LOC** (Complexity - Static): Trigger when a function/method exceeds configured LOC threshold [Threshold: function_code_loc > 80]
- **Unused Widgets/Classes/Functions** (Dead Code - Static): Declared widget/class/function has no references [Threshold: reference_count == 0]
- **Unused Imports** (Dead Code - Static): Imported symbol is never referenced [Threshold: import_reference_count == 0]
- **Unreachable Branch** (Dead Code - Static): Branch can never execute based on static control-flow analysis [Threshold: unreachable == true]
- **High Cyclomatic Complexity** (Maintainability - Static): Function exceeds complexity threshold [Threshold: complexity > 10]
- **Duplicate Code** (Duplication - Static): Similar code block exceeds configured similarity threshold [Threshold: similarity >= 0.85]
- **Large Build Method** (Flutter - Static): Build method exceeds configured size [Threshold: build_loc > 80]
- **Deep Widget Nesting** (Flutter - Static): Widget tree nesting exceeds threshold [Threshold: depth > 8]
- **Broad State Rebuild** (Flutter - Static): State update potentially rebuilds unnecessarily large widget subtree [Threshold: Configurable]
- **Missing Const Opportunity** (Flutter - Static): Constructor/widget can safely be const but is not [Threshold: const_possible == true]
- **Improper final Usage** (Flutter - Static): Local variable never reassigned and can be final [Threshold: assignment_count == 1]
- **Unsafe Late Usage** (Flutter - Static): late variable may be accessed before initialization or is unnecessary [Threshold: Configurable]
- **Naming Convention Violation** (Naming - Static): Classes, variables, methods/files violate Dart naming conventions [Threshold: Dart convention]
- **Empty Catch Block** (Error Handling - Static): Catch block has no meaningful handling/logging/rethrow [Threshold: catch_body_effective_statements == 0]

### Security
- **Hardcoded API Key** (Secrets - Static): API key pattern detected in source/config [Threshold: Pattern + entropy score]
- **Payment Gateway Credential** (Secrets - Static): Payment provider private/secret credential detected [Threshold: Provider pattern]
- **Firebase Service Account** (Secrets - Static): Firebase service-account JSON/private key detected [Threshold: Credential pattern]
- **Private Key/Certificate** (Secrets - Static): PEM/private key/signing material detected [Threshold: private_key_detected == true]
- **Insecure Token Storage** (Authentication - Static): Access/refresh tokens stored in SharedPreferences/plain files [Threshold: Sensitive token + insecure storage]
- **HTTP/Cleartext Traffic** (Network - Static): Non-TLS HTTP endpoint or cleartext platform configuration detected [Threshold: http:// / cleartext enabled]
- **Certificate Validation Bypass** (Network - Static): Client bypasses certificate validation [Threshold: Trust-all callback/API]
- **Unsafe WebView Configuration** (WebView - Static): JavaScript/file access/untrusted navigation enabled without controls [Threshold: Risk pattern]
- **Unsafe Dynamic Data Handling** (Input - Static): Unsafe eval-like/dynamic deserialization or execution pattern detected [Threshold: Risk API pattern]
- **Sensitive Data in Logs** (Logging - Static): Token/password/payment/PII passed to logging APIs [Threshold: Sensitive variable/pattern]
- **Android Insecure Configuration** (Platform - Static): Debuggable release config, exported components or permissive network settings [Threshold: Risk configuration]
- **iOS Insecure Configuration** (Platform - Static): ATS exceptions, insecure entitlements or overly permissive settings [Threshold: Risk configuration]
- **Overly Permissive Firebase Rules** (Firebase - Static): Firestore/Realtime Database allows broad unauthenticated read/write [Threshold: Broad read/write access]

### Memory Leak
- **Unclosed StreamSubscription** (Lifecycle - Static): StreamSubscription created without matching cancellation/disposal [Threshold: cancel_missing == true]
- **Unclosed Timer** (Lifecycle - Static): Timer created without cancellation [Threshold: cancel_missing == true]
- **AnimationController Not Disposed** (Lifecycle - Static): AnimationController created in State without dispose [Threshold: dispose_missing == true]
- **TextEditingController Not Disposed** (Lifecycle - Static): TextEditingController retained without disposal [Threshold: dispose_missing == true]
- **Scroll/Page Controller Not Disposed** (Lifecycle - Static): ScrollController/PageController created without disposal [Threshold: dispose_missing == true]
- **Listener Not Removed** (State - Static): addListener/addObserver without matching remove [Threshold: remove_missing == true]
- **Unnecessary StatefulWidget** (Flutter - Static): StatefulWidget has no mutable state or lifecycle requirement [Threshold: stateful_need == false]
- **Missing Const StatelessWidget** (Flutter - Static): Immutable widget does not use const constructor [Threshold: const_possible == true]
- **Long-Lived Closure Captures State/Context** (Closures - Static): Long-lived callback captures State/BuildContext [Threshold: Risk pattern]
- **Unbounded In-Memory Collection** (Collections - Static): List/map/cache grows without size/eviction control [Threshold: Configurable size/eviction rule]

### Runtime Analysis
- **Heap Growth Over Time** (Memory - Runtime): Heap increases across repeated flows and does not return toward baseline [Threshold: Configurable growth %]
- **Widget/Object Retention** (Memory - Runtime): Objects remain retained after route/widget disposal [Threshold: Retained after disposal]
- **Frame Rendering/Jank** (Performance - Runtime): Frame build/raster time exceeds threshold or dropped frames detected [Threshold: frame_time > 16.67ms]
- **Excessive Widget Rebuilds** (Performance - Runtime): Widget rebuild count significantly exceeds expected baseline [Threshold: Configurable multiplier]
- **Slow Startup** (Performance - Runtime): Cold-start time exceeds configured threshold [Threshold: startup_ms > 3000]
- **Slow API Request** (Network - Runtime): API request exceeds latency threshold [Threshold: latency_ms > 2000]
- **Excessive Network Traffic** (Network - Runtime): Unexpected request frequency or payload volume [Threshold: Configurable request/payload threshold]
- **Unhandled Exception** (Crash - Runtime): Unhandled Dart/Flutter exception during test flow [Threshold: unhandled_exception == true]
- **Resource Retained After Screen Exit** (Lifecycle - Runtime): Subscription/timer remains active after navigation away [Threshold: Active resource after dispose]
- **Sensitive Runtime Storage** (Storage - Runtime): Token/payment/PII written to logs or insecure storage [Threshold: Sensitive data detected]

### Dependencies
- **Vulnerable Package Version** (Vulnerability - Static): Direct/transitive dependency has known security advisory [Threshold: Known CVE/advisory]
- **Unused Dependency** (Hygiene - Static): Declared package has no project references [Threshold: reference_count == 0]
- **Unmaintained Package** (Risk - Static): Package has stale releases or weak maintenance signals [Threshold: Configurable inactivity period]

### Architecture
- **Layer Violation** (Structure - Static): UI directly accesses infrastructure/data layer against selected architecture [Threshold: Forbidden dependency]
- **Mixed State Management** (State Management - Static): Conflicting state-management patterns used across modules [Threshold: Configured allowed patterns]
- **Business Logic Inside Widget** (Testability - Static): Networking/business rules embedded in build/UI classes [Threshold: Configurable complexity/API count]

### Reporting
- **File/Line/Code Evidence** (Evidence - Both): Every finding must include exact source location and evidence snippet [Threshold: Required fields]
- **Severity/Confidence Scoring** (Severity - Both): Every finding receives severity and confidence [Threshold: Required fields]
- **Suppression/Ignore Support** (False Positives - Both): Approved findings can be suppressed with a reason [Threshold: Suppression requires reason]

### Local Threshold Parameters
- **Max Lines of Code per file:** 500
- **Max lines per function:** 50
- **Allow TODO comments:** false
- **Enforce class prefixes:** true


## Findings List

### [SECURITY] [MEDIUM] Incomplete Logout Implementation
- **File:** lib/security/scanners/auth_scanner.dart:1
- **Confidence:** LOW
- **Evidence:** `void logout() { ... }`
- **Description:** The logout function in lib/security/scanners/auth_scanner.dart does not appear to clear local authentication tokens or cache.
- **Risk:** If local storage is not wiped during logout, another user or an attacker could potentially access the preceding session.
- **Recommendation:** Ensure SharedPreferences, Hive boxes, and local caches are cleared or deleted when the user logs out.
- **Fix Available:** No
---

### [SECURITY] [HIGH] Potential Hardcoded Password or Auth Key
- **File:** templates/shared/utils/helper/shared_pref_helper.dart:13
- **Confidence:** MEDIUM
- **Evidence:** `final String deviceToken = 'deviceToken';`
- **Description:** Found variable assignment indicating a hardcoded password or token: "String deviceToken = 'deviceToken'"
- **Risk:** Hardcoding passwords in code makes them accessible to any attacker who extracts the application binary.
- **Recommendation:** Retrieve passwords dynamically from user input or encrypted vaults.
- **Fix Available:** No
---

### [SECURITY] [MEDIUM] WebView JavaScript Execution Enabled Unrestrictedly
- **File:** templates/shared/common/reusable_component/widgets/web_view.dart:1
- **Confidence:** HIGH
- **Evidence:** `JavaScriptMode.unrestricted`
- **Description:** Detected a WebView instantiated with unrestricted JavaScript execution enabled.
- **Risk:** Enabling JavaScript in WebViews allows loaded pages to execute code. If untrusted remote content is displayed, it could lead to Cross-Site Scripting (XSS) attacks compromising local app data or bridge APIs.
- **Recommendation:** Only enable JavaScript if strictly required. Ensure that navigation is restricted to HTTPS and approved domains using navigation delegates.
- **Fix Available:** No
---

### [DEPENDENCY] [LOW] Vulnerability Database Check Status
- **File:** pubspec.yaml:1
- **Confidence:** HIGH
- **Evidence:** `Local Vulnerability Database Active`
- **Description:** Using built-in offline Dart/Flutter security rules database. Remote live vulnerability database check is not configured.
- **Risk:** None. This is an informational message stating that live CVE lookup from OSV/GitHub Advisory is not active.
- **Recommendation:** Periodically check dependencies using GitHub security alerts or running "dart pub token" or external tools.
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential StreamSubscription Memory Leak
- **File:** scratch/test_draft.dart:8
- **Confidence:** MEDIUM
- **Evidence:** `StreamSubscription without .cancel()`
- **Description:** A stream listener was established in scratch/test_draft.dart, but no corresponding ".cancel()" call was detected in the file.
- **Risk:** Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.
- **Recommendation:** Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential StreamSubscription Memory Leak
- **File:** lib/tools/scanners_and_audit_reports/run_runtime_perf.dart:30
- **Confidence:** MEDIUM
- **Evidence:** `StreamSubscription without .cancel()`
- **Description:** A stream listener was established in lib/tools/scanners_and_audit_reports/run_runtime_perf.dart, but no corresponding ".cancel()" call was detected in the file.
- **Risk:** Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.
- **Recommendation:** Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential Timer Memory Leak
- **File:** lib/tools/runtime_perf_check/perf_dashboard_html.dart:364
- **Confidence:** MEDIUM
- **Evidence:** `Timer instantiated without .cancel()`
- **Description:** A Timer (or Timer.periodic) is created in lib/tools/runtime_perf_check/perf_dashboard_html.dart, but no ".cancel()" call was found.
- **Risk:** Periodic timers keep running in the background and prevent garbage collection of their callback contexts, leading to memory and CPU leaks.
- **Recommendation:** Keep a reference to the Timer and cancel it inside the dispose() or onClose() methods.
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential StreamSubscription Memory Leak
- **File:** lib/tools/runtime_perf_check/perf_server.dart:47
- **Confidence:** MEDIUM
- **Evidence:** `StreamSubscription without .cancel()`
- **Description:** A stream listener was established in lib/tools/runtime_perf_check/perf_server.dart, but no corresponding ".cancel()" call was detected in the file.
- **Risk:** Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.
- **Recommendation:** Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential Timer Memory Leak
- **File:** lib/tools/runtime_perf_check/client_integration.dart:122
- **Confidence:** MEDIUM
- **Evidence:** `Timer instantiated without .cancel()`
- **Description:** A Timer (or Timer.periodic) is created in lib/tools/runtime_perf_check/client_integration.dart, but no ".cancel()" call was found.
- **Risk:** Periodic timers keep running in the background and prevent garbage collection of their callback contexts, leading to memory and CPU leaks.
- **Recommendation:** Keep a reference to the Timer and cancel it inside the dispose() or onClose() methods.
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential StreamSubscription Memory Leak
- **File:** templates/shared/utils/helper/deep_link_helper.dart:78
- **Confidence:** MEDIUM
- **Evidence:** `StreamSubscription without .cancel()`
- **Description:** A stream listener was established in templates/shared/utils/helper/deep_link_helper.dart, but no corresponding ".cancel()" call was detected in the file.
- **Risk:** Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.
- **Recommendation:** Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential StreamSubscription Memory Leak
- **File:** templates/shared/utils/helper/notification_sender_helper.dart:145
- **Confidence:** MEDIUM
- **Evidence:** `StreamSubscription without .cancel()`
- **Description:** A stream listener was established in templates/shared/utils/helper/notification_sender_helper.dart, but no corresponding ".cancel()" call was detected in the file.
- **Risk:** Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.
- **Recommendation:** Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().
- **Fix Available:** No
---

### [MEMORY] [MEDIUM] Potential StreamSubscription Memory Leak
- **File:** templates/shared/utils/helper/connectivity.dart:25
- **Confidence:** MEDIUM
- **Evidence:** `StreamSubscription without .cancel()`
- **Description:** A stream listener was established in templates/shared/utils/helper/connectivity.dart, but no corresponding ".cancel()" call was detected in the file.
- **Risk:** Active stream subscriptions retain references to listeners and context, which can keep widgets/controllers in memory forever if not canceled when no longer needed.
- **Recommendation:** Store the StreamSubscription in a variable and call subscription.cancel() in dispose() or onClose().
- **Fix Available:** No
---

### [MEMORY] [HIGH] Potential Memory Leak: Un-disposed TextEditingController
- **File:** templates/shared/common/reusable_component/dialogs/dispute_dialog.dart:15
- **Confidence:** MEDIUM
- **Evidence:** `TextEditingController created without .dispose()`
- **Description:** A TextEditingController was created in templates/shared/common/reusable_component/dialogs/dispute_dialog.dart but there is no call to dispose() in the class.
- **Risk:** Failing to dispose controllers leaves native observers and resources registered, causing severe memory leaks in the app.
- **Recommendation:** Override the dispose() method in State or GetxController/BLoC and call controller.dispose().
- **Fix Available:** No
---

### [MEMORY] [HIGH] Potential Memory Leak: Un-disposed ScrollController
- **File:** templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:39
- **Confidence:** MEDIUM
- **Evidence:** `ScrollController created without .dispose()`
- **Description:** A ScrollController was created in templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart but there is no call to dispose() in the class.
- **Risk:** Failing to dispose controllers leaves native observers and resources registered, causing severe memory leaks in the app.
- **Recommendation:** Override the dispose() method in State or GetxController/BLoC and call controller.dispose().
- **Fix Available:** No
---

### [PERFORMANCE] [MEDIUM] Use of Static ListView Instead of Lazy ListView.builder
- **File:** lib/performance/performance_engine.dart:100
- **Confidence:** HIGH
- **Evidence:** `description: 'Using "ListView(children: ...)" instead of "ListView.builder(...)".',`
- **Description:** Using "ListView(children: ...)" instead of "ListView.builder(...)".
- **Risk:** A standard ListView instantiates all children items at once, regardless of whether they are visible on screen, causing memory pressure and rendering delays for long lists.
- **Recommendation:** Refactor to "ListView.builder(...)" to enable lazy-loading and item recycling for better scrolling performance.
- **Fix Available:** No
---

### [PERFORMANCE] [HIGH] Controller Instantiation Inside Widget build() Method
- **File:** templates/shared/common/reusable_component/widgets/app_text_form_field.dart:38
- **Confidence:** MEDIUM
- **Evidence:** `Controller instantiated inside build(...) method`
- **Description:** A controller is created inside the build() method of a widget in templates/shared/common/reusable_component/widgets/app_text_form_field.dart.
- **Risk:** Controllers will be re-instantiated on every single widget build/rebuild, resetting their states and causing CPU spikes/memory leaks.
- **Recommendation:** Convert the widget to a StatefulWidget and instantiate controllers in initState() and dispose them in dispose().
- **Fix Available:** No
---

### [PERFORMANCE] [HIGH] Controller Instantiation Inside Widget build() Method
- **File:** templates/shared/common/reusable_component/widgets/custom_dropdown/dropdown_overlay/dropdown_overlay.dart:109
- **Confidence:** MEDIUM
- **Evidence:** `Controller instantiated inside build(...) method`
- **Description:** A controller is created inside the build() method of a widget in templates/shared/common/reusable_component/widgets/custom_dropdown/dropdown_overlay/dropdown_overlay.dart.
- **Risk:** Controllers will be re-instantiated on every single widget build/rebuild, resetting their states and causing CPU spikes/memory leaks.
- **Recommendation:** Convert the widget to a StatefulWidget and instantiate controllers in initState() and dispose them in dispose().
- **Fix Available:** No
---

### [PERFORMANCE] [HIGH] Controller Instantiation Inside Widget build() Method
- **File:** templates/shared/common/reusable_component/widgets/custom_dropdown/dropdown_overlay/widgets/items_list.dart:25
- **Confidence:** MEDIUM
- **Evidence:** `Controller instantiated inside build(...) method`
- **Description:** A controller is created inside the build() method of a widget in templates/shared/common/reusable_component/widgets/custom_dropdown/dropdown_overlay/widgets/items_list.dart.
- **Risk:** Controllers will be re-instantiated on every single widget build/rebuild, resetting their states and causing CPU spikes/memory leaks.
- **Recommendation:** Convert the widget to a StatefulWidget and instantiate controllers in initState() and dispose them in dispose().
- **Fix Available:** No
---

### [PERFORMANCE] [HIGH] Controller Instantiation Inside Widget build() Method
- **File:** templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:69
- **Confidence:** MEDIUM
- **Evidence:** `Controller instantiated inside build(...) method`
- **Description:** A controller is created inside the build() method of a widget in templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart.
- **Risk:** Controllers will be re-instantiated on every single widget build/rebuild, resetting their states and causing CPU spikes/memory leaks.
- **Recommendation:** Convert the widget to a StatefulWidget and instantiate controllers in initState() and dispose them in dispose().
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Excessively Long File (Class Size)
- **File:** bin/server.dart:1
- **Confidence:** HIGH
- **Evidence:** `Lines count: 1238`
- **Description:** The file bin/server.dart is longer than 500 lines.
- **Risk:** Large files indicate bloated classes that violate the Single Responsibility Principle, making maintaining, testing, and understanding the code difficult.
- **Recommendation:** Break down the class or widgets into smaller, modular helper components or service classes.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Excessively Long File (Class Size)
- **File:** lib/tools/runtime_perf_check/perf_pdf_generator.dart:1
- **Confidence:** HIGH
- **Evidence:** `Lines count: 587`
- **Description:** The file lib/tools/runtime_perf_check/perf_pdf_generator.dart is longer than 500 lines.
- **Risk:** Large files indicate bloated classes that violate the Single Responsibility Principle, making maintaining, testing, and understanding the code difficult.
- **Recommendation:** Break down the class or widgets into smaller, modular helper components or service classes.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Excessively Long File (Class Size)
- **File:** lib/tools/runtime_perf_check/perf_dashboard_html.dart:1
- **Confidence:** HIGH
- **Evidence:** `Lines count: 815`
- **Description:** The file lib/tools/runtime_perf_check/perf_dashboard_html.dart is longer than 500 lines.
- **Risk:** Large files indicate bloated classes that violate the Single Responsibility Principle, making maintaining, testing, and understanding the code difficult.
- **Recommendation:** Break down the class or widgets into smaller, modular helper components or service classes.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Excessively Long File (Class Size)
- **File:** templates/shared/common/reusable_component/toast/flushbar.dart:1
- **Confidence:** HIGH
- **Evidence:** `Lines count: 791`
- **Description:** The file templates/shared/common/reusable_component/toast/flushbar.dart is longer than 500 lines.
- **Risk:** Large files indicate bloated classes that violate the Single Responsibility Principle, making maintaining, testing, and understanding the code difficult.
- **Recommendation:** Break down the class or widgets into smaller, modular helper components or service classes.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Excessively Long File (Class Size)
- **File:** templates/shared/common/reusable_component/widgets/common_debit_card.dart:1
- **Confidence:** HIGH
- **Evidence:** `Lines count: 532`
- **Description:** The file templates/shared/common/reusable_component/widgets/common_debit_card.dart is longer than 500 lines.
- **Risk:** Large files indicate bloated classes that violate the Single Responsibility Principle, making maintaining, testing, and understanding the code difficult.
- **Recommendation:** Break down the class or widgets into smaller, modular helper components or service classes.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Pending TODO / FIXME Comment
- **File:** templates/shared/common/reusable_component/widgets/keyboard_config.dart:3
- **Confidence:** HIGH
- **Evidence:** `// TODO in future remove`
- **Description:** Found a developer note: "in future remove"
- **Risk:** Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.
- **Recommendation:** Address the TODO item or track it in your team's issue management system.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Pending TODO / FIXME Comment
- **File:** templates/shared/common/reusable_component/widgets/web_view.dart:23
- **Confidence:** HIGH
- **Evidence:** `// TODO: implement initState`
- **Description:** Found a developer note: "implement initState"
- **Risk:** Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.
- **Recommendation:** Address the TODO item or track it in your team's issue management system.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Pending TODO / FIXME Comment
- **File:** templates/shared/common/reusable_component/widgets/trasaction_lists/common_trsaction_list_bloc.dart:8
- **Confidence:** HIGH
- **Evidence:** `// TODO: implement dispose`
- **Description:** Found a developer note: "implement dispose"
- **Risk:** Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.
- **Recommendation:** Address the TODO item or track it in your team's issue management system.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Excessively Long File (Class Size)
- **File:** templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:1
- **Confidence:** HIGH
- **Evidence:** `Lines count: 766`
- **Description:** The file templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart is longer than 500 lines.
- **Risk:** Large files indicate bloated classes that violate the Single Responsibility Principle, making maintaining, testing, and understanding the code difficult.
- **Recommendation:** Break down the class or widgets into smaller, modular helper components or service classes.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Pending TODO / FIXME Comment
- **File:** templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:64
- **Confidence:** HIGH
- **Evidence:** `// TODO: implement initState`
- **Description:** Found a developer note: "implement initState"
- **Risk:** Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.
- **Recommendation:** Address the TODO item or track it in your team's issue management system.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Pending TODO / FIXME Comment
- **File:** templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:523
- **Confidence:** HIGH
- **Evidence:** `// TODO remove +/- symbol removed`
- **Description:** Found a developer note: "remove +/- symbol removed"
- **Risk:** Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.
- **Recommendation:** Address the TODO item or track it in your team's issue management system.
- **Fix Available:** No
---

### [CODE_QUALITY] [LOW] Pending TODO / FIXME Comment
- **File:** templates/shared/common/reusable_component/widgets/trasaction_lists/common_transaction_list.dart:570
- **Confidence:** HIGH
- **Evidence:** `//TODO: Sprint 2`
- **Description:** Found a developer note: "Sprint 2"
- **Risk:** Unresolved TODOs represent technical debt, legacy code shortcuts, or features left incomplete before push to production.
- **Recommendation:** Address the TODO item or track it in your team's issue management system.
- **Fix Available:** No
---
