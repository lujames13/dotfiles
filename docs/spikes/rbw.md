# Spike: rbw behaviour (issue #4, part of #2)

Research only. Sources were read through the web (no install, no rbw run, no vault touched).

Source base: `https://raw.githubusercontent.com/doy/rbw/main/` (abbreviated `rbw:` below). Line numbers are not available from the fetch tool except for `src/dirs.rs`. Cited by file and function instead. Pin a commit before relying on any of it.

Method caveat: pages were summarised by a fetch tool, not read verbatim. Treat every claim as "read from source, one pass". Where the fetch could not show something, it is marked **assumption**.

## 1. `rbw get` and names containing `/`

- Signature: `rbw get <needle> [user] [--folder <name>] [-i|--ignorecase] [-f|--field <f>] [--full] [--raw] [-l|--list-fields]` (`rbw:src/bin/rbw/main.rs`, `Get` / `FindArgs`).
- `needle` is classified by `parse_needle` as UUID, URL, or plain name (`rbw:src/bin/rbw/commands.rs`). No code path splits the needle on `/`. A name like `dev/proj/VAR` is therefore compared as one whole string against the entry name. Folder is only taken from `--folder`.
- By name and folder: `rbw get 'dev/proj/VAR'` or `rbw get VAR --folder dev/proj`. Whether folder names containing `/` match is **assumption**: Bitwarden folders are flat strings, and rbw compares them as strings (`matches` in `commands.rs`).
- Matching (`find_entry_raw`, `commands.rs`): two passes, exact then loose (substring). In each pass it tries strict folder+user, strict folder only, strict user only, then fully loose. A pass succeeds only if exactly one entry matches.
- Multiple entries sharing a name: error `multiple entries found: user@name, ...` (`commands.rs`). Nothing is picked silently. No match: `couldn't find entry for '<user@needle>'` wrapping `no entry found`.
- Consequence: the loose pass uses substring matching, so `get dev/proj/A` could also match `dev/proj/AB` if no exact match exists. Always use exact names. Using `--ignorecase` is optional.

## 2. 2FA methods

- README (`https://github.com/doy/rbw#readme`) states supported: email, authenticator app (TOTP), Yubico OTP. Unsupported: WebAuthn/passkey, Duo.
- Code agrees: `login()` in `rbw:src/bin/rbw-agent/actions.rs` checks providers in the order Authenticator, Yubikey, Email. Email sends the code first when an SSO email-2FA session token is present.
- Unsupported-only account: error `unsupported two factor methods: {providers:?}` (`actions.rs`).
- Prompts go through pinentry, 3 attempts; non-numeric input is retried with "TOTP code is not a number".
- Official-server login may require `rbw register` first (API key), because of captcha: `Captcha required.` maps to `RegistrationRequired` (`rbw:src/api.rs`, `classify_login_error`).

## 3. Config vs data locations, encryption at rest

- Paths come from the `directories` crate `ProjectDirs::from("", "", profile())` (`rbw:src/dirs.rs` lines 74-114). Profile name is `rbw`, or `rbw-<RBW_PROFILE>` if that variable is set and non-empty (lines 109-114). Each profile has its own directories.
- Files (`dirs.rs` lines 37-72):
  - config: `config_dir()/config.json` (Linux default `$XDG_CONFIG_HOME/rbw`)
  - vault cache: `cache_dir()/<encoded server>:<email>.json` (Linux default `$XDG_CACHE_HOME/rbw`)
  - runtime: `pidfile`, `socket`, `ssh-agent-socket` in `runtime_dir()`, falling back to `<tmp>/<profile>-<uid>`
  - data: agent stdout/stderr logs and `device_id` in `data_dir()`
  The XDG mapping itself is behaviour of the `directories` crate, not rbw. **assumption** that it applies unchanged on WSL2.
