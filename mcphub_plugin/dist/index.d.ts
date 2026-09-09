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
    category: "SECURITY" | "MEMORY" | "PERFORMANCE" | "CODE_QUALITY" | "ARCHITECTURE";
    severity: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW" | "INFO";
    confidence: "HIGH" | "MEDIUM" | "LOW";
    title: string;
    file: string;
    line: number;
    evidence?: string;
    description: string;
    risk: string;
    recommendation: string;
    fixAvailable: boolean;
    proposedFix?: string;
}
export interface SecurityScore {
    finalScore: number;
    riskLevel: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW" | "EXCELLENT";
    explanation: string;
}
export interface ProjectMetadata {
    projectName: string;
    technology: string;
    detectedArchitecture: string;
    detectedStateManagement?: string;
    hasFirebase: boolean;
    hasSupabase: boolean;
    packageCount: number;
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
export declare const ALL_TOOLS: Tool[];
export default class NicFlutterStructureArchitect {
    readonly name = "nic-flutter-structure-architect";
    readonly displayName = "NIC Flutter & Multi-Tech Architect";
    readonly display_name = "NIC Flutter & Multi-Tech Architect";
    readonly title = "NIC Flutter & Multi-Tech Architect";
    readonly version = "1.0.7";
    readonly description = "Multi-technology codebase auditor for Flutter, Vue projects.";
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
