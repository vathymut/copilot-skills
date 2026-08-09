---
applyTo: "**/*"
description: "Shared issue-tracker and triage-label conventions for ticket-related skills"
---

# Issue tracker conventions

Shared by `to-tickets`, `wayfinder`, and `triage`. Consuming skills point
here instead of restating the convention.

## Resolving the tracker

The issue tracker and triage label vocabulary should have been provided to
you (repo config, harness setup). If no tracker config has been provided,
ask the user where issue tracker config / triage labels come from, or
default to the local-markdown tracker.

## Local-markdown tracker default

When no real tracker is configured, tickets live as local files:

- Location: `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Ticket shape: title, "What to build", "Blocked by", "Status:
  ready-for-agent", acceptance criteria (see `to-tickets` for the template)
- Blocking edges are declared as `Blocked by:` references between files

## External PRs

If this repo treats external pull requests as a request surface (per the
tracker config), triage covers them: a PR is an issue with attached code —
same roles, same states, same machine.
