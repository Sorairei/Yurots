# YurOTS 0.9.4f — Modernized 64-bit Linux Edition

<p align="center">
  <img src="https://img.shields.io/badge/Version-0.9.4f%20Enhanced-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/Standard-C%2B%2B11-orange.svg" alt="C++11">
  <img src="https://img.shields.io/badge/Architecture-x86__64%20%7C%20ARM64%20(aarch64)-green.svg" alt="Architecture">
  <img src="https://img.shields.io/badge/Protocol-Tibia%207.6%20%2F%20OTClientV8-purple.svg" alt="Protocol">
  <img src="https://img.shields.io/badge/License-GPL%20v2-red.svg" alt="License">
</p>

---

## [ Overview ]

**YurOTS 0.9.4f Modernized Edition** is an upgraded, high-performance C++ OpenTibia server designed for **Tibia 7.6 / OTClientV8**, based on the [divinity76/YurOTS](https://github.com/divinity76/YurOTS) upstream repository and originally developed by Yurez in 2006. This edition has been thoroughly refactored and modernized for **Linux 64-bit (x86_64 / ARM64)** platforms, including Ubuntu 22.04/24.04 LTS, Debian 11/12, and cloud hosting (Oracle Cloud Ampere ARM64, AWS Graviton, DigitalOcean).

---

## [ Key Modernization Features ]

| Category | Feature | Description |
| :--- | :--- | :--- |
| **64-bit Binary Safety** | LP64 Struct Alignment | Fixed `uint32_t` width serialization for `items.otb` and `test.otbm` to eliminate memory desynchronization and buffer corruption. |
| **Anti-Duplication** | Atomic Transactions & Math | Atomic trade validation, cyclic container recursion prevention, fixed stackable arithmetic, and atomic `.tmp` player saving. |
| **Network Hardening** | Buffer Bounds & TCP Streams | Strict `canRead()` bounds checking in `NetworkMessage`, safe `memcpy` string writes, and fragmented TCP packet streaming. |
| **Crash Protection** | Full Null-Safety Guards | Complete null-pointer protection in NPC dialogue callbacks, item movements, and XML property readers. |
| **Memory Management** | Leaks & glibc Protection | Remediation of `libxml2` `xmlChar*` allocation leaks, item entity lifecycle deallocation (`FreeThing`), and glibc tcache protection. |
| **Dynamic DNS** | No-IP / Hostname Resolution | Built-in `gethostbyname` DNS resolution allowing domains (e.g. `your-server.ddns.net`) directly in `config.lua`. |
| **Linux Case Sensitivity** | ext4 Path Normalization | Fully unified lowercase path resolution and intelligent fallback for all NPC, player, and monster XML files. |
| **Build Automation** | Auto-Detecting Pipeline | Intelligent multi-threaded compilation script with ANSI colors, CPU thread detection (`nproc`), and RAM monitoring. |
| **Lua Engine** | Native Lua 5.0.3 Stack | Automated on-demand build of Lua 5.0.3 with `-fPIC -O2` flags for modern Linux linkers. |

---

## [ Security, Anti-Dupe & Engine Hardening ]

* **Anti-Duplication Engine (*Anti-Dupe*):**
  * **Atomic Trade System:** Synchronized transaction verification in `Game::playerAcceptTrade` and `playerCloseTrade` preventing race conditions, item loss, or ghost clones.
  * **Cyclic Container Loop Blocker:** Hierarchical parent-chain traversal in `Game::onPrepareMoveThing` stopping players from nesting backpacks within themselves or their sub-containers.
  * **Stackable Items Arithmetic:** Fixed boundary conditions in `Player::removeItem` (preventing deletion of the final remaining unit) and corrected ground-stack arithmetic in `Player::TLMaddItem`.
  * **Atomic Player Persistence:** `IOPlayerXML::savePlayer` writes to an isolated `.xml.tmp` file and performs an atomic POSIX rename, completely eliminating 0-byte corruptions and crash-induced rollback dupes.

* **Network & Protocol Protection:**
  * **Buffer Bounds Safety:** Hardened `NetworkMessage` with `canRead()` checks across all getters to block out-of-bounds reads from truncated packets.
  * **TCP Streaming Framing:** Handled fragmented network streams in `ReadFromSocket` to prevent packet framing desync.
  * **Safe String Serialization:** Replaced unsafe `strcpy` with bounded `memcpy` in `NetworkMessage::AddString`.
  * **Opcode & Parameter Sanitization:** Strict container ID bounds (`0..15`), coordinate boundaries, and throw count limits (1 to 100).

* **Null-Safety & Crash Prevention:**
  * Added null pointer guards across all NPC Lua callbacks (`luaCreatureGetName`, `luaCreatureGetPos`, `luaSelfGetPos`, etc.) preventing segmentation faults when players disconnect during dialogues.
  * Added safe property extraction and null checks for all XML entity readers (houses, spawns, and accounts).

* **Memory Leak Remediation:**
  * Systematically deallocated all `libxml2` dynamic properties (`xmlFreeOTSERV`) in `houses.cpp`, `ioplayerxml.cpp`, and `npc.cpp`.
  * Proper memory reclamation via `FreeThing` for items removed or consumed from containers and player inventories.
  * Array bounds validation and memory cleanup in VIP list loading.

---

## [ Quick Start & Installation ]

### Option A: Linux (Ubuntu / Debian / Cloud)

1. **Install Prerequisites:**
   ```bash
   sudo apt update && sudo apt install -y git
   ```

2. **Clone & Build:**
   ```bash
   git clone https://github.com/Sorairei/Yurots.git
   cd Yurots
   chmod +x build_ubuntu.sh
   sudo bash build_ubuntu.sh
   ```

3. **Configure & Start:**
   Edit [config.lua](file:///e:/Github/Yurots/config.lua) and run `./yurots`.

---

### Option B: Microsoft Windows (MSYS2 / MinGW-w64)

1. **Install Prerequisites:**
   Install [MSYS2](https://www.msys2.org/) or run in PowerShell: `winget install MSYS2.MSYS2`.
   In MSYS2 MINGW64 terminal, run:
   ```bash
   pacman -Syu --needed mingw-w64-x86_64-gcc mingw-w64-x86_64-make mingw-w64-x86_64-boost mingw-w64-x86_64-libxml2
   ```

2. **Build Server:**
   Double-click [build_windows.bat](file:///e:/Github/Yurots/build_windows.bat) or run from Command Prompt.

3. **Configure & Start:**
   Edit [config.lua](file:///e:/Github/Yurots/config.lua) and double-click [start_windows.bat](file:///e:/Github/Yurots/start_windows.bat).
   *(For detailed instructions, see the [Windows Build Guide](file:///e:/Github/Yurots/docs/windows_build_guide.md)).*

---

## [ World & Map Specifications ]

| Attribute | Specification |
| :--- | :--- |
| **Map Dimensions** | 512 x 512 tiles (~1 MB binary format) |
| **Format** | OTBM binary standard (`data/world/test.otbm`) |
| **Spawns** | ~1,000 monster and NPC spawn points (`test-spawn.xml`) |
| **Real Estate** | 36 player houses + 3 guild halls with door rights |
| **Quests Included** | 12 complete classic quests (including Annihilator) |
| **Main Temple Coordinates** | `x = 160, y = 54, z = 7` |
| **Rookgaard Temple Coordinates** | `x = 85, y = 211, z = 7` |

---

## [ In-Game Commands Reference ]

### GameMaster Commands (Access Level 2 - 3)

| Command | Syntax | Description |
| :--- | :--- | :--- |
| `/a` | `/a <squares>` | Teleport forward `<squares>` steps |
| `/B` | `/B <message>` | Red broadcast to all online players |
| `/b` | `/b <player>` | Ban player IP address |
| `/ban` | `/ban <player>` | Ban player character account |
| `/c` | `/c <player>` | Summon player directly to GM coordinates |
| `/clean` | `/clean` | Remove portable loose items from the ground |
| `/closeserver` | `/closeserver` | Close server for maintenance (GM only access) |
| `/openserver` | `/openserver` | Open server to all players |
| `/getonline` | `/getonline` | Print all online players with levels |
| `/goto` | `/goto <player> \| <x y z>` | Teleport to player or coordinates |
| `/i` | `/i <itemId> [count]` | Create item by ID |
| `/info` | `/info <player>` | Show IP and account info of player |
| `/invisible` | `/invisible` | Toggle GM invisibility state |
| `/kick` | `/kick <player>` | Disconnect player from server |
| `/m` | `/m <monster>` | Spawn a monster at current position |
| `/s` | `/s <npc>` | Spawn an NPC at current position |
| `/owner` | `/owner [player]` | Assign or clear ownership of current house |
| `/pos` | `/pos` | Print current `(X, Y, Z)` position |
| `/premmy` | `/premmy <hours> <player>` | Grant premium hours to player |
| `/promote` | `/promote <player>` | Promote player character vocation |
| `/pvp` | `/pvp <0\|1\|2>` | Set world type: `0` = No-PvP, `1` = PvP, `2` = PvP-Enforced |
| `/save` | `/save` | Force immediate global server save |
| `/shutdown` | `/shutdown <minutes>` | Schedule automatic server shutdown |
| `/up` / `/down` | `/up` / `/down` | Teleport one floor up or down |

### Player Commands (Access Level 0)

| Command | Description |
| :--- | :--- |
| `!exp` | Displays experience needed for next level |
| `!mana` | Displays mana needed for next magic level |
| `!online` | Displays count and list of online players |
| `!house` | Reloads house permissions and rights |
| `!frags` | Displays current unjustified kill count |
| `!uptime` | Displays total server uptime |
| `!premmy` | Displays remaining premium account time |
| `!report <msg>` | Sends a bug report message to the hoster |

---

## [ Guild System Keywords ]

Talk to the **Guild Master** NPC using the following keywords:

* `found` -> Found a new guild.
* `invite` -> Invite a player to your guild.
* `join` -> Accept invitation and join a guild.
* `kick` / `exclude` -> Remove a player from the guild.
* `leave` -> Voluntarily leave your current guild.
* `pass` -> Transfer guild leadership to another member.

---

## [ Architecture & Directory Structure ]

```
Yurots/
|-- build_ubuntu.sh          # Auto-detecting build script for Linux (Ubuntu/Debian)
|-- build_windows.bat        # Automated build script for Windows (MinGW-w64/MSYS2)
|-- start_windows.bat        # Windows launcher & auto-restarter on crash
|-- CMakeLists.txt           # Multi-platform CMake build configuration
|-- config.lua               # Global server configuration file
|-- docs/
|   |-- license.txt          # GPL v2 license document
|   `-- windows_build_guide.md # Step-by-step Windows build & setup guide
|-- data/
|   |-- accounts/            # XML account data files
|   |-- actions/             # Action scripts and configuration
|   |-- items/               # items.otb & items.xml item definitions
|   |-- monster/             # Monster XML definitions
|   |-- npc/                 # NPC XML definitions and Lua scripts
|   |-- players/             # XML player character records
|   |-- spells/              # Spells configuration and scripts
|   `-- world/               # OTBM map, spawns, and NPC world placements
`-- source/
    |-- Makefile             # Modernized Linux Makefile
    |-- Makefile.windows     # Windows MinGW-w64 Makefile
    |-- otserv.cpp           # Core server runtime and network loop
    `-- ...                  # Server subsystems (game, map, player, etc.)
```

---

## [ License & Credits ]

* **Original Authors:** Yurez, OpenTibia Core Team, CVS Contributors (2006).
* **Base Upstream Repository:** [divinity76/YurOTS](https://github.com/divinity76/YurOTS)
* **Modernization & 64-bit Linux Port:** Sorairei (2026).
* **License:** GNU General Public License v2 (GPLv2). See `docs/license.txt`.
