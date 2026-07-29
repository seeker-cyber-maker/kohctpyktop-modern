# KOHCTPYKTOP: Engineer of the People — modern local launcher

A small preservation wrapper that makes Zachtronics' 2009 Flash engineering
game playable on a current Mac through [Ruffle](https://ruffle.rs/).

The historical SWF is not patched. The wrapper supplies a modern runtime,
restores the separately loaded music, and replaces the dead Flash Video
tutorial endpoint with the surviving video link.

## What is—and is not—here

This repository contains only original restoration code and documentation. It
does **not** distribute KOHCTPYKTOP's copyrighted SWF, music, artwork, or other
game assets, nor does it redistribute Ruffle binaries.

You can obtain a legitimate copy of KOHCTPYKTOP with Zachtronics' free
[ZACH-LIKE](https://store.steampowered.com/app/1098840/ZACHLIKE/) collection.
The setup script also accepts files from another copy you lawfully possess.

For historical research, the Internet Archive item named
[`kohctpyktop`](https://archive.org/details/kohctpyktop) currently exposes the
[archived SWF directly](https://archive.org/download/kohctpyktop/kohctpyktop.swf).
That link is provided as a provenance reference; availability and permission to
download or use the asset depend on the archive and the applicable rights in
your jurisdiction.

## Install on macOS

Requirements: `python3`, `curl`, `unzip`, and an internet connection for the
one-time Ruffle download.

```sh
git clone https://github.com/seeker-cyber-maker/kohctpyktop-modern.git
cd kohctpyktop-modern
./scripts/setup.sh
```

With ZACH-LIKE in its default macOS Steam location, no paths are required.
Otherwise:

```sh
./scripts/setup.sh /path/to/kohctpyktop.swf /path/to/kohctpyktop.mp3
```

The installer verifies the game assets and the pinned official Ruffle 0.4.1
download against known SHA-256 hashes. Then double-click
`Play KOHCTPYKTOP.command`. The server listens only on `127.0.0.1` and stops
when its Terminal window closes.

## What was repaired

- Bundled local playback replaces end-of-life Adobe Flash.
- The original external `kohctpyktop.mp3` music is placed where the SWF expects it.
- The dead `zachtronicsindustries.com/.../kohctpyktop.flv` tutorial endpoint is
  replaced by a link to the surviving tutorial video.
- The web runtime avoids the obsolete Kongregate local-testing alert that can
  block the standalone desktop runtime.
- Circuit designs remain portable text codes through **Menu → Save This Design**
  and **Load A Design**.
- The wrapper adds a local named-design library. Paste the game's save code into
  a slot, then copy it back when loading. Open it from the **Design library**
  button beside the playback controls. The library supports any number of
  designs and JSON export/import for backup or transfer between browsers.

The design library uses browser `localStorage` on this machine. It never
uploads saves anywhere. Export the library periodically: clearing browser site
data can remove the local copy.

## Validation

The restoration was smoke-tested on Apple Silicon/macOS on 2026-07-29 through
the title screen, level selection, puzzle rendering, silicon placement, the
in-game menu, save-code generation, and local music retrieval.

Exact archival identifiers are recorded in [KNOWN_HASHES.md](KNOWN_HASHES.md).

## Preservation and rights

KOHCTPYKTOP and its assets remain the property of their respective rights
holders. This project is an unaffiliated compatibility and preservation
wrapper. The MIT license applies only to the code and documentation created for
this repository.
