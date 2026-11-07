# homebrew-tap

Homebrew formulae for two Claude Code mods by ramene:

| Formula | What it is | Source |
| --- | --- | --- |
| `cloud-sessions` | start, read, watch and send into Claude Code cloud sessions (CLI, MCP server, plugin) | https://github.com/ramene/cloud-sessions |
| `remote-sessions` | serve, list, send, read, stop and record Claude Code Remote Control sessions (CLI, MCP server, plugin) | https://github.com/ramene/remote-sessions |

## Install

```
brew install ramene/tap/cloud-sessions
brew install ramene/tap/remote-sessions
```

or `brew tap ramene/tap` once, then `brew install cloud-sessions remote-sessions`. Both formulae install a prebuilt binary (macOS universal, Linux x86_64, Linux arm64) from the project's GitHub release, so no Rust is needed. Each also puts the Claude Code plugin under `$(brew --prefix)/share/<name>/plugin`; `brew info <name>` prints the setup steps.

Note: Homebrew's bin directory comes first on PATH on most Macs, so a brew-installed `cloud-sessions` or `remote-sessions` shadows a copy installed some other way (for example `~/.cargo/bin`). Check with `command -v cloud-sessions`.

## Releasing a new version

Each formula has one `release` field (`release = "X.Y.Z"`) and three `sha256` lines (macOS universal, Linux x86_64, Linux arm64). `scripts/update-formula.sh` fills all four from the release's `SHA256SUMS`.

1. In the mod's repository, build all archives: `cloud/release/build-all.sh` (cloud-sessions) or `release/build-all.sh` (remote-sessions) until it exits 0. This writes `SHA256SUMS` next to the archives.
2. Create the GitHub release (`cloud-sessions-vX.Y.Z` or `remote-sessions-vX.Y.Z`), make sure its assets are public, and upload every file from the `out/` folder, `SHA256SUMS` included.
3. In this repository:
   ```
   scripts/update-formula.sh cloud-sessions X.Y.Z /path/to/out/SHA256SUMS
   scripts/update-formula.sh remote-sessions X.Y.Z /path/to/out/SHA256SUMS
   ```
   The script refuses, and changes nothing, if the file lacks any of the three archives for that version.
4. Check, commit and push the tap:
   ```
   brew style Formula/*.rb
   git commit -am "cloud-sessions X.Y.Z" && git push
   ```
5. Verify from a clean shell: `brew update && brew install ramene/tap/cloud-sessions`.

The formulae in git carry placeholder `sha256` values (000...1, 000...2, 000...3: they match nothing, so a premature install fails the checksum check) until step 3 has been run for the first release; do not publish the tap before that.
