# Practice Piano Roll

A piano practice player for MIDI files: falling notes over a keyboard, real piano sound, slow-down, bar looping and per-hand mute. Runs in the browser and installs on a phone as an app.

**Live:** https://nik-chembedded.github.io/piano-player/

## Features

- Open any `.mid` / `.midi` file (it stays on your device, nothing is uploaded)
- Falling notes with note names; left hand gold, right hand green (single-track files are split at middle C)
- Speed 25–150% without changing pitch, jump by 5 s or by bar, drag or scroll to scrub
- Loop a range of bars
- Mute a hand to play it yourself, or hide it
- Sounds: concert grand (4 loudness layers), bright grand, light grand, electric piano; room and tone settings
- Installable app (Android, iPhone, desktop Chrome/Edge) with offline mode

Try it with [examples/bach-prelude-in-c.mid](examples/bach-prelude-in-c.mid) (opening of Bach's Prelude in C, BWV 846, public domain).

## Use on a phone

- **Android (Chrome):** open the site, then tap **Install app** on the page or menu (&#8942;) → **Install app**.
- **iPhone / iPad (Safari):** open the site, tap **Share** → **Add to Home Screen**.
- Tap **Save sounds for offline** once to keep all piano sounds on the device.

## Run on your computer

Opening `index.html` directly from disk doesn't work, because browsers block the sound files for pages opened from a file. On Windows, double-click `start-piano.bat`. It serves the folder at http://localhost:8765 and opens your browser. Or use any static server, for example:

```bash
python -m http.server 8765
```

## Hosting on GitHub Pages

Settings → Pages → Source: **Deploy from a branch** → Branch: `main`, folder `/ (root)`.

## Credits

- Concert grand and light grand: [Salamander Grand Piano](https://archive.org/details/SalamanderGrandPianoV3) by Alexander Holm, CC BY 3.0 (MP3 conversions from [darosh/samples-piano-mp3](https://github.com/darosh/samples-piano-mp3) and [Tone.js](https://github.com/Tonejs/audio))
- Bright grand: [tonejs-instruments](https://github.com/nbrosowsky/tonejs-instruments) by Nicholas Brosowsky
- MIDI parsing: [@tonejs/midi](https://github.com/Tonejs/Midi)
