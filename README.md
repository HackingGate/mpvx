# mpvx

[![Build and Test](https://github.com/HackingGate/mpvx/actions/workflows/test-and-coverage.yml/badge.svg)](https://github.com/HackingGate/mpvx/actions/workflows/test-and-coverage.yml)
[![codecov](https://codecov.io/gh/HackingGate/mpvx/graph/badge.svg?token=TVGJ0H9CTZ)](https://codecov.io/gh/HackingGate/mpvx)
[![Release](https://github.com/HackingGate/mpvx/workflows/Release/badge.svg)](https://github.com/HackingGate/mpvx/releases)

Mac app for mpv inspired by [grsyncx](https://github.com/username0x0a/grsyncx)

## Requirements

### mpv Homebrew Installation (Recommended)

Install the command-line interface mpv with [Homebrew](https://brew.sh).

```bash
brew install mpv
```

The mpvx app will automatically check the following paths, which means it supports both Apple Silicon and Intel:

```text
/opt/homebrew/bin/mpv
/usr/local/bin/mpv
```

### Standalone mpv Executable

You can specify the `--mpvx-mpv-binary-path=` argument to indicate the mpv executable you'd like to use. For example:

```bash
/Applications/mpvx.app/Contents/MacOS/mpvx --mpvx-mpv-binary-path=/Applications/mpv.app/Contents/MacOS/mpv
```

## Screenshot

![mpvx-demo.png](https://raw.githubusercontent.com/HackingGate/mpvx/master/assets/mpvx-demo.png)

## Why Not IINA

[IINA](https://iina.io) is a wrapper of [mpv player](https://mpv.io) with lots of features implemented.

I found an issue with IINA. Key control like `.` (step forward) or `,` (step backward) do not support consecutive presses, which is an important feature to me.

I investigated the [source code of IINA](https://github.com/iina/iina) and learned how to support consecutive presses. Use `int mpv_command(mpv_handle *ctx, const char **args);` instead of the more error-prone way `int mpv_command_string(mpv_handle *ctx, const char *args);` and pass commands with `keyDown` and `keyUp` events to achieve this.

You can have look at [the PR](https://github.com/typcn/bilibili-mac-client/pull/163/files) I created for [bilibili-mac-client](https://github.com/typcn/bilibili-mac-client) years ago for how to implement both `keyDown` and `keyUp` event.

However, IINA has its own layer of key management, which means it requires a lot of work to implement.

That is why I created this simpler project that handles media resource opening and launches vanilla mpv from the Homebrew formula.

## Looking for iOS?

[Outplayer](https://outplayer.app/) by Stephen Salerno: video player for iOS powered by mpv
