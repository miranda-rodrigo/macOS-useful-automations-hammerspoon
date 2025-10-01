--------------------------------------------------------------------
-- 🔨 Hammerspoon Configuration Example
-- Copy this file to ~/.hammerspoon/init.lua to use
--------------------------------------------------------------------

--------------------------------------------------------------------
-- OPTION 1: Use as Spoons (RECOMMENDED - Modular & Clean)
--------------------------------------------------------------------
-- Install Spoons:
--   cp -r CustomShortcuts.spoon ~/.hammerspoon/Spoons/
--   cp -r URLShortener.spoon ~/.hammerspoon/Spoons/

-- Load CustomShortcuts (7 core shortcuts)
hs.loadSpoon("CustomShortcuts")
spoon.CustomShortcuts:start()

-- Load URLShortener (optional - 3 URL shortening shortcuts)
hs.loadSpoon("URLShortener")
spoon.URLShortener:start()

-- Optional: Configure Bit.ly token for premium shortening
-- spoon.URLShortener:setBitlyToken("your_bitly_api_token_here")

--------------------------------------------------------------------
-- OPTION 2: Use as standalone script (Alternative)
--------------------------------------------------------------------
-- Uncomment and copy the contents of init.lua to here instead
-- (Not recommended for sharing/distribution)

--------------------------------------------------------------------
-- Configuration Complete!
--------------------------------------------------------------------
hs.alert("🔨 Hammerspoon loaded successfully!")

-- Optional: Show console on startup (useful for debugging)
-- hs.console.clearConsole()
-- hs.console.show()

--------------------------------------------------------------------
-- Troubleshooting Functions
--------------------------------------------------------------------

-- Test if shortcuts are working
local function testShortcuts()
  hs.alert("Testing shortcuts...\nIf you see this, Hammerspoon is working! ✅")
end

-- Check permissions
local function checkPermissions()
  local hasAccessibility = hs.accessibilityState()
  local msg = "Accessibility: " .. (hasAccessibility and "✅ Enabled" or "❌ Disabled")
  hs.alert(msg, 3)
  return hasAccessibility
end

-- Reload configuration
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
  hs.reload()
end)

-- Show this help
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", function()
  hs.alert([[
🔨 Hammerspoon Shortcuts Help

Core Shortcuts:
⌘ I          → Open files/URLs
⌘ J          → Mission Control
⌘ ⌥ ⌃ T      → Color Picker
⌘ ⌥ ⌃ Q      → Force Quit
⌘ ⌥ ⌃ A      → Activity Monitor
⌘ ⌥ ⌃ P      → Passwords
⌘ ⌥ ⌃ Space  → Show Desktop

URL Shortener (if loaded):
⌘ ⇧ U        → TinyURL
⌘ ⇧ ⌥ U      → TinyURL + QR
⌘ ⇧ ⌃ U      → Bit.ly

System:
⌘ ⌥ ⌃ R      → Reload config
⌘ ⌥ ⌃ H      → This help
  ]], 8)
end)

--------------------------------------------------------------------
-- Auto-reload configuration when files change (optional)
--------------------------------------------------------------------
local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

-- Watch ~/.hammerspoon/ for changes
local configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configWatcher:start()

hs.alert("🔄 Auto-reload enabled")
