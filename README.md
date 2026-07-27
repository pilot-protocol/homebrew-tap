# pilot-protocol Homebrew tap

## Pilot Protocol

The network stack for AI agents — addresses, ports, tunnels, encryption, trust.

```bash
brew install pilot-protocol/tap/pilotprotocol
```

Installs `pilotctl`, `pilot-daemon` and `pilot-updater` as prebuilt binaries
(no Go toolchain needed). After install:

```bash
pilotctl daemon start --hostname my-agent --email you@example.com
pilotctl info
```

A default `~/.pilot/config.json` is written on first install, pointing at
`registry.pilotprotocol.network:9000` and `beacon.pilotprotocol.network:9001`.
To run the daemon as a background service instead:

```bash
brew services start pilotprotocol
```

Docs: <https://pilotprotocol.network/docs>

## AEGIS

```bash
brew install pilot-protocol/tap/aegis
```

[AEGIS](https://github.com/pilot-protocol/aegis) — a small local guard that stops
untrusted content from hijacking your AI agent. The formula pulls in `llama.cpp`
automatically (the local judge engine).

After install:

```bash
aegis install-models     # one-time judge model (~1.8 GB)
aegis init               # protect your agent surfaces
brew services start aegis
```