- `make_all()` creates cache, runtime, and data dirs with mode 0700. It does not create the config dir.
- Encryption at rest (`rbw:src/db.rs`): the db file is plain `serde_json` of the `Db` struct. rbw adds no encryption layer. It holds `access_token` and `refresh_token` as plain strings, so **tokens are not encrypted by rbw**; they are protected only by file permissions (dir 0700, the file's own mode is **assumption**, not shown). Entries and the `protected_key` / `protected_private_key` / `protected_org_keys` are Bitwarden cipherstrings, encrypted with the master-password-derived key, as in the Bitwarden protocol. That the entry fields are cipherstrings is **assumption** based on field names and `decrypt_cipher` in `actions.rs`.
- The master password is never written to the db (`actions.rs`, `login_success`). Decrypted keys live in agent memory only (`state.priv_key`, `state.org_keys`).
- Consequence: `rbw`'s cache dir should be treated as sensitive (it holds live tokens). Do not put it under chezmoi or back it up.

## 4. Does rbw rewrite `config.json`?

- `Config::save()` truncates and rewrites the file (`rbw:src/config.rs`). Output is compact single-line `serde_json`, not pretty-printed. `device_id` is `skip_serializing`.
- That `rbw config set` calls `save()` is **assumption**: the `config set` command handler was not read. The README says options are set with `rbw config`, which implies it.
- Consequence for chezmoi: a templated `config.json` will differ in formatting (and drop unknown keys, since it is a typed struct, **assumption**) after any `rbw config set`, so `chezmoi diff` will show drift. Recommended: do not template `config.json`. Instead run an idempotent `rbw config set email ...`, `rbw config set pinentry ...` from a `run_once` / `run_onchange` script (needs human review since it touches rbw config, but not the vault).
- Defaults (`config.rs`): `lock_timeout` 3600, `sync_interval` 3600, `pinentry` `"pinentry"`. `lock_timeout = 0` is reset to the default with a warning on load.

## 5. Pinentry on WSL2

- rbw spawns the program named by the `pinentry` config with `--timeout 0`, plus `--ttyname <tty>` if a tty is known and `--display $DISPLAY` if set (`rbw:src/pinentry.rs`). It speaks Assuan (`SETTITLE`, `SETPROMPT`, `SETDESC`, `GETPIN`). It never sets `ttytype`.
- Headless / WSL2 terminal: `pinentry-curses` (or `pinentry-tty`) works only if rbw can pass a tty. The tty comes from the client's environment, so run rbw from an interactive terminal. **assumption** that this works inside WSL2 without extra `GPG_TTY`; not verified, and the web search found no WSL2-specific rbw documentation.
- Bridging to a Windows pinentry: possible in principle since `pinentry` is just an executable path (`rbw config set pinentry <path>`). No rbw documentation of a WSL bridge was found. **assumption** only; would need a wrapper script speaking Assuan.
- Non-interactive contexts (CI, agent sessions) have no tty, so pinentry fails. Spawn / read errors are `Spawn`, `PinentryReadOutput`, etc.; cancel is error code `83886179` (`PinentryCancelled`).

## 6. `lock_timeout`

- Unit: seconds. Default 3600 (README, `config.rs`).
- Idle-style: the agent re-arms the timer with `state.set_timeout()` after successful Register, Login, Unlock, Decrypt, Encrypt and ClipboardStore requests. CheckLock, Lock, Sync, Version do not (`rbw:src/bin/rbw-agent/agent.rs`). So every successful `get` resets the clock.
- Expiry: the timer fires `Event::Timeout`, which calls `state.clear()`: drops `priv_key` and `org_keys` and clears the timer (`rbw:src/bin/rbw-agent/state.rs`). The agent process keeps running and the on-disk db stays. The next request needs `unlock` (pinentry prompt).
- Whether the timer uses monotonic time, i.e. whether suspended time counts, was not visible (`src/timeout.rs` not read). **assumption**. Nothing handles suspend/resume explicitly in `agent.rs`.
- `rbw lock` / `rbw stop-agent` clear keys immediately.

## 7. Exit codes and stderr

- Any error returned from a command: `eprintln!("{e:#}")` (full chain) then `exit(1)`, with context prefix `rbw <subcommand>` (`rbw:src/bin/rbw/main.rs`). So every failure below is exit code 1 as far as source shows; distinct codes are **not** provided. Only `run_agent` treats agent exit code 23 specially (`commands.rs`).
- Messages known from source:
  - item missing: `rbw get: couldn't find entry for '<user@needle>': no entry found`
  - ambiguous: `multiple entries found: <user@name>, ...`
  - agent locked (raw): `agent is locked` (`actions.rs`, `check_lock`). `get` normally calls `unlock()` first, which prompts through pinentry, so in practice a locked vault without a usable pinentry shows a pinentry error instead.
  - agent not running: the client starts the agent itself via `run_agent` (failure text `failed to run rbw-agent: {status}`). Raw socket error otherwise, no custom text (`rbw:src/bin/rbw/sock.rs`).
  - not logged in: `Db::needs_login` is true when tokens, kdf, or `protected_key` are missing (`db.rs`). The exact message was not found. **assumption**: commands trigger login automatically per the README, and fail on pinentry/email config if unset (`validate()` errors when `email` is unset; exact text not seen).
  - wrong 2FA / password: `IncorrectPassword`, text not seen.
- Observing exact messages needs a throwaway container without an account. Not done in this spike (no tools were run).

## Recommendation

- Keep `dev/<project>/<VAR>` naming as a flat item name, fetched with exact `rbw get 'dev/<project>/<VAR>'`. rbw does not interpret `/`, so it is safe. Folder-based (`--folder`) adds a second matching dimension and the loose-pass substring behaviour with no benefit. Prefer unique full names; ambiguity is a hard error, which is good for a secrets loader.
- rbw vs bws: rbw is a good primary for an interactive human workflow (agent caching, pinentry). It is a poor fit for unattended agents (needs pinentry/tty, unsupported WebAuthn/Duo, plain tokens on disk, all errors exit 1). bws (Bitwarden Secrets Manager) was **not researched** in this spike, so a firm "rbw over bws" claim is **not supported**. Tentative: rbw primary for the human-unlocked `srun` flow, with bws evaluated separately for non-interactive use.

## Human verification list (3 checks)

1. `rbw --version && rbw get --help` expect: version and `--folder`, `--ignorecase`, `--field` options (confirms flags match this report, safe, no account needed).
2. `RBW_PROFILE=spiketest rbw get x; echo "exit=$?"` expect: a non-zero exit (1) and a message about missing email/config on stderr; confirms exit code and not-configured text without touching the real profile. Run in a throwaway container or WSL distro.
3. In a WSL2 terminal: `rbw config show` is not required; instead `RBW_PROFILE=spiketest rbw config set pinentry pinentry-curses && ls "${XDG_CONFIG_HOME:-$HOME/.config}"/rbw-spiketest/` expect: `config.json` created, which also shows the path layout and that `config set` writes it.

(Real WSL2 pinentry unlock with a real vault remains a manual step for the human.)
