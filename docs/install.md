# Install the catalog

This guide makes this repository the single source of truth for skills and agents in both GitHub Copilot and OpenCode.

## Prerequisites

- GitHub Copilot is enabled in VS Code.
- The GitHub CLI (`gh`) is installed and authenticated.
- OpenCode is installed and on your path.

## Install for GitHub Copilot

Make the catalog globally available across all VS Code sessions by symlinking the repo contents into `~/.copilot`.

### macOS and Linux

```bash
mkdir -p "$HOME/.copilot"
rm -rf "$HOME/.copilot/skills" "$HOME/.copilot/agents" "$HOME/.copilot/instructions"
ln -s "$PWD/.github/skills" "$HOME/.copilot/skills"
ln -s "$PWD/.github/agents" "$HOME/.copilot/agents"
ln -s "$PWD/.github/instructions" "$HOME/.copilot/instructions"
```

### Windows

Run as Administrator, replacing `<repo-path>` with the absolute path to this repository:

```cmd
if not exist "%USERPROFILE%\.copilot" mkdir "%USERPROFILE%\.copilot"
rmdir /S /Q "%USERPROFILE%\.copilot\skills"
rmdir /S /Q "%USERPROFILE%\.copilot\agents"
rmdir /S /Q "%USERPROFILE%\.copilot\instructions"
mklink /D "%USERPROFILE%\.copilot\skills" "<repo-path>\.github\skills"
mklink /D "%USERPROFILE%\.copilot\agents" "<repo-path>\.github\agents"
mklink /D "%USERPROFILE%\.copilot\instructions" "<repo-path>\.github\instructions"
```

> [!TIP]
> Enable `chat.useCustomizationsInParentRepositories` in VS Code so Copilot can also discover customizations from a parent repository. See the [VS Code customization docs](https://code.visualstudio.com/docs/copilot/customization/overview#_parent-repository-discovery).

## Install for OpenCode

OpenCode discovers skills, agents, and instructions from `~/.config/opencode/`, `.opencode/`, `.claude/`, and `.agents/` directories.

### Skills

Symlink the skills directory:

```bash
mkdir -p "$HOME/.config/opencode"
ln -sfn "$PWD/.github/skills" "$HOME/.config/opencode/skills"
```

Verify discovery:

```bash
opencode debug skill | rg '"name":'
```

All 73 skills in this catalog load in OpenCode without modification. OpenCode uses `name` and `description` frontmatter and ignores the GitHub Copilot fields.

### Agents

> [!CAUTION]
> Do **not** symlink `.github/agents/` into OpenCode. Copilot `.agent.md` frontmatter uses `tools` and `name`, which OpenCode cannot parse. Create agents individually in OpenCode format instead.

Use the interactive command:

```bash
opencode agent create
```

Choose **global** when asked where to save. To reuse the prompt from a Copilot agent, read the matching `.github/agents/*.agent.md` file and translate the content into OpenCode format.

### Instructions

Reference this repo's instructions in `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["/path/to/this/repo/.github/instructions/*.md"]
}
```

Or symlink the directory:

```bash
ln -sfn "$PWD/.github/instructions" "$HOME/.config/opencode/instructions"
```

For other configuration options, see the [OpenCode config documentation](https://opencode.ai/docs/config).

## Next steps

- [Invoke your first skill and agent](./use.md)
- [Learn how the catalog is organized](./architecture.md)
