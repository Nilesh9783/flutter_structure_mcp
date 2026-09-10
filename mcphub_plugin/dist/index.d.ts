import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { z } from "zod";
export interface Tool {
    name: string;
    description: string;
    inputSchema: {
        type: "object";
        properties?: Record<string, any>;
        required?: string[];
    };
}
export interface Finding {
    id: string;
    category: "SECURITY" | "MEMORY" | "PERFORMANCE" | "CODE_QUALITY" | "ARCHITECTURE" | "DEPENDENCY";
    severity: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW" | "INFO";
    confidence: "HIGH" | "MEDIUM" | "LOW";
    title: string;
    file: string;
    line: number;
    evidence: string;
    description: string;
    risk: string;
    recommendation: string;
    fixAvailable: boolean;
    suggestedFix?: string;
    claudePrompt?: string;
}
export interface SecurityScoreDetails {
    rawScore: number;
    finalScore: number;
    criticalCount: number;
    highCount: number;
    mediumCount: number;
    lowCount: number;
    riskLevel: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW" | "EXCELLENT";
    explanation: string;
}
export interface ProjectMetadata {
    projectName: string;
    technology: string;
    technologyId: string;
    flutterVersion: string;
    dartVersion: string;
    detectedArchitecture: string;
    detectedStateManagement: string;
    detectedDatabase: string;
    detectedRouter: string;
    detectedNetwork: string;
    targetPlatforms: string[];
    hasFirebase: boolean;
    hasSupabase: boolean;
    packageCount: number;
}
export declare class PathUtils {
    static resolveSafePath(rawPath?: string): string;
}
export declare const AUDIT_CRITERIA: Array<{
    id: string;
    category: string;
    name: string;
    check: string;
    type: string;
    threshold: string;
    severity: string;
}>;
export declare class SolutionGenerator {
    static attachSolutionAndPrompt(finding: Finding): Finding;
    static generateSuggestedFix(finding: Finding): string;
    static generateClaudePrompt(finding: Finding, suggestedFix?: string): string;
    static generateMasterClaudePrompt(findings: Finding[]): string;
}
export declare class SecretScanner {
    private static patterns;
    static scan(projectPath: string): Finding[];
}
export declare class AndroidScanner {
    static scan(projectPath: string): Finding[];
}
export declare class IosScanner {
    static scan(projectPath: string): Finding[];
}
export declare class MemoryScanner {
    static scan(projectPath: string): Finding[];
}
export declare class PerformanceScanner {
    static scan(projectPath: string): Finding[];
}
export declare class CodeQualityScanner {
    static scan(projectPath: string): Finding[];
}
export declare class ProjectDetector {
    static detect(projectPath: string): ProjectMetadata;
}
export declare function calculateScore(findings: Finding[]): SecurityScoreDetails;
export declare class FullReportGenerator {
    static generateAllReports(projectPath: string, meta: ProjectMetadata, findings: Finding[], score: SecurityScoreDetails): Promise<{
        html: string;
        pdfHtml: string;
        json: string;
        markdown: string;
    }>;
    static generateMarkdown(meta: ProjectMetadata, findings: Finding[], score: SecurityScoreDetails): string;
    static generateInteractiveHtml(meta: ProjectMetadata, findings: Finding[], score: SecurityScoreDetails): string;
    static generatePdfHtml(meta: ProjectMetadata, findings: Finding[], score: SecurityScoreDetails): string;
}
export declare const ALL_TOOLS: Tool[];
export default class NicFlutterStructureArchitect {
    readonly name = "nic-flutter-structure-architect";
    readonly displayName = "NIC Flutter & Multi-Tech Architect";
    readonly display_name = "NIC Flutter & Multi-Tech Architect";
    readonly title = "NIC Flutter & Multi-Tech Architect";
    readonly version = "1.0.8";
    readonly description = "Multi-technology codebase auditor for Flutter, Vue projects with interactive tabbed HTML reports.";
    readonly tools: Tool[];
    private config;
    private sensitiveConfig;
    constructor();
    getConfigSchema(): z.ZodObject<any>;
    getSensitiveConfigFields(): string[];
    getConfigMeta(): Record<string, any>;
    healthCheck(): Promise<{
        status: string;
        version: string;
        timestamp: string;
    }>;
    initialize(context?: any): Promise<void>;
    init(context?: any): Promise<void>;
    setup(context?: any): Promise<void>;
    start(context?: any): Promise<void>;
    destroy(): Promise<void>;
    shutdown(): Promise<void>;
    cleanup(): Promise<void>;
    getTools(): Tool[];
    listTools(): Promise<{
        tools: Tool[];
    }>;
    handleToolCall(name: string, args?: Record<string, any>): Promise<{
        content: Array<{
            type: string;
            text: string;
        }>;
        isError?: boolean;
    }>;
    callTool(name: string, args?: Record<string, any>): Promise<{
        content: Array<{
            type: string;
            text: string;
        }>;
        isError?: boolean;
    }>;
    execute(name: string, args?: Record<string, any>): Promise<{
        content: Array<{
            type: string;
            text: string;
        }>;
        isError?: boolean;
    }>;
    executeTool(name: string, args?: Record<string, any>): Promise<{
        content: Array<{
            type: string;
            text: string;
        }>;
        isError?: boolean;
    }>;
    startServer(): Promise<Server>;
}
