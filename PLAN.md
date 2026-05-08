# Inverted Tower — Game Plan
**Engine:** Godot 4.6.2 | **Genre:** 2D Side-scrolling | **Setting:** Medieval / Occult

---

## Story

A historian tracks down the ruins of the legendary Tower of Babylon buried beneath a medieval landscape. As he descends through collapsed chambers he uncovers a horrifying truth: a fanatical cult deliberately inverted the tower, driving it deep into the earth to commune with something below. The deeper he goes, the more the architecture defies logic — ceilings become floors, gravity warps, and the cult's guardians still patrol its halls. He must piece together the cult's secrets through scattered lore and survive long enough to escape.

---

## World Structure

The game is a linear side-scroller with optional secret rooms in each zone. Zones descend — the further down, the more distorted the architecture and the more dangerous the enemies.

```
Zone 1 — Surface Ruins         (tutorial, crumbling medieval stone)
Zone 2 — Upper Vaults          (first underground, storage rooms, early cult markings)
Zone 3 — The Fracture          (architecture begins inverting, gravity shifts)
Zone 4 — The Inverted Nave     (fully upside-down halls, mid-game twist)
Zone 5 — Cult Sanctum          (deep ritual chambers, high difficulty)
Zone 6 — The Core              (heart of the inversion, final boss arena)
```

Each zone has:
- 2–3 main rooms + 1 hidden secret room
- 1 lore scroll (text collectible)
- 1 mini-challenge or puzzle before the next zone gate

---

## Player Systems

| System | Description |
|--------|-------------|
| Movement | Walk, run, jump, crouch, wall-slide |
| Combat | Melee (torch / dagger), throwable knives, dodge roll |
| Health | 5 HP, restored by found bandages and herbs |
| Sanity | Drains slowly in Zones 4–6; full depletion causes screen distortion and spawns shades |
| Lore Scrolls | Collectible texts that expand the story; tracked in a journal menu |
| Secrets | Hidden wall passages reveal extra lore, HP upgrades, or shortcuts |

---

## Enemies

| Enemy | Zone | Type | Notes |
|-------|------|------|-------|
| Cultist Acolyte | 1–3 | Melee humanoid | Basic patrol + aggro |
| Cultist Archer | 2–4 | Ranged humanoid | Fires from distance, retreats |
| Possessed Relic | 2–3 | Construct | Slow, high HP, area stomp |
| Shade | 4–6 | Ghost | Passes through terrain, sanity-linked |
| Cult Warden | 3, 5 | Heavy melee | Mini-boss, drops key item |
| The Keeper | Zone 3 boss | Construct | Phase 1: stomp; Phase 2: gravity flip |
| The High Inquisitor | Zone 5 boss | Humanoid | Teleport + projectile barrage |
| The Inverted One | Zone 6 final | Eldritch | Multi-phase, environmental hazards |

---

## Scenes (Godot)

```
res://
├── scenes/
│   ├── player/
│   │   ├── Player.tscn
│   │   └── PlayerCamera.tscn
│   ├── enemies/
│   │   ├── CultistAcolyte.tscn
│   │   ├── CultistArcher.tscn
│   │   ├── PossessedRelic.tscn
│   │   ├── Shade.tscn
│   │   ├── CultWarden.tscn
│   │   ├── TheKeeper.tscn
│   │   ├── TheHighInquisitor.tscn
│   │   └── TheInvertedOne.tscn
│   ├── zones/
│   │   ├── Zone1_SurfaceRuins.tscn
│   │   ├── Zone2_UpperVaults.tscn
│   │   ├── Zone3_TheFracture.tscn
│   │   ├── Zone4_InvertedNave.tscn
│   │   ├── Zone5_CultSanctum.tscn
│   │   └── Zone6_TheCore.tscn
│   ├── ui/
│   │   ├── HUD.tscn
│   │   ├── PauseMenu.tscn
│   │   ├── LoreJournal.tscn
│   │   └── MainMenu.tscn
│   └── objects/
│       ├── Torch.tscn
│       ├── LoreScroll.tscn
│       ├── SecretPassage.tscn
│       ├── ChestPickup.tscn
│       └── ZoneGate.tscn
├── assets/
│   ├── sprites/characters/
│   ├── sprites/tilesets/
│   ├── sprites/objects/
│   └── sprites/ui/
├── scripts/
│   ├── player/
│   ├── enemies/
│   ├── systems/
│   └── ui/
└── autoloads/
    ├── GameState.gd      (health, sanity, scrolls collected)
    ├── SaveSystem.gd
    └── EventBus.gd
```

