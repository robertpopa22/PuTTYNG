# CLAUDE.md — PuTTYNG

PuTTYNG is a modified build of [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/) (Simon Tatham) for use with mRemoteNG.
The repository does not carry PuTTY sources: `PuTTYNG.ps1` clones upstream, applies small scripted changes
(`CMDLINE.C`, `PUTTY.H`, `version.h`, `window.c`) and builds with CMake. Output: `putty\Release\PuTTYNG.exe`.

## Build

- Run `PuTTYNG.ps1` (needs git and CMake; Visual Studio Build Tools are supported). Do not hand-edit the cloned `putty\` tree.
- Keep script changes minimal: the fewer upstream files we touch, the easier each upstream release is to follow.

## Upstream pin policy

- The script builds from a pinned upstream release tag (`$Tag` in `PuTTYNG.ps1`, currently `0.85`), never from upstream HEAD.
- Moving the pin is a deliberate change: read the upstream release notes, rebuild, check that the scripted edits still apply, then commit the new tag with a `CHANGELOG.md` entry.

## Working mode with models

Large models (e.g. Fable, Astra; Opus/Sol where justified) do analysis, coordination, architecture decisions and counter-opinions; execution (mechanical implementation, repeatable checks, builds) goes to smaller models (Sonnet, Luna, Haiku), with Opus/Sol only for steps that need heavy judgement. Nothing is fixed: at every step estimate complexity, risk and verification needs, then pick the model and effort. Do not inherit the session model by default.

## Governance

Minimal tier: `TODO.md` (decided, not-started items), `ROADMAP.md` (directions), `AGENTS.md` (bootstrap to this file). Commits are plain, with no AI attribution lines. The README keeps its "Maintained by" section and the makeitcount footer.
