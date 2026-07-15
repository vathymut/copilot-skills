# Use the catalog

This tutorial walks through installing a skill from an upstream source, invoking a local skill, and running an agent.

## What you will learn

- How to install a skill from GitHub into this catalog
- How to invoke a skill in GitHub Copilot Chat
- How to invoke a skill in OpenCode
- How to invoke an agent in GitHub Copilot Chat

## Before you start

Complete [Install the catalog](./install.md) first. You should have:

- This repository cloned locally
- `.github/skills` and `.github/agents` symlinked into `~/.copilot` for Copilot
- `.github/skills` symlinked into `~/.config/opencode/skills` for OpenCode

## Install a skill from an upstream repository

Many skills are published in repositories that follow a `skills/<name>/` layout. Clone the source repo and copy the skill directory in:

```bash
# From the official GitHub catalog
gh repo clone github/awesome-copilot /tmp/awesome-copilot
cp -r /tmp/awesome-copilot/skills/<skill-name> .github/skills/<skill-name>

# From other known sources
gh repo clone anthropics/skills /tmp/anthropics-skills
cp -r /tmp/anthropics-skills/skills/<skill-name> .github/skills/<skill-name>
```

To see what skills are available upstream before installing:

```bash
gh api repos/<owner>/<repo>/contents/skills --jq '.[].name'
```

Some source repos use non-standard paths. In those cases, fetch the source subpath manually and copy it into `.github/skills/<skill-name>/`.

## Invoke a skill in GitHub Copilot Chat

1. Open Copilot Chat in VS Code (`Ctrl+Alt+I` / `Cmd+Ctrl+I`).
2. Type `@<skill-name> <your request>`.

For example:

```text
@documentation-writer Help me write a getting-started tutorial for a new ML project.
```

Copilot loads the skill's `SKILL.md` and applies its instructions to your request.

## Invoke a skill in OpenCode

In OpenCode, type:

```text
/<skill-name> your request
# or
@<skill-name> your request
```

For example:

```text
/documentation-writer Help me write a getting-started tutorial for a new ML project.
```

OpenCode reads the same `SKILL.md` file as Copilot, ignoring the GitHub-specific frontmatter.

## Run an agent in GitHub Copilot Chat

Agents are invoked with `@<agent-name>` and are given a goal rather than a single task.

1. Open Copilot Chat.
2. Type `@debug` followed by the problem description.

For example:

```text
@debug My pytest suite fails with a missing module error after I moved a file.
```

The `debug` agent will investigate your codebase, propose fixes, and run tests if you approve.

## Daily workflow

After the first setup, the most common actions are:

| Action | Command |
|---|---|
| Count local skills | `find .github/skills -mindepth 1 -maxdepth 1 -type d | wc -l` |
| List skill entry files | `find .github/skills -name SKILL.md` |
| List agents | `find .github/agents -name '*.agent.md'` |
| Add a skill manually | `mkdir -p .github/skills/<skill-name>` then add `SKILL.md` |
| Remove a skill | `rm -rf .github/skills/<skill-name>` |

For procedures that change the catalog—adding, removing, or syncing skills—see [Maintain the catalog](./maintain.md).