---

## Development Phases

### Phase 0 — Foundation
**Goal:** Playable player in a test room with no real art.

- [x] Create Godot project, set up folder structure
- [x] `Player.tscn`: CharacterBody2D, movement (walk/run/jump), attack, dodge roll with i-frames
- [x] `GameState.gd` autoload: health, sanity, scroll list, checkpoint
- [x] `EventBus.gd` autoload: signal bus for damage, death, lore, sanity, zone
- [x] Input map registered: move_left/right (A·D·←·→), jump (Space·W), attack (J·Z), dodge (K·X), interact (E·F)
- [ ] Camera with screen-edge deadzone
- [ ] Placeholder TileMap with one gray tile for collision testing
- [ ] Death + respawn at last checkpoint

---

### Phase 1 — Art Foundation (PixelLab)
**Goal:** Generate all core sprites before building real levels.

#### Protagonist — IMPORTED
Character already created in PixelLab and downloaded.
- **ID:** `af0973e3-aaeb-45e0-b968-3467cd34e8c5`
- **Size:** 92×92px, 8 directions, view: low top-down
- **Animations included:** Breathing_Idle (4 frames), Walking (6 frames), Attack-lunge (7 frames)
- **Path:** `assets/sprites/characters/historian/`
- **Sidescroller frames to use:** `south-east/` = facing right, `south-west/` = facing left

Missing animations to add via `animate_character`:
```
Tool: animate_character
  character_id: af0973e3-aaeb-45e0-b968-3467cd34e8c5
  template_animation_id: hurt / death / run / jump
```

#### Zombie Enemy — IMPORTED
Character already created in PixelLab and downloaded.
- **ID:** `6d88c2ee-1e5d-4236-8502-e4779c1d34b3`
- **Size:** 120×120px, 8 directions, view: side
- **Animations included:** Walking (6 frames), Attack-upward (5 frames)
- **Path:** `assets/sprites/characters/zombie_enemy/`
- **Sidescroller frames to use:** `south-east/` = facing right, `south-west/` = facing left

Missing animations to add via `animate_character`:
```
Tool: animate_character
  character_id: 6d88c2ee-1e5d-4236-8502-e4779c1d34b3
  template_animation_id: hurt / death / idle
```

#### Remaining Enemies (still to generate)
| Enemy | create_character parameters |
|-------|-----------------------------|
| Cultist Acolyte | `"hooded cultist, ragged medieval robe, dagger"`, humanoid, realistic_male, size 64 |
| Cultist Archer | `"hooded cultist, crossbow, dark medieval cloak"`, humanoid, realistic_male, size 64 |
| Possessed Relic | `"ancient stone golem, cracked surface, glowing eyes"`, humanoid, realistic_male, size 80 |
| Cult Warden | `"armored medieval knight, inverted cross on chest, large halberd"`, humanoid, realistic_male, size 80 |

```
Tool: animate_character → idle, walk, attack, hurt, death for each enemy
Tool: vary_object → generate elite (glowing) variant of Acolyte and Archer for Zones 5–6
```

#### Bosses — use create_object (more frame control)
```
Tool: create_object
  description: "The Keeper — massive stone guardian, cracked with occult runes, four-armed"
  directions: 1     ← boss faces one direction
  size: 96
  n_frames: 4       ← idle cycle
  view: side

Tool: animate_object
  object_id: <keeper_id>
  animation_description: "heavy stomp, screen shake, raises fist then slams ground"
  frame_count: 8

Repeat for: The High Inquisitor, The Inverted One
```

