<h1 align="center">🚫 JRP-TakeHostage 🛡️</h1>

<p align="center">
  <img src="https://img.shields.io/badge/FiveM-Ready-blue?style=for-the-badge" alt="FiveM Ready">
  <img src="https://img.shields.io/badge/Lua-5.4-green?style=for-the-badge" alt="Lua 5.4">
  <img src="https://img.shields.io/badge/GTA_V-Compatible-red?style=for-the-badge" alt="GTA V Compatible">
</p>

<p align="center">
  <span style="color: #ff6b6b; font-size: 18px;">🔫 A FiveM script for GTA V that allows players to take hostages at gunpoint, with animations, controls, and server-side synchronization. Developed by the <strong style="color: #4ecdc4;">JGN Development Team</strong> for the JRP Server. 🚀</span>
</p>

## ✨ Features

- **🎯 Hostage Taking**: Players can take nearby players as hostages using pistols with ammo.
- **🎭 Animations & Controls**: Smooth animations for both aggressor and hostage, with disabled controls for realism.
- **🔄 Release/Kill Options**: Aggressors can release or kill hostages via keybinds (<span style="color: #74b9ff;">G</span> to release, <span style="color: #ff7675;">H</span> to kill).
- **🔒 ACE Permissions**: Restricted to players with the "jrp.takehostage" permission (e.g., VIP groups).
- **🔔 Notifications**: In-game notifications for errors, permissions, and actions.
- **🔄 Server-Side Sync**: Handles hostage states, player drops, and cleanup.
- **⚡ Optimized**: Clean code, latest natives, and performance improvements.

## 📦 Installation

1. 📥 Download the script files.
2. 📁 Place the `JRP-TakeHostage` folder in your FiveM server's `resources` directory.
3. ⚙️ Add `ensure JRP-TakeHostage` to your `server.cfg`.
4. 🔑 Set up ACE permissions in `server.cfg` (e.g., `add_ace group.pvip "jrp.takehostage" allow` for Platinum VIP).
5. 🔄 Restart your server.

## 🎮 Usage

- **💬 Commands**: `/takehostage` or `/th` to initiate hostage-taking (requires permission and a pistol with ammo).
- **🎛️ Controls** (as aggressor): Press <span style="color: #74b9ff;">G</span> to release, <span style="color: #ff7675;">H</span> to kill.
- **🔐 Permissions**: Only players with the "jrp.takehostage" ACE permission can use the command. Denied users see a custom message.

## 📝 Changelog

Compared to the original script:

- **⚡ Optimizations**:
  - Updated to latest FiveM natives (e.g., `BeginTextCommandDisplayHelp` for notifications).
  - Cleaned code: Removed old comments, fixed spelling ("agressor" to "aggressor"), localized variables, cached player ped for performance.
  - Used `Citizen.Wait` for consistency.
  - Early returns in functions to avoid unnecessary checks.

- **🆕 New Additions**:
  - ACE permission system: Commands now check `IsAceAllowed` server-side for security.
  - Custom permission denial message: <span style="color: #ff7675;">"~r~JRP Platinum VIP Required! ~w~Buy it from the ~g~Server Store~w~!"</span>
  - Styled on-screen text: <span style="color: #74b9ff;">"~b~[G]~w~ Release Hostage  ~r~[H]~w~ Kill Hostage"</span> with colors.
  - Updated manifest: `fx_version 'adamant'`, new author/description/version.

- **🐛 Fixes**:
  - Resolved syntax errors (duplicate code blocks).
  - Removed duplicate entries in manifest.
  - Improved error handling and notifications.

- **🔧 Other**:
  - New header: "done by the JGN Development Team made for the JRP Server etc"
  - Minimal explanatory comments added for clarity.

## 📋 Requirements

- 🖥️ FiveM server (latest recommended).
- 🎮 GTA V game.

## 🙏 Credits

- Original script by <span style="color: #a29bfe;">Robbster</span>.
- Updated and optimized by <span style="color: #4ecdc4;">JGN Development Team</span> for JRP Server.

## 📜 License

<span style="color: #ff7675;">🚫 Do not redistribute without permission.</span>