# mpvx
[![Release](https://github.com/HackingGate/mpvx/workflows/Release/badge.svg)](https://github.com/HackingGate/mpvx/releases)

Mac app for mpv inspired by [grsyncx](https://github.com/username0x0a/grsyncx)

## Requirements

Install command-line interface mpv with [Homebrew](https://brew.sh).

```bash
$ brew install mpv
```

Make sure your mpv is installed in the correct path.

```bash
$ which mpv
/usr/local/bin/mpv
```

## Screenshot

![mpvx-demo.png](https://raw.githubusercontent.com/HackingGate/mpvx/master/assets/mpvx-demo.png)

## Why Not IINA

[IINA](https://iina.io) is a wrapper of [mpv player](https://mpv.io) with lots of features implemented.

I found an issue for IINA. Key control like `.` (step forward) or `,` (step backward) do not support consecutive press. An important feature to me.

I invested the [source code of IINA](https://github.com/iina/iina) and learned to support consecutive press. Use `int mpv_command(mpv_handle *ctx, const char **args);` instead of the more error prone way `int mpv_command_string(mpv_handle *ctx, const char *args);` and pass commands with `keyDown` and `keyUp` events will do it.

But IINA has its own layer of key management which means it requires a lot of work to do.

You can have look at [the PR](https://github.com/typcn/bilibili-mac-client/pull/163/files) I created for [bilibili-mac-client](https://github.com/typcn/bilibili-mac-client) years ago for how to implement both `keyDown` and `keyUp` event.


## Alternatives

[mpv-nightly-build](https://github.com/jnozsc/mpv-nightly-build): Unoffical mpv nightly build for macOS