#### Tilesets — one per zone, chained for style consistency
```
Zone 1 — Surface Ruins
  Tool: create_sidescroller_tileset
    lower_description: "crumbling medieval stone brick, weathered mortar"
    transition_description: "patches of green moss and wild grass on top"
    transition_size: 0.3
    tile_size: 16x16
    outline: thin
    shading: hard
    detail: medium
    seed: 1001

Zone 2 — Upper Vaults
  Tool: create_sidescroller_tileset
    lower_description: "ancient dark limestone blocks, underground vault"
    transition_description: "dust, cobwebs, faint carved symbols"
    transition_size: 0.2
    base_tile_id: <zone1_id>     ← chains style from Zone 1
    seed: 1002

Zone 3 — The Fracture
  Tool: create_sidescroller_tileset
    lower_description: "fractured sandstone, chunks floating slightly out of place"
    transition_description: "glowing amber cracks, dust motes"
    transition_size: 0.35
    base_tile_id: <zone2_id>
    seed: 1003

Zone 4 — The Inverted Nave
  Tool: create_sidescroller_tileset
    lower_description: "ornate stone pillars and arches, clearly built upside-down"
    transition_description: "dark inverted moss, dripping shadows"
    transition_size: 0.25
    base_tile_id: <zone3_id>
    seed: 1004

Zone 5 — Cult Sanctum
  Tool: create_sidescroller_tileset
    lower_description: "polished black marble, ritual engravings, candle wax drips"
    transition_description: "dried blood and faint red runes"
    transition_size: 0.2
    base_tile_id: <zone4_id>
    seed: 1005

Zone 6 — The Core
  Tool: create_sidescroller_tileset
    lower_description: "void-touched obsidian, surface rippling like liquid"
    transition_description: "tears in reality, faint purple light leaking through"
    transition_size: 0.4
    base_tile_id: <zone5_id>
    seed: 1006
```

#### Props / Map Objects
```
Tool: create_map_object (for each prop below)
  view: side
  outline: single color outline
  shading: medium shading
  detail: medium detail
```

| Prop | description parameter |
|------|-----------------------|
| Wall torch | `"medieval iron wall bracket holding a burning torch, side view"` |
| Altar | `"stone cult altar with candles and skull, side view"` |
| Bookshelf | `"old wooden bookshelf with scrolls and tomes, side view"` |
| Lore scroll | `"rolled parchment scroll tied with twine, glowing faintly"` |
| Lever | `"iron wall lever with worn wood handle, side view"` |
| Chest | `"old wooden chest with iron lock, side view"` |
| Broken column | `"fallen medieval stone column, cracked, mossy"` |
| Cult symbol | `"carved inverted triangle occult symbol on stone wall"` |
| Spike trap | `"stone floor panel with retractable iron spikes"` |

```
Tool: animate_object
  → Torch: flickering flame loop (frame_count: 6)
  → Spike trap: retract/extend cycle (frame_count: 4)
  → Chest: opening animation (frame_count: 4)
```

---

### Phase 2 — Zones 1 & 2
**Goal:** First two zones fully playable with real art.

- [ ] Import all generated tilesets into Godot TileSet resources
- [ ] Build `Zone1_SurfaceRuins.tscn` level layout
- [ ] Build `Zone2_UpperVaults.tscn` level layout
- [ ] Place props as StaticBody2D / Area2D nodes using generated sprites
- [ ] Implement `CultistAcolyte.tscn`: patrol state, aggro radius, attack, death
- [ ] Implement `CultistArcher.tscn`: stand, aim, shoot projectile, retreat
- [ ] Implement `LoreScroll.tscn`: Area2D pickup → logs to GameState, opens text popup
- [ ] Implement `SecretPassage.tscn`: thin wall tile that breaks on interact
- [ ] Implement first checkpoint system
- [ ] HUD: health bar, sanity bar stub (hidden in Zone 1–2)

---

### Phase 3 — Remaining Art (PixelLab)
**Goal:** All sprites for Zones 3–6 generated and imported.

- [ ] Generate remaining tilesets (Zones 3–6) using chained base_tile_id
- [ ] Generate `PossessedRelic`, `Shade`, `CultWarden` characters + animations
- [ ] Generate boss objects: The Keeper, The High Inquisitor, The Inverted One
- [ ] Generate remaining props (altar variants, void crystals, inverted pillars)
- [ ] Use `vary_object` on Acolyte/Archer for elite Zone 5–6 variants

---

### Phase 4 — Zones 3–6 & Core Systems
**Goal:** Full game playable start to finish.

