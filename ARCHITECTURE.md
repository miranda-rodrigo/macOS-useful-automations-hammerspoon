# 🏗️ Architecture & Code Organization

## Overview

Este projeto fornece 8 atalhos universais para macOS via Hammerspoon, com foco em **confiabilidade, modularidade e facilidade de manutenção**.

---

## 📂 Structure

```
.
├── Spoons/                          # Modular Spoons (RECOMMENDED)
│   ├── CustomShortcuts.spoon/       # 7 core system shortcuts
│   │   └── init.lua
│   └── URLShortener.spoon/          # 3 URL shortening shortcuts
│       └── init.lua
│
├── CustomShortcuts.spoon/           # (duplicate - for backward compatibility)
│   └── init.lua
│
├── init.lua                         # Standalone script (alternative approach)
├── init.example.lua                 # Example configuration for users
│
├── docs/
│   └── spoons_cheat_sheet.html     # Visual interactive guide
│
├── README.md                        # Main documentation
├── TROUBLESHOOTING.md               # Problem-solving guide
├── ARCHITECTURE.md                  # This file
└── LICENSE                          # MIT License
```

---

## 🎯 Design Philosophy

### 1. **Spoons vs Standalone Scripts**

| Aspect | Spoons (Modular) | Standalone Script |
|--------|------------------|-------------------|
| **Reusability** | ✅ High - can be shared via Spoon repository | ❌ Low - user must copy entire file |
| **Modularity** | ✅ Independent modules with start/stop lifecycle | ❌ Single monolithic file |
| **Maintainability** | ✅ Each Spoon can be updated independently | ⚠️ Must maintain entire file |
| **Community Standard** | ✅ Official Hammerspoon standard | ⚠️ Ad-hoc approach |
| **Versioning** | ✅ Each Spoon has version metadata | ❌ No built-in versioning |
| **Documentation** | ✅ Follows Hammerdocs convention | ⚠️ Freeform comments |
| **Testing** | ✅ Can enable/disable individual Spoons | ❌ Must comment out sections |

**Recommendation:** Use Spoons for any project meant to be shared publicly.

---

### 2. **Why Both Approaches?**

This project provides BOTH:

1. **Spoons** (`Spoons/` folder)
   - Best for: Public distribution, GitHub repos, Spoon repositories
   - Target audience: Community, other developers
   - Easy to install: `cp -r *.spoon ~/.hammerspoon/Spoons/`

2. **Standalone script** (`init.lua`)
   - Best for: Personal use, quick prototyping, learning
   - Target audience: Single user, local experimentation
   - Easy to modify: Just edit one file

**For this repository:** We recommend Spoons as the primary method.

---

## 🔧 Code Organization

### Spoon Structure

Each Spoon follows Hammerspoon conventions:

```lua
--- === SpoonName ===
---
--- Description
---
--- Download: https://github.com/...
--- 
--- Features:
---   • Feature 1
---   • Feature 2

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "SpoonName"
obj.version = "1.0"
obj.author = "Author Name"
obj.homepage = "https://..."
obj.license = "MIT"

-- Variables
obj.hotkeys = {}
obj.config = {}

--- SpoonName:start()
--- Method
--- Start the Spoon
function obj:start()
  -- Setup hotkeys
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind(...)
  return self
end

--- SpoonName:stop()
--- Method
--- Stop the Spoon
function obj:stop()
  for _, hotkey in ipairs(self.hotkeys) do
    hotkey:delete()
  end
  self.hotkeys = {}
  return self
end

return obj
```

**Key principles:**
1. **Metadata** - Name, version, author, license
2. **State management** - Track hotkeys in `obj.hotkeys` table
3. **Lifecycle methods** - `start()` and `stop()`
4. **Documentation** - Follow Hammerdocs format (`--- `)
5. **Return object** - Always `return obj` at end

---

## 🛠️ Technical Decisions

### 1. **Why `hs.execute()` instead of native APIs?**

**Problem:** Native Hammerspoon APIs sometimes conflict with system shortcuts or require complex permission setups.

**Solution:** Use shell commands via `hs.execute()` for maximum reliability.

**Example:**
```lua
-- ❌ Can fail due to permission issues or conflicts
hs.application.launchOrFocus("Activity Monitor")

-- ✅ More reliable - uses macOS native `open` command
hs.execute("open -a 'Activity Monitor'")
```

