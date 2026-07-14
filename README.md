# copilot-skills

> A curated, versioned local catalog of reusable skills and agents for GitHub Copilot Chat and OpenCode.

The skills and agents here are sourced from upstream repositories and then edited or adapted to better serve my own workflows. See the [catalog reference](./docs/catalog.md) for the full list and provenance.

## Install

Make this repo the canonical source for Copilot and OpenCode customizations.

### GitHub Copilot (macOS/Linux)

```bash
mkdir -p "$HOME/.copilot"
rm -rf "$HOME/.copilot/skills" "$HOME/.copilot/agents" "$HOME/.copilot/instructions"
ln -s "$PWD/.github/skills" "$HOME/.copilot/skills"
ln -s "$PWD/.github/agents" "$HOME/.copilot/agents"
ln -s "$PWD/.github/instructions" "$HOME/.copilot/instructions"
```

### OpenCode

```bash
mkdir -p "$HOME/.config/opencode"
ln -sfn "$PWD/.github/skills" "$HOME/.config/opencode/skills"
```

> [!CAUTION]
> Do **not** symlink `.github/agents/` into OpenCode. Create OpenCode agents individually with `opencode agent create` instead.

For Windows setup, agent translation, instructions wiring, and troubleshooting, see [docs/install.md](./docs/install.md).

## First use

- [Use a skill and an agent for the first time](./docs/use.md)
- [Maintain the catalog over time](./docs/maintain.md)

## Catalog

For the complete list of 73 skills, 3 agents, upstream sources, and how they were adapted, see [docs/catalog.md](./docs/catalog.md).

For how the catalog is organized and how the two tools consume it differently, see [docs/architecture.md](./docs/architecture.md).

## Layout

```text
.github/
  skills/<skill-name>/SKILL.md   # skill definitions
  agents/*.agent.md              # agent definitions
  instructions/                  # shared instructions (optional)
docs/                            # onboarding and operational docs
```
