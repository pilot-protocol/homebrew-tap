# pilot-protocol Homebrew tap

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