- [ ] Build `Zone3_TheFracture.tscn` — introduce gravity-flip platform sections
- [ ] Build `Zone4_InvertedNave.tscn` — upside-down layout, Shade enemies
- [ ] Build `Zone5_CultSanctum.tscn` — dense enemy placement, warden mini-boss
- [ ] Build `Zone6_TheCore.tscn` — final boss arena
- [ ] Implement sanity system: slow drain in Zones 4–6, screen vignette + distortion shader
- [ ] Implement `TheKeeper.tscn` boss fight: phase 1 stomp, phase 2 gravity flip
- [ ] Implement `TheHighInquisitor.tscn` boss fight: teleport + projectile patterns
- [ ] Implement `TheInvertedOne.tscn` final boss: multi-phase, zone hazards
- [ ] Implement full lore journal UI (`LoreJournal.tscn`)
- [ ] Implement `SaveSystem.gd`: save zone progress, health, scrolls to file

---

### Phase 5 — Polish & Ship
**Goal:** Shippable, polished vertical slice.

- [ ] Main menu (`MainMenu.tscn`) with new game / continue / quit
- [ ] Pause menu with quit-to-menu
- [ ] Particle effects: torch smoke, dust on landing, blood on hit, void wisps in Zone 6
- [ ] Screen shake on boss attacks and heavy hits
- [ ] Death screen with "You perished" message and retry
- [ ] Full playthrough balance pass (enemy HP, damage, spawn density)
- [ ] Audio: placeholder SFX slots wired to AudioStreamPlayer nodes (footstep, slash, hurt, ambient)
- [ ] Accessibility: rebindable keys in settings
- [ ] Final bug pass

---

## PixelLab Tool Quick Reference

| What you need | Tool to use |
|---------------|-------------|
| Generate a new character sprite | `create_character` |
| Add walk/run/attack animation to a character | `animate_character` |
| Check if a character job is done | `get_character` |
| Generate a zone's platform tiles | `create_sidescroller_tileset` |
| Check tileset generation status | `get_sidescroller_tileset` |
| Generate a prop (torch, chest, altar) | `create_map_object` |
| Generate a boss or complex enemy sprite | `create_object` |
| Add animation frames to a boss/object | `animate_object` |
| Make a color/detail variant of an enemy | `vary_object` |
| List all generated characters | `list_characters` |
| List all generated tilesets | `list_sidescroller_tilesets` |
| List all generated objects | `list_objects` |
| Remove an unused asset | `delete_character` / `delete_sidescroller_tileset` / `delete_object` |

---

## Asset Tracking

Keep generated IDs here as assets are created.

### Characters
| Name | ID | Size | Animations | Status |
|------|----|------|------------|--------|
| Historian (protagonist) | `af0973e3-aaeb-45e0-b968-3467cd34e8c5` | 92×92 | Breathing_Idle (4f), Walking (6f), Attack-lunge (7f) | **done** — `assets/sprites/characters/historian/` |
| Zombie Enemy | `6d88c2ee-1e5d-4236-8502-e4779c1d34b3` | 120×120 | Walking (6f), Attack-upward (5f) | **done** — `assets/sprites/characters/zombie_enemy/` |
| Cultist Acolyte | — | — | — | pending |
| Cultist Archer | — | — | — | pending |
| Possessed Relic | — | — | — | pending |
| Cult Warden | — | — | — | pending |

### Bosses (Objects)
| Name | ID | Status |
|------|----|--------|
| The Keeper | — | pending |
| The High Inquisitor | — | pending |
| The Inverted One | — | pending |

### Tilesets
| Zone | ID | Status |
|------|----|--------|
| Zone 1 — Surface Ruins | `99e4fd6d-c197-491a-8ae4-2ccdb893ad3f` | **done** — `assets/sprites/tilesets/zone1_surface_ruins/` (16 Wang tiles, 16×16px) |
| Zone 2 — Cave Digging Site | `5625a822-b4f3-45c4-9eda-0d2744ccdef0` | **done** — `assets/sprites/tilesets/zone2_cave_ruins/` (16 Wang tiles, 16×16px) |
| Zone 3 — The Fracture | — | pending |
| Zone 4 — Inverted Nave | — | pending |
| Zone 5 — Cult Sanctum | — | pending |
| Zone 6 — The Core | — | pending |

### Props / Map Objects
| Prop | ID | Status |
|------|----|--------|
| Wall Torch | — | pending |
| Altar | — | pending |
| Bookshelf | — | pending |
| Lore Scroll | — | pending |
| Lever | — | pending |
| Chest | — | pending |
| Broken Column | — | pending |
| Cult Symbol | — | pending |
| Spike Trap | — | pending |

---

*This file is the living document for the project. Update asset IDs, task checkboxes, and zone statuses as work progresses.*
