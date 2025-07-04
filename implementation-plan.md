# Open Stage Control Configuration Plan

_A terse implementation plan for configuring Open Stage Control for local Windows usage._

---

## Environment

- Platform: Windows 11
- Purpose: Local touchscreen surface for Ableton Live 12
- MIDI Virtual Port: `OSC-server` (via LoopMIDI)
- Project root: `C:\gdrive\Music\osc-server`
- Config location: `.\my-osc.config`
- Layout location: `.\layouts\`
- OSC install: `.\open-stage-control_win32-x64\`

---

## Goals

- Route all O-S-C MIDI output to LoopMIDI port `OSC-server`.
- Disable web workers to suppress client-side errors.
- Maintain configs under git for reproducibility.
- Avoid administrative permissions for daily operation.

---

## Config File

Create or replace:

```
C:\gdrive\Music\osc-server\my-osc.config
```

Contents:

```json
{
  "midi": "out:OSC-server",
  "client-options": "--no-workers"
}
```

This config disables browser web workers and establishes a dedicated MIDI output route.

---

## Usage

### Launch

Start O-S-C with:

```powershell
open-stage-control.exe --load C:\gdrive\Music\osc-server\my-osc.config
```

Or equivalent shell command.

---

## Layout Storage

- Store layout JSON files in:
    ```
    C:\gdrive\Music\osc-server\layouts\
    ```
- Version layouts via git.

Example layout path:

```
C:\gdrive\Music\osc-server\layouts\transport-panel.json
```

---

## Layout JSON Example

Minimal example for transport controls:

```json
{
  "widgets": [
    {
      "type": "button",
      "label": "Play",
      "onValue": "/midi/note 1 60 127"
    },
    {
      "type": "button",
      "label": "Record",
      "onValue": "/midi/note 1 61 127"
    },
    {
      "type": "fader",
      "label": "Master Vol",
      "min": 0,
      "max": 127,
      "onValue": "/midi/cc 1 7 $value"
    }
  ]
}
```

Map these MIDI messages to Ableton Live’s transport and master level via Live’s MIDI remote assignments.

---

## MIDI Routing

- In Ableton:
  - Enable “Remote” for the LoopMIDI port `OSC-server`.
  - Leave “Track” disabled if only controlling Live parameters.

This isolates O-S-C traffic from other hardware MIDI inputs.

---

## Version Control

- Commit both config and layout files to git:

```
osc-server/
├── my-osc.config
└── layouts/
    └── transport-panel.json
```

- Avoid committing machine-specific credentials or secrets.

---

## Known Issues

- The O-S-C GUI “Save” function often fails to persist config fields like `midi` and `client-options`.  
- Workaround: manually maintain `my-osc.config` as JSON under version control.

---