**Benefits:**
- Works universally across macOS versions
- Fewer permission requirements
- Predictable behavior
- Easy to test in Terminal first

**Trade-offs:**
- Slightly slower (spawns shell process)
- Less "pure" Lua approach
- Harder to mock in tests

**Verdict:** Reliability > Purity → Use `hs.execute()` where appropriate

---

### 2. **Why AppleScript for some commands?**

**Problem:** Some macOS features are only accessible via AppleScript or specific key codes.

**Examples:**
```lua
-- Force Quit requires specific key code (53 = Esc)
hs.execute([[osascript -e 'tell application "System Events" to key code 53 using {command down, option down}']])

-- Digital Color Meter needs AppleScript activation
hs.execute([[osascript -e 'tell application "Digital Color Meter" to activate']])
```

**Benefits:**
- Direct access to macOS System Events
- Can simulate exact keyboard shortcuts
- Works with apps that don't expose APIs

---

### 3. **Why multiple fallback strategies?**

**Problem:** macOS configuration varies by user (shortcuts disabled, different key mappings, etc.)

**Solution:** Try multiple methods with graceful fallbacks.

**Example (Show Desktop):**
```lua
hs.hotkey.bind({"cmd","alt","ctrl"}, "space", function()
  -- Method 1: Try AppleScript keystroke
  local success = hs.osascript.applescript([[
    tell application "System Events"
      keystroke "d" using {command down, option down, control down}
    end tell
  ]])
  
  -- Method 2: Fallback to native API
  if not success then
    hs.spaces.toggleShowDesktop()
  end
  
  hs.alert("🖥️ Show Desktop")
end)
```

**Benefits:**
- Works for more users out-of-the-box
- Graceful degradation
- Better user experience

---

### 4. **Why `io.popen()` for TinyURL instead of `hs.http`?**

**Problem:** `hs.http` is asynchronous and adds complexity. TinyURL API is simple HTTP GET.

**Solution:** Use synchronous `io.popen()` + `curl` for simplicity.

```lua
local function shorten_tiny(url)
  local escapedUrl = url:gsub("([^%w%.%-%_])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  
  local cmd = string.format('curl -s -L -m 10 "https://tinyurl.com/api-create.php?url=%s"', escapedUrl)
  local handle = io.popen(cmd)
  if not handle then return nil end
  
  local result = handle:read("*a")
  handle:close()
  
  if result and result ~= "" and not result:match("Error") then
    result = result:gsub("%s+", "")
    if result:match("^https?://") then
      return result
    end
  end
  return nil
end
```

**Benefits:**
- Simpler code (no callbacks)
- Easier to debug (`curl` command can be tested in Terminal)
- Timeout control (`-m 10`)
- Works with proxy/VPN setups automatically

**Trade-offs:**
- Blocks Lua thread (acceptable for sub-second operations)
- Requires `curl` installed (macOS has it by default)

---

## 🔐 Security Considerations

### 1. **API Tokens**

**Bit.ly requires API token:**
```lua
-- ❌ DON'T hardcode tokens in public repos
local BITLY_TOKEN = "abc123secret"

-- ✅ DO provide setter method
function obj:setBitlyToken(token)
    self.bitlyToken = token
    return self
end
```

**User sets token in their config:**
```lua
hs.loadSpoon("URLShortener")
spoon.URLShortener:setBitlyToken("user_token_here")
spoon.URLShortener:start()
```

---

### 2. **Shell Command Injection**

**Problem:** User input in shell commands can be exploited.

**Solution:** Properly escape shell arguments.

```lua
-- ❌ DANGEROUS - injection risk
hs.execute('curl "' .. userInput .. '"')

-- ✅ SAFE - URL encode special characters
local escapedUrl = url:gsub("([^%w%.%-%_])", function(c)
  return string.format("%%%02X", string.byte(c))
end)
local cmd = string.format('curl -s "https://tinyurl.com/api-create.php?url=%s"', escapedUrl)
```

---

### 3. **HTTPS vs HTTP**

**Always use HTTPS for external APIs:**
```lua
-- ❌ Insecure
curl "http://tinyurl.com/api-create.php?url=..."

-- ✅ Secure
curl "https://tinyurl.com/api-create.php?url=..."
```

