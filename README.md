# 🤖 Copilot Agent Skills

A curated local collection of all **307 agent skills** from [`github/awesome-copilot`](https://github.com/github/awesome-copilot).
Each skill lives in `skills/<name>/` and contains a `SKILL.md` with detailed instructions.

## 📦 Installation

Install any skill via GitHub CLI:
```bash
gh skill install github/awesome-copilot <skill-name>
```
> Requires GitHub CLI v2.90.0+ with the `gh-skill` extension.

## 🗂 Categories

- [GitHub / Git Workflow (25)](#github--git-workflow)
- [Azure / Cloud (15)](#azure--cloud)
- [AI / Agents / MCP (30)](#ai--agents--mcp)
- [MCP Server Generators (10)](#mcp-server-generators)
- [Frontend / React / Web (23)](#frontend--react--web)
- [C# / .NET (20)](#c#--net)
- [Java / Spring Boot (11)](#java--spring-boot)
- [Python (9)](#python)
- [Databases (22)](#databases)
- [Security & Compliance (3)](#security--compliance)
- [Documentation & Planning (44)](#documentation--planning)
- [DevOps / CI/CD (4)](#devops--cicd)
- [Productivity & Communication (9)](#productivity--communication)
- [Diagrams & Visualization (3)](#diagrams--visualization)
- [Copilot / VS Code (8)](#copilot--vs-code)
- [Power Platform / M365 (17)](#power-platform--m365)
- [Salesforce (3)](#salesforce)
- [GTM / Business Strategy (11)](#gtm--business-strategy)
- [Arize AI Observability (9)](#arize-ai-observability)
- [Other (31)](#other)

---

## GitHub / Git Workflow

| Skill | Description |
|-------|-------------|
| `codeql` | Comprehensive guide for setting up and configuring CodeQL code scanning via GitHub Actions workflows and the CodeQL CLI. |
| `conventional-commit` | Prompt and workflow for generating conventional commit messages using a structured XML format. |
| `copilot-usage-metrics` | Retrieve and display GitHub Copilot usage metrics for organizations and enterprises using the GitHub CLI and REST API. |
| `create-agentsmd` | Prompt for generating an AGENTS. |
| `create-github-action-workflow-specification` | Create a formal specification for an existing GitHub Actions CI/CD workflow, optimized for AI consumption and workflow maintenance. |
| `create-github-issue-feature-from-specification` | Create GitHub Issue for feature request from specification file using feature_request. |
| `create-github-issues-feature-from-implementation-plan` | Create GitHub Issues from implementation plan phases using feature_request. |
| `create-github-issues-for-unmet-specification-requirements` | Create GitHub Issues for unimplemented requirements from specification files using feature_request. |
| `create-github-pull-request-from-specification` | Create GitHub Pull Request for feature request from specification file using pull_request_template. |
| `dependabot` | Comprehensive guide for configuring and managing GitHub Dependabot. |
| `gh-cli` | GitHub CLI (gh) comprehensive reference for repositories, issues, pull requests, Actions, projects, releases, gists, codespaces, organizations, extensions, and all GitHub operations from the command line. |
| `git-commit` | Execute git commit with conventional commit message analysis, intelligent staging, and message generation. |
| `git-flow-branch-creator` | Intelligent Git Flow branch creator that analyzes git status/diff and creates appropriate branches following the nvie Git Flow branching model. |
| `github-copilot-starter` | Set up complete GitHub Copilot configuration for a new project based on technology stack. |
| `github-issues` | Create, update, and manage GitHub issues using MCP tools. |
| `issue-fields-migration` | Bulk-migrate metadata to GitHub issue fields from two sources: repo labels (e. |
| `make-repo-contribution` | All changes to code must follow the guidance documented in the repository. |
| `my-issues` | List my issues in the current repository. |
| `my-pull-requests` | List my pull requests in the current repository. |
| `publish-to-pages` | Publish presentations and web content to GitHub Pages. |
| `repo-story-time` | Generate a comprehensive repository summary and narrative story from commit history. |
| `secret-scanning` | Guide for configuring and managing GitHub secret scanning, push protection, custom patterns, and secret alert remediation. |
| `suggest-awesome-github-copilot-agents` | Suggest relevant GitHub Copilot Custom Agents files from the awesome-copilot repository based on current repository context and chat history, avoiding duplicates with existing custom agents in this repository, and identifying outdated agents that need updates. |
| `suggest-awesome-github-copilot-instructions` | Suggest relevant GitHub Copilot instruction files from the awesome-copilot repository based on current repository context and chat history, avoiding duplicates with existing instructions in this repository, and identifying outdated instructions that need updates. |
| `suggest-awesome-github-copilot-skills` | Suggest relevant GitHub Copilot skills from the awesome-copilot repository based on current repository context and chat history, avoiding duplicates with existing skills in this repository, and identifying outdated skills that need updates. |

## Azure / Cloud

| Skill | Description |
|-------|-------------|
| `appinsights-instrumentation` | Instrument a webapp to send useful telemetry data to Azure App Insights. |
| `az-cost-optimize` | Analyze Azure resources used in the app (IaC files and/or resources in a target rg) and optimize costs - creating GitHub issues for identified optimizations. |
| `azure-architecture-autopilot` | Design Azure infrastructure using natural language, or analyze existing Azure resources to auto-generate architecture diagrams, refine them through conversation, and deploy with Bicep. |
| `azure-deployment-preflight` | Performs comprehensive preflight validation of Bicep deployments to Azure, including template syntax validation, what-if analysis, and permission checks. |
| `azure-devops-cli` | Manage Azure DevOps resources via CLI including projects, repos, pipelines, builds, pull requests, work items, artifacts, and service endpoints. |
| `azure-pricing` | Fetches real-time Azure retail pricing using the Azure Retail Prices API (prices. |
| `azure-resource-health-diagnose` | Analyze Azure resource health, diagnose issues from logs and telemetry, and create a remediation plan for identified problems. |
| `azure-resource-visualizer` | Analyze Azure resource groups and generate detailed Mermaid architecture diagrams showing the relationships between individual resources. |
| `azure-role-selector` | When user is asking for guidance for which role to assign to an identity given desired permissions, this agent helps them understand the role that will meet the requirements with least privilege access and how to apply that role. |
| `azure-static-web-apps` | Helps create, configure, and deploy Azure Static Web Apps using the SWA CLI. |
| `cloud-design-patterns` | Cloud design patterns for distributed systems architecture covering 42 industry-standard patterns across reliability, performance, messaging, security, and deployment categories. |
| `foundry-agent-sync` | Create and synchronize prompt-based AI agents directly within Azure AI Foundry via REST API, from a local JSON manifest. |
| `import-infrastructure-as-code` | Import existing Azure resources into Terraform using Azure CLI discovery and Azure Verified Modules (AVM). |
| `terraform-azurerm-set-diff-analyzer` | Analyze Terraform plan JSON output for AzureRM Provider to distinguish between false-positive diffs (order-only changes in Set-type attributes) and actual resource changes. |
| `update-avm-modules-in-bicep` | Update Azure Verified Modules (AVM) to latest versions in Bicep files. |

## AI / Agents / MCP

| Skill | Description |
|-------|-------------|
| `agent-governance` | Patterns and techniques for adding governance, safety, and trust controls to AI agent systems. |
| `agent-owasp-compliance` | Check any AI agent codebase against the OWASP Agentic Security Initiative (ASI) Top 10 risks. |
| `agent-supply-chain` | Verify supply chain integrity for AI agent plugins, tools, and dependencies. |
| `agentic-eval` | Patterns and techniques for evaluating and improving AI agent outputs. |
| `ai-prompt-engineering-safety-review` | Comprehensive AI prompt engineering safety review and improvement prompt. |
| `autoresearch` | Autonomous iterative experimentation loop for any programming task. |
| `boost-prompt` | Interactive prompt refinement workflow: interrogates scope, deliverables, constraints; copies final markdown to clipboard; never writes code. |
| `copilot-sdk` | Build agentic applications with GitHub Copilot SDK. |
| `doublecheck` | Three-layer verification pipeline for AI output. |
| `eval-driven-dev` | Set up eval-based QA for Python LLM applications: instrument the app, build golden datasets, write and run eval tests, and iterate on failures. |
| `finalize-agent-prompt` | Finalize prompt file using the role of an AI agent to polish the prompt for the end user. |
| `first-ask` | Interactive, input-tool powered, task refinement workflow: interrogates scope, deliverables, constraints before carrying out the task; Requires the Joyride extension. |
| `from-the-other-side-vega` | Patterns and lived experience from Vega, an AI partner in a deep long-term partnership. |
| `make-skill-template` | Create new Agent Skills for GitHub Copilot from prompts or by duplicating this template. |
| `mcp-cli` | Interface for MCP (Model Context Protocol) servers via CLI. |
| `mcp-copilot-studio-server-generator` | Generate a complete MCP server implementation optimized for Copilot Studio integration with proper schema constraints and streamable HTTP support. |
| `mcp-security-audit` | Audit MCP (Model Context Protocol) server configurations for security issues. |
| `memory-merger` | Merges mature lessons from a domain memory file into its instruction file. |
| `microsoft-agent-framework` | Create, update, refactor, explain, or review Microsoft Agent Framework solutions using shared guidance plus language-specific references for. |
| `model-recommendation` | Analyze chatmode or prompt files and recommend optimal AI models based on task complexity, required capabilities, and cost-efficiency. |
| `napkin` | Visual whiteboard collaboration for Copilot CLI. |
| `noob-mode` | Plain-English translation layer for non-technical Copilot CLI users. |
| `quality-playbook` | Explore any codebase from scratch and generate six quality artifacts: a quality constitution (QUALITY. |
| `quasi-coder` | Expert 10x engineer skill for interpreting and implementing code from shorthand, quasi-code, and natural language descriptions. |
| `remember` | Transforms lessons learned into domain-organized memory instructions (global or workspace). |
| `remember-interactive-programming` | A micro-prompt that reminds the agent that it is an interactive programmer. |
| `semantic-kernel` | Create, update, refactor, explain, or review Semantic Kernel solutions using shared guidance plus language-specific references for. |
| `structured-autonomy-generate` | Structured Autonomy Implementation Generator Prompt. |
| `structured-autonomy-implement` | Structured Autonomy Implementation Prompt. |
| `structured-autonomy-plan` | Structured Autonomy Planning Prompt. |

## MCP Server Generators

| Skill | Description |
|-------|-------------|
| `csharp-mcp-server-generator` | Generate a complete MCP server project in C# with tools, prompts, and proper configuration. |
| `go-mcp-server-generator` | Generate a complete Go MCP server project with proper structure, dependencies, and implementation using the official github. |
| `java-mcp-server-generator` | Generate a complete Model Context Protocol server project in Java using the official MCP Java SDK with reactive streams and optional Spring Boot integration. |
| `kotlin-mcp-server-generator` | Generate a complete Kotlin MCP server project with proper structure, dependencies, and implementation using the official io. |
| `php-mcp-server-generator` | Generate a complete PHP Model Context Protocol server project with tools, resources, prompts, and tests using the official PHP SDK. |
| `python-mcp-server-generator` | Generate a complete MCP server project in Python with tools, resources, and proper configuration. |
| `ruby-mcp-server-generator` | Generate a complete Model Context Protocol server project in Ruby using the official MCP Ruby SDK gem. |
| `rust-mcp-server-generator` | Generate a complete Rust Model Context Protocol server project with tools, prompts, resources, and tests using the official rmcp SDK. |
| `swift-mcp-server-generator` | Generate a complete Model Context Protocol server project in Swift using the official MCP Swift SDK package. |
| `typescript-mcp-server-generator` | Generate a complete MCP server project in TypeScript with tools, resources, and proper configuration. |

## Frontend / React / Web

| Skill | Description |
|-------|-------------|
| `chrome-devtools` | Expert-level browser automation, debugging, and performance analysis using Chrome DevTools MCP. |
| `game-engine` | Expert skill for building web-based game engines and games using HTML5, Canvas, WebGL, and JavaScript. |
| `gsap-framer-scroll-animation` | Use this skill whenever the user wants to build scroll animations, scroll effects, parallax, scroll-triggered reveals, pinned sections, horizontal scroll, text animations, or any motion tied to scroll position — in vanilla JS, React, or Next. |
| `next-intl-add-language` | Add new language to a Next. |
| `penpot-uiux-design` | Comprehensive guide for creating professional UI/UX designs in Penpot using MCP tools. |
| `playwright-automation-fill-in-form` | Automate filling in a form using Playwright MCP. |
| `playwright-explore-website` | Website exploration for testing using Playwright MCP. |
| `playwright-generate-test` | Generate a Playwright test based on a scenario using Playwright MCP. |
| `premium-frontend-ui` | A comprehensive guide for GitHub Copilot to craft immersive, high-performance web experiences with advanced motion, typography, and architectural craftsmanship. |
| `react-audit-grep-patterns` | Provides the complete, verified grep scan command library for auditing React codebases before a React 18. |
| `react18-batching-patterns` | Provides exact patterns for diagnosing and fixing automatic batching regressions in React 18 class components. |
| `react18-dep-compatibility` | React 18. |
| `react18-enzyme-to-rtl` | Provides exact Enzyme → React Testing Library migration patterns for React 18 upgrades. |
| `react18-legacy-context` | Provides the complete migration pattern for React legacy context API (contextTypes, childContextTypes, getChildContext) to the modern createContext API. |
| `react18-lifecycle-patterns` | Provides exact before/after migration patterns for the three unsafe class component lifecycle methods - componentWillMount, componentWillReceiveProps, and componentWillUpdate - targeting React 18. |
| `react18-string-refs` | Provides exact migration patterns for React string refs (ref="name" + this. |
| `react19-concurrent-patterns` | Preserve React 18 concurrent patterns and adopt React 19 APIs (useTransition, useDeferredValue, Suspense, use(), useOptimistic, Actions) during migration. |
| `react19-source-patterns` | Reference for React 19 source-file migration patterns, including API changes, ref handling, and context updates. |
| `react19-test-patterns` | Provides before/after patterns for migrating test files to React 19 compatibility, including act() imports, Simulate removal, and StrictMode call count changes. |
| `unit-test-vue-pinia` | Write and review unit tests for Vue 3 + TypeScript + Vitest + Pinia codebases. |
| `web-coder` | Expert 10x engineer with comprehensive knowledge of web development, internet protocols, and web standards. |
| `web-design-reviewer` | This skill enables visual inspection of websites running locally or remotely to identify and fix design issues. |
| `webapp-testing` | Toolkit for interacting with and testing local web applications using Playwright. |

## C# / .NET

| Skill | Description |
|-------|-------------|
| `aspire` | Aspire skill covering the Aspire CLI, AppHost orchestration, service discovery, integrations, MCP server, VS Code extension, Dev Containers, GitHub Codespaces, templates, dashboard, and deployment. |
| `aspnet-minimal-api-openapi` | Create ASP. |
| `containerize-aspnet-framework` | Containerize an ASP. |
| `containerize-aspnetcore` | Containerize an ASP. |
| `csharp-async` | Get best practices for C# async programming. |
| `csharp-docs` | Ensure that C# types are documented with XML comments and follow best practices for documentation. |
| `csharp-mstest` | Get best practices for MSTest 3. |
| `csharp-nunit` | Get best practices for NUnit unit testing, including data-driven tests. |
| `csharp-tunit` | Get best practices for TUnit unit testing, including data-driven tests. |
| `csharp-xunit` | Get best practices for XUnit unit testing, including data-driven tests. |
| `dotnet-best-practices` | Ensure. |
| `dotnet-design-pattern-review` | Review the C#/. |
| `dotnet-timezone` |  |
| `dotnet-upgrade` | Ready-to-use prompts for comprehensive. |
| `ef-core` | Get best practices for Entity Framework Core. |
| `fluentui-blazor` | Guide for using the Microsoft Fluent UI Blazor component library (Microsoft. |
| `nuget-manager` | Manage NuGet packages in. |
| `winapp-cli` | Windows App Development CLI (winapp) for building, packaging, and deploying Windows applications. |
| `winmd-api-search` | Find and explore Windows desktop APIs. |
| `winui3-migration-guide` | UWP-to-WinUI 3 migration reference. |

## Java / Spring Boot

| Skill | Description |
|-------|-------------|
| `create-spring-boot-java-project` | Create Spring Boot Java Project Skeleton. |
| `create-spring-boot-kotlin-project` | Create Spring Boot Kotlin Project Skeleton. |
| `java-add-graalvm-native-image-support` | GraalVM Native Image expert that adds native image support to Java applications, builds the project, analyzes build errors, applies fixes, and iterates until successful compilation using Oracle best practices. |
| `java-docs` | Ensure that Java types are documented with Javadoc comments and follow best practices for documentation. |
| `java-junit` | Get best practices for JUnit 5 unit testing, including data-driven tests. |
| `java-refactoring-extract-method` | Refactoring using Extract Methods in Java Language. |
| `java-refactoring-remove-parameter` | Refactoring using Remove Parameter in Java Language. |
| `java-springboot` | Get best practices for developing applications with Spring Boot. |
| `javascript-typescript-jest` | Best practices for writing JavaScript/TypeScript tests using Jest, including mocking strategies, test structure, and common patterns. |
| `kotlin-springboot` | Get best practices for developing applications with Spring Boot and Kotlin. |
| `spring-boot-testing` | Expert Spring Boot 4 testing specialist that selects the best Spring Boot testing techniques for your situation with Junit 6 and AssertJ. |

## Python

| Skill | Description |
|-------|-------------|
| `aws-cdk-python-setup` | Setup and initialization guide for developing AWS CDK (Cloud Development Kit) applications in Python. |
| `datanalysis-credit-risk` | Credit risk data cleaning and variable screening pipeline for pre-loan modeling. |
| `dataverse-python-advanced-patterns` | Generate production code for Dataverse SDK using advanced patterns, error handling, and optimization techniques. |
| `dataverse-python-production-code` | Generate production-ready Python code using Dataverse SDK with error handling, optimization, and best practices. |
| `dataverse-python-quickstart` | Generate Python SDK setup + CRUD + bulk + paging snippets using official patterns. |
| `dataverse-python-usecase-builder` | Generate complete solutions for specific Dataverse SDK use cases with architecture recommendations. |
| `pytest-coverage` | Run pytest tests with coverage, discover lines missing coverage, and increase coverage to 100%. |
| `python-pypi-package-builder` | End-to-end skill for building, testing, linting, versioning, and publishing a production-grade Python library to PyPI. |
| `ruff-recursive-fix` | Run Ruff checks with optional scope and rule overrides, apply safe and unsafe autofixes iteratively, review each change, and resolve remaining findings with targeted edits or user decisions. |

## Databases

| Skill | Description |
|-------|-------------|
| `bigquery-pipeline-audit` | Audits Python + BigQuery pipelines for cost safety, idempotency, and production readiness. |
| `cosmosdb-datamodeling` | Step-by-step guide for capturing key application requirements for NoSQL use-case and produce Azure Cosmos DB Data NoSQL Model design using best practices and common patterns, artifacts_produced: "cosmosdb_requirements. |
| `creating-oracle-to-postgres-master-migration-plan` | Discovers all projects in a. |
| `creating-oracle-to-postgres-migration-bug-report` | Creates structured bug reports for defects found during Oracle-to-PostgreSQL migration. |
| `creating-oracle-to-postgres-migration-integration-tests` | Creates integration test cases for. |
| `migrating-oracle-to-postgres-stored-procedures` | Migrates Oracle PL/SQL stored procedures to PostgreSQL PL/pgSQL. |
| `planning-oracle-to-postgres-migration-integration-testing` | Creates an integration testing plan for. |
| `postgresql-code-review` | PostgreSQL-specific code review assistant focusing on PostgreSQL best practices, anti-patterns, and unique quality standards. |
| `postgresql-optimization` | PostgreSQL-specific development assistant focusing on unique PostgreSQL features, advanced data types, and PostgreSQL-exclusive capabilities. |
| `qdrant-clients-sdk` | Qdrant provides client SDKs for various programming languages, allowing easy integration with Qdrant deployments. |
| `qdrant-deployment-options` | Guides Qdrant deployment selection. |
| `qdrant-model-migration` | Guides embedding model migration in Qdrant without downtime. |
| `qdrant-monitoring` | Guides Qdrant monitoring and observability setup. |
| `qdrant-performance-optimization` | Different techniques to optimize the performance of Qdrant, including indexing strategies, query optimization, and hardware considerations. |
| `qdrant-scaling` | Guides Qdrant scaling decisions. |
| `qdrant-search-quality` | Diagnoses and improves Qdrant search relevance. |
| `qdrant-version-upgrade` | Guidance on how to upgrade your Qdrant version without interrupting the availability of your application and ensuring data integrity. |
| `reviewing-oracle-to-postgres-migration` | Identifies Oracle-to-PostgreSQL migration risks by cross-referencing code against known behavioral differences (empty strings, refcursors, type coercion, sorting, timestamps, concurrent transactions, etc. |
| `scaffolding-oracle-to-postgres-migration-test-project` | Scaffolds an xUnit integration test project for validating Oracle-to-PostgreSQL database migration behavior in. |
| `snowflake-semanticview` | Create, alter, and validate Snowflake semantic views using Snowflake CLI (snow). |
| `sql-code-review` | Universal SQL code review assistant that performs comprehensive security, maintainability, and code quality analysis across all SQL databases (MySQL, PostgreSQL, SQL Server, Oracle). |
| `sql-optimization` | Universal SQL performance optimization assistant for comprehensive query tuning, indexing strategies, and database performance analysis across all SQL databases (MySQL, PostgreSQL, SQL Server, Oracle). |

## Security & Compliance

| Skill | Description |
|-------|-------------|
| `gdpr-compliant` | Apply GDPR-compliant engineering practices across your codebase. |
| `security-review` | AI-powered codebase security scanner that reasons about code like a security researcher — tracing data flows, understanding component interactions, and catching vulnerabilities that pattern-matching tools miss. |
| `threat-model-analyst` | Full STRIDE-A threat model analysis and incremental update skill for repositories and systems. |

## Documentation & Planning

| Skill | Description |
|-------|-------------|
| `acquire-codebase-knowledge` | Use this skill when the user explicitly asks to map, document, or onboard into an existing codebase. |
| `add-educational-comments` | Add educational comments to the file specified, or prompt asking for file to comment if one is not provided. |
| `architecture-blueprint-generator` | Comprehensive project architecture blueprint generator that analyzes codebases to create detailed architectural documentation. |
| `breakdown-epic-arch` | Prompt for creating the high-level technical architecture for an Epic, based on a Product Requirements Document. |
| `breakdown-epic-pm` | Prompt for creating an Epic Product Requirements Document (PRD) for a new epic. |
| `breakdown-feature-implementation` | Prompt for creating detailed feature implementation plans, following Epoch monorepo structure. |
| `breakdown-feature-prd` | Prompt for creating Product Requirements Documents (PRDs) for new features, based on an Epic. |
| `breakdown-plan` | Issue Planning and Automation prompt that generates comprehensive project plans with Epic > Feature > Story/Enabler > Test hierarchy, dependencies, priorities, and automated tracking. |
| `breakdown-test` | Test Planning and Quality Assurance prompt that generates comprehensive test strategies, task breakdowns, and quality validation plans for GitHub projects. |
| `code-exemplars-blueprint-generator` | Technology-agnostic prompt generator that creates customizable AI prompts for scanning codebases and identifying high-quality code exemplars. |
| `code-tour` | Use this skill to create CodeTour. |
| `comment-code-generate-a-tutorial` | Transform this Python script into a polished, beginner-friendly project by refactoring the code, adding clear instructional comments, and generating a complete markdown tutorial. |
| `context-map` | Generate a map of all files relevant to a task before making changes. |
| `convert-plaintext-to-md` | Convert a text-based document to markdown following instructions from prompt, or if a documented option is passed, follow the instructions for that option. |
| `create-architectural-decision-record` | Create an Architectural Decision Record (ADR) document for AI-optimized decision documentation. |
| `create-implementation-plan` | Create a new implementation plan file for new features, refactoring existing code or upgrading packages, design, architecture or infrastructure. |
| `create-llms` | Create an llms. |
| `create-readme` | Create a README. |
| `create-specification` | Create a new specification file for the solution, optimized for Generative AI consumption. |
| `create-technical-spike` | Create time-boxed technical spike documents for researching and resolving critical development decisions before implementation. |
| `create-tldr-page` | Create a tldr page from documentation URLs and command examples, requiring both URL and command name. |
| `documentation-writer` | Diátaxis Documentation Expert. |
| `editorconfig` | Generates a comprehensive and best-practice-oriented. |
| `folder-structure-blueprint-generator` | Comprehensive technology-agnostic prompt for analyzing and documenting project folder structures. |
| `gen-specs-as-issues` | This workflow guides you through a systematic approach to identify missing features, prioritize them, and create detailed specifications for implementation. |
| `generate-custom-instructions-from-codebase` | Migration and code evolution instructions generator for GitHub Copilot. |
| `mkdocs-translations` | Generate a language translation for a mkdocs documentation stack. |
| `oo-component-documentation` | Create or update standardized object-oriented component documentation using a shared template plus mode-specific guidance for new and existing docs. |
| `openapi-to-application-code` | Generate a complete, production-ready application from an OpenAPI specification. |
| `prd` | Generate high-quality Product Requirements Documents (PRDs) for software systems and AI-powered features. |
| `project-workflow-analysis-blueprint-generator` | Comprehensive technology-agnostic prompt generator for documenting end-to-end application workflows. |
| `prompt-builder` | Guide users through creating high-quality GitHub Copilot prompts with proper structure, tools, and best practices. |
| `readme-blueprint-generator` | Intelligent README. |
| `refactor` | Surgical code refactoring to improve maintainability without changing behavior. |
| `refactor-method-complexity-reduce` | Refactor given method `${input:methodName}` to reduce its cognitive complexity to `${input:complexityThreshold}` or below, by extracting helper methods. |
| `refactor-plan` | Plan a multi-file refactor with proper sequencing and rollback steps. |
| `review-and-refactor` | Review and refactor code in your project according to defined instructions. |
| `technology-stack-blueprint-generator` | Comprehensive technology stack blueprint generator that analyzes codebases to create detailed architectural documentation. |
| `tldr-prompt` | Create tldr summaries for GitHub Copilot files (prompts, agents, instructions, collections), MCP servers, or documentation from URLs and queries. |
| `update-implementation-plan` | Update an existing implementation plan file with new or update requirements to provide new features, refactoring existing code or upgrading packages, design, architecture or infrastructure. |
| `update-llms` | Update the llms. |
| `update-markdown-file-index` | Update a markdown file section with an index/table of files from a specified folder. |
| `update-specification` | Update an existing specification file for the solution, optimized for Generative AI consumption based on new requirements or updates to any existing code. |
| `write-coding-standards-from-file` | Write a coding standards document for a project using the coding styles from the file(s) and/or folder(s) passed as arguments in the prompt. |

## DevOps / CI/CD

| Skill | Description |
|-------|-------------|
| `automate-this` | Analyze a screen recording of a manual process and produce targeted, working automation scripts. |
| `devops-rollout-plan` | Generate comprehensive rollout plans with preflight checks, step-by-step deployment, verification signals, rollback procedures, and communication plans for infrastructure and application changes. |
| `multi-stage-dockerfile` | Create optimized multi-stage Dockerfiles for any language or framework. |
| `sandbox-npm-install` | Install npm packages in a Docker sandbox environment. |

## Productivity & Communication

| Skill | Description |
|-------|-------------|
| `daily-prep` | Prepare for tomorrow's meetings and tasks. |
| `email-drafter` | Draft and review professional emails that match your personal writing style. |
| `linkedin-post-formatter` | Format and draft compelling LinkedIn posts using Unicode bold/italic styling, visual separators, structured sections, and engagement-optimized patterns. |
| `meeting-minutes` | Generate concise, actionable meeting minutes for internal meetings. |
| `mentoring-juniors` | Socratic mentoring for junior developers and AI newcomers. |
| `roundup` | Generate personalized status briefings on demand. |
| `roundup-setup` | Interactive onboarding that learns your communication style, audiences, and data sources to configure personalized status briefings. |
| `sponsor-finder` | Find which of a GitHub repository's dependencies are sponsorable via GitHub Sponsors. |
| `workiq-copilot` | Guides the Copilot CLI on how to use the WorkIQ CLI/MCP server to query Microsoft 365 Copilot data (emails, meetings, docs, Teams, people) for live context, summaries, and recommendations. |

## Diagrams & Visualization

| Skill | Description |
|-------|-------------|
| `draw-io-diagram-generator` | Use when creating, editing, or generating draw. |
| `excalidraw-diagram-generator` | Generate Excalidraw diagrams from natural language descriptions. |
| `plantuml-ascii` | Generate ASCII art diagrams using PlantUML text mode. |

## Copilot / VS Code

| Skill | Description |
|-------|-------------|
| `cli-mastery` | Interactive training for the GitHub Copilot CLI. |
| `copilot-cli-quickstart` | Use this skill when someone wants to learn GitHub Copilot CLI from scratch. |
| `copilot-instructions-blueprint-generator` | Technology-agnostic blueprint generator for creating comprehensive copilot-instructions. |
| `copilot-spaces` | Use Copilot Spaces to provide project-specific context to conversations. |
| `lsp-setup` | Enable code intelligence (go-to-definition, find-references, hover, type info) for any programming language by installing and configuring an LSP server for Copilot CLI. |
| `microsoft-skill-creator` | Create agent skills for Microsoft technologies using Learn MCP tools. |
| `vscode-ext-commands` | Guidelines for contributing commands in VS Code extensions. |
| `vscode-ext-localization` | Guidelines for proper localization of VS Code extensions, following VS Code extension development guidelines, libraries and good practices. |

## Power Platform / M365

| Skill | Description |
|-------|-------------|
| `declarative-agents` | Complete development kit for Microsoft 365 Copilot declarative agents with three comprehensive workflows (basic, advanced, validation), TypeSpec support, and Microsoft 365 Agents Toolkit integration. |
| `entra-agent-user` | Create Agent Users in Microsoft Entra ID from Agent Identities, enabling AI agents to act as digital workers with user identity capabilities in Microsoft 365 and Azure environments. |
| `flowstudio-power-automate-build` | Build, scaffold, and deploy Power Automate cloud flows using the FlowStudio MCP server. |
| `flowstudio-power-automate-debug` | Debug failing Power Automate cloud flows using the FlowStudio MCP server. |
| `flowstudio-power-automate-governance` | Govern Power Automate flows and Power Apps at scale using the FlowStudio MCP cached store. |
| `flowstudio-power-automate-mcp` | Give your AI agent the same visibility you have in the Power Automate portal — plus a bit more. |
| `flowstudio-power-automate-monitoring` | Monitor Power Automate flow health, track failure rates, and inventory tenant assets using the FlowStudio MCP cached store. |
| `mcp-create-adaptive-cards` | Skill converted from mcp-create-adaptive-cards. |
| `mcp-create-declarative-agent` | Skill converted from mcp-create-declarative-agent. |
| `mcp-deploy-manage-agents` | Skill converted from mcp-deploy-manage-agents. |
| `power-apps-code-app-scaffold` | Scaffold a complete Power Apps Code App project with PAC CLI setup, SDK integration, and connector configuration. |
| `power-bi-dax-optimization` | Comprehensive Power BI DAX formula optimization prompt for improving performance, readability, and maintainability of DAX calculations. |
| `power-bi-model-design-review` | Comprehensive Power BI data model design review prompt for evaluating model architecture, relationships, and optimization opportunities. |
| `power-bi-performance-troubleshooting` | Systematic Power BI performance troubleshooting prompt for identifying, diagnosing, and resolving performance issues in Power BI models, reports, and queries. |
| `power-bi-report-design-consultation` | Power BI report visualization design prompt for creating effective, user-friendly, and accessible reports with optimal chart selection and layout design. |
| `power-platform-architect` | Use this skill when the user needs to transform business requirements, use case descriptions, or meeting transcripts into a technical Power Platform solution architecture, including component selection and Mermaid. |
| `power-platform-mcp-connector-suite` | Generate complete Power Platform custom connector with MCP integration for Copilot Studio - includes schema generation, troubleshooting, and validation. |

## Salesforce

| Skill | Description |
|-------|-------------|
| `salesforce-apex-quality` | Apex code quality guardrails for Salesforce development. |
| `salesforce-component-standards` | Quality standards for Salesforce Lightning Web Components (LWC), Aura components, and Visualforce pages. |
| `salesforce-flow-design` | Salesforce Flow architecture decisions, flow type selection, bulk safety validation, and fault handling standards. |

## GTM / Business Strategy

| Skill | Description |
|-------|-------------|
| `gtm-0-to-1-launch` | Launch new products from idea to first customers. |
| `gtm-ai-gtm` | Go-to-market strategy for AI products. |
| `gtm-board-and-investor-communication` | Board meeting preparation, investor updates, and executive communication. |
| `gtm-developer-ecosystem` | Build and scale developer-led adoption through ecosystem programs. |
| `gtm-enterprise-account-planning` | Strategic account planning and execution for enterprise deals. |
| `gtm-enterprise-onboarding` | Four-phase framework for onboarding enterprise customers from contract to value realization. |
| `gtm-operating-cadence` | Design meeting rhythms, metric reporting, quarterly planning, and decision-making velocity for scaling companies. |
| `gtm-partnership-architecture` | Build and scale partner ecosystems that drive revenue and platform adoption. |
| `gtm-positioning-strategy` | Find and own a defensible market position. |
| `gtm-product-led-growth` | Build self-serve acquisition and expansion motions. |
| `gtm-technical-product-pricing` | Pricing strategy for technical products. |

## Arize AI Observability

| Skill | Description |
|-------|-------------|
| `arize-ai-provider-integration` | INVOKE THIS SKILL when creating, reading, updating, or deleting Arize AI integrations. |
| `arize-annotation` | INVOKE THIS SKILL when creating, managing, or using annotation configs on Arize (categorical, continuous, freeform), or applying human annotations to project spans via the Python SDK. |
| `arize-dataset` | INVOKE THIS SKILL when creating, managing, or querying Arize datasets and examples. |
| `arize-evaluator` | INVOKE THIS SKILL for LLM-as-judge evaluation workflows on Arize: creating/updating evaluators, running evaluations on spans or experiments, tasks, trigger-run, column mapping, and continuous monitoring. |
| `arize-experiment` | INVOKE THIS SKILL when creating, running, or analyzing Arize experiments. |
| `arize-instrumentation` | INVOKE THIS SKILL when adding Arize AX tracing to an application. |
| `arize-link` | Generate deep links to the Arize UI. |
| `arize-prompt-optimization` | INVOKE THIS SKILL when optimizing, improving, or debugging LLM prompts using production trace data, evaluations, and annotations. |
| `arize-trace` | INVOKE THIS SKILL when downloading or exporting Arize traces and spans. |

## Other

| Skill | Description |
|-------|-------------|
| `apple-appstore-reviewer` | Serves as a reviewer of the codebase with instructions on looking for Apple App Store optimizations or rejection reasons. |
| `arch-linux-triage` | Triage and resolve Arch Linux issues with pacman, systemd, and rolling-release best practices. |
| `centos-linux-triage` | Triage and resolve CentOS issues using RHEL-compatible tooling, SELinux-aware practices, and firewalld. |
| `debian-linux-triage` | Triage and resolve Debian Linux issues with apt, systemd, and AppArmor-aware guidance. |
| `fabric-lakehouse` | Use this skill to get context about Fabric Lakehouse and its features for software systems and AI-powered functions. |
| `fedora-linux-triage` | Triage and resolve Fedora issues with dnf, systemd, and SELinux-aware guidance. |
| `finnish-humanizer` | Detect and remove AI-generated markers from Finnish text, making it sound like a native Finnish speaker wrote it. |
| `freecad-scripts` | Expert skill for writing FreeCAD Python scripts, macros, and automation. |
| `geofeed-tuner` | Use this skill whenever the user mentions IP geolocation feeds, RFC 8805, geofeeds, or wants help creating, tuning, validating, or publishing a self-published IP geolocation feed in CSV format. |
| `image-manipulation-image-magick` | Process and manipulate images using ImageMagick. |
| `integrate-context-matic` | Discovers and integrates third-party APIs using the context-matic MCP server. |
| `legacy-circuit-mockups` | Generate breadboard circuit mockups and visual diagrams using HTML5 Canvas drawing techniques. |
| `markdown-to-html` | Convert Markdown files to HTML similar to `marked. |
| `microsoft-code-reference` | Look up Microsoft API references, find working code samples, and verify SDK code is correct. |
| `microsoft-docs` | Query official Microsoft documentation to find concepts, tutorials, and code examples across Azure,. |
| `msstore-cli` | Microsoft Store Developer CLI (msstore) for publishing Windows applications to the Microsoft Store. |
| `nano-banana-pro-openrouter` | Generate or edit images via OpenRouter with the Gemini 3 Pro Image model. |
| `onboard-context-matic` | Interactive onboarding tour for the context-matic MCP server. |
| `pdftk-server` | Skill for using the command-line tool pdftk (PDFtk Server) for working with PDF files. |
| `phoenix-cli` | Debug LLM applications using the Phoenix CLI. |
| `phoenix-evals` | Build and run evaluators for AI/LLM applications using Phoenix. |
| `phoenix-tracing` | OpenInference semantic conventions and instrumentation for Phoenix AI observability. |
| `polyglot-test-agent` | Generates comprehensive, workable unit tests for any programming language using a multi-agent pipeline. |
| `powerbi-modeling` | Power BI semantic modeling assistant for building optimized data models. |
| `scoutqa-test` | This skill should be used when the user asks to "test this website", "run exploratory testing", "check for accessibility issues", "verify the login flow works", "find bugs on this page", or requests automated QA testing. |
| `shuffle-json-data` | Shuffle repetitive JSON objects safely by validating schema consistency before randomising entries. |
| `transloadit-media-processing` | Process media files (video, audio, images, documents) using Transloadit. |
| `typespec-api-operations` | Add GET, POST, PATCH, and DELETE operations to a TypeSpec API plugin with proper routing, parameters, and adaptive cards. |
| `typespec-create-agent` | Generate a complete TypeSpec declarative agent with instructions, capabilities, and conversation starters for Microsoft 365 Copilot. |
| `typespec-create-api-plugin` | Generate a TypeSpec API plugin with REST operations, authentication, and Adaptive Cards for Microsoft 365 Copilot. |
| `what-context-needed` | Ask Copilot what files it needs to see before answering a question. |

---

## 🔄 Keeping Skills Up to Date

To refresh skills from upstream:
```bash
git -C /tmp/awesome-copilot-temp pull 2>/dev/null || \
  git clone --depth 1 --filter=blob:none --sparse https://github.com/github/awesome-copilot /tmp/awesome-copilot-temp && \
  git -C /tmp/awesome-copilot-temp sparse-checkout set skills
cp -r /tmp/awesome-copilot-temp/skills/* ~/copilot-skills/skills/
```

## 🗑 Removing Unwanted Skills

Simply delete the skill folder and commit:
```bash
rm -rf skills/<skill-name>
git add -A && git commit -m 'chore: remove <skill-name>'
```

_Source: [github/awesome-copilot](https://github.com/github/awesome-copilot)_
