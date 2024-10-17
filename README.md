# Microsoft vscode-eslint as lsp server flake

This flake is intended to use with helix.

d1b62dfd90f5929f54fd3a551a2b985b4cf1cdf5 - Support probing Astro (#1795) -> Working

Stop working at 2c3d198cc648005f8cf5ca64476b8f2da8fa0205 - Convert to pull model diagnostics and improve flat config support (#1799)

## Helix languages.toml config :

```toml
[language-server.eslint]
command = "vscode-eslint-server"
args = ["--stdio"]

[language-server.eslint.config]
nodePath = ""
quiet = false
rulesCustomizations = []
run = "onType"
validate = "on"
experimental = {}
problems = { shortenToSingleLine = false }
```