---

## 🧪 Testing Strategy

### Manual Testing

**Each shortcut should be tested:**
1. ✅ Works in multiple apps (Finder, Chrome, Terminal, etc.)
2. ✅ Shows appropriate alert message
3. ✅ Handles errors gracefully (no URL selected, permission denied, etc.)
4. ✅ Doesn't conflict with system shortcuts

**Test matrix:**
```bash
# Test URL opening
echo "https://github.com" | pbcopy
# Press ⌘ I → should open in browser

# Test TinyURL
echo "https://github.com/hammerspoon/hammerspoon" | pbcopy
# Press ⌘ ⇧ U → should return short URL

# Test Force Quit
# Press ⌘ ⌥ ⌃ Q → Force Quit dialog should open

# etc.
```

### Automated Testing (Future)

Hammerspoon supports `busted` for unit testing:
```lua
-- tests/shortcuts_spec.lua
describe("CustomShortcuts", function()
  it("should load without errors", function()
    local spoon = hs.loadSpoon("CustomShortcuts")
    assert.is_not_nil(spoon)
  end)
  
  it("should start successfully", function()
    local spoon = hs.loadSpoon("CustomShortcuts")
    local result = spoon:start()
    assert.equals(result, spoon)
  end)
end)
```

---

## 📊 Performance Considerations

### 1. **Hotkey Registration**

**Efficient approach:**
```lua
-- Store hotkeys in table for easy cleanup
self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind(...)
```

### 2. **Clipboard Operations**

**Problem:** `hs.pasteboard.getContents()` immediately after `⌘ C` may get old clipboard.

**Solution:** Use timer delay:
```lua
hs.eventtap.keyStroke({"cmd"}, "c")
hs.timer.doAfter(0.3, function()  -- 300ms delay
  local contents = hs.pasteboard.getContents()
  -- ...
end)
```

### 3. **Shell Command Timeouts**

**Always set timeouts for external commands:**
```lua
curl -s -L -m 10 "..."  -- 10 second timeout
```

---

## 🚀 Future Improvements

### Potential Enhancements

1. **Configuration File**
   - JSON/YAML config for shortcuts
   - User can customize without editing Lua

2. **Localization**
   - Support for multiple languages
   - Configurable alert messages

3. **Shortcut Conflicts Detection**
   - Warn user if shortcut conflicts with system/app
   - Suggest alternatives

4. **Visual Shortcut Editor**
   - GUI for managing shortcuts (like BetterTouchTool)
   - Hammerspoon Chooser-based interface

5. **More URL Shorteners**
   - is.gd, v.gd, Rebrandly
   - Custom URL shortener support

6. **Analytics**
   - Track most-used shortcuts
   - Optimize workflow

7. **Cloud Sync**
   - Sync configuration across machines
   - iCloud Drive integration

---

## 📚 Resources

### Hammerspoon Documentation
- Official docs: https://www.hammerspoon.org/docs/
- Spoons: https://www.hammerspoon.org/Spoons/
- Getting started: https://www.hammerspoon.org/go/

### Lua Language
- Lua 5.4 reference: https://www.lua.org/manual/5.4/
- Learn Lua in 15 minutes: https://tylerneylon.com/a/learn-lua/

### macOS Automation
- AppleScript guide: https://developer.apple.com/library/archive/documentation/AppleScript/
- Keyboard shortcuts: https://support.apple.com/en-us/HT201236

---

## 🤝 Contributing

### Code Style

1. **Indentation:** 2 spaces (standard Lua)
2. **Naming:** `camelCase` for functions, `snake_case` for local variables
3. **Comments:** Use `---` for documentation, `--` for inline comments
4. **Strings:** Double quotes `"..."` for user-facing text, single `'...'` for code

### Spoon Guidelines

1. Always include metadata (name, version, author, license)
2. Implement `start()` and `stop()` methods
3. Track hotkeys in `obj.hotkeys` table
4. Use Hammerdocs format for documentation
5. Test on multiple macOS versions

### Pull Request Checklist

- [ ] Code follows project style
- [ ] All shortcuts tested manually
- [ ] README updated if adding features
- [ ] No hardcoded secrets/tokens
- [ ] Error handling for edge cases
- [ ] Appropriate alerts for user feedback

---

**Questions?** Open an issue on GitHub!
