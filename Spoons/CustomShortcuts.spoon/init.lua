--- === CustomShortcuts ===
---
--- 7 atalhos personalizados para otimizar workflow no macOS
---
--- Download: https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon
--- 
--- Funcionalidades:
---   • ⌘ I → Abre arquivos/URLs/caminhos selecionados (funciona em qualquer lugar)
---   • ⌘ J → Mission Control
---   • ⌘ ⌥ ⌃ T → Digital Color Meter
---   • ⌘ ⌥ ⌃ Q → Force Quit Applications
---   • ⌘ ⌥ ⌃ A → Activity Monitor
---   • ⌘ ⌥ ⌃ P → Passwords
---   • ⌘ ⌥ ⌃ Space → Show Desktop

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "CustomShortcuts"
obj.version = "1.0"
obj.author = "Rodrigo Miranda"
obj.homepage = "https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Variables
obj.hotkeys = {}

--- Helper: retorna o diretório pai de um caminho
local function parentDir(p)
  p = p:gsub("/+$", "")               -- remove barras finais
  return p:match("(.+)/[^/]+$") or p  -- captura até a última barra
end

--- CustomShortcuts:start()
--- Method
--- Inicia todos os atalhos personalizados
---
--- Parameters:
---  * None
---
--- Returns:
---  * The CustomShortcuts object
function obj:start()
  -- ⌘ I → Abrir arquivos/URLs/caminhos selecionados
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd"}, "i", function()
    -- Primeiro tenta pegar texto selecionado (URL/caminho)
    hs.eventtap.keyStroke({"cmd"}, "c")
    
    hs.timer.doAfter(0.3, function()
      local selectedText = hs.pasteboard.getContents()
      
      -- Se há texto selecionado, tenta abrir como caminho/URL
      if selectedText and selectedText ~= "" then
        selectedText = selectedText:match("^%s*(.-)%s*$")  -- trim
        selectedText = selectedText:gsub("^file://", "")   -- remove prefixo file://
        
        -- Verifica se é um caminho válido
        local attr = hs.fs.attributes(selectedText)
        if attr then
          -- Se for arquivo, abre a pasta-mãe
          if attr.mode ~= "directory" then
            selectedText = parentDir(selectedText)
          end
          hs.execute('open "' .. selectedText .. '"')
          hs.alert("📂 Abrindo caminho: " .. selectedText)
          return
        end
        
        -- Se não é caminho válido, tenta como URL
        if selectedText:match("^https?://") or selectedText:match("^www%.") then
          hs.execute('open "' .. selectedText .. '"')
          hs.alert("🌐 Abrindo URL: " .. selectedText)
          return
        end
      end
      
      -- Se não há texto válido, tenta item selecionado no Finder
      local script = [[
        tell application "Finder"
          set sel to selection
          if sel is {} then return ""
          set theItem to item 1 of sel
          return POSIX path of (theItem as alias)
        end tell
      ]]
      local ok, result = hs.osascript.applescript(script)
      if ok and result ~= "" then
        result = result:match("^%s*(.-)%s*$")  -- trim
        hs.execute('open "' .. result .. '"')
        hs.alert("📂 Abrindo do Finder: " .. result)
      else
        hs.alert("⚠️ Nenhum arquivo/URL/caminho válido selecionado")
      end
    end)
  end)

  -- ⌘ J → Mission Control
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd"}, "j", function()
    hs.execute("open -b com.apple.exposelauncher")
    hs.alert("📱 Mission Control")
  end)

  -- ⌘ ⌥ ⌃ T → Digital Color Meter
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd","alt","ctrl"}, "t", function()
    hs.execute("osascript -e 'tell application \"Digital Color Meter\" to activate'")
    hs.alert("🎨 Digital Color Meter aberto\n(⌘+L para lock/copy)")
  end)

  -- ⌘ ⌥ ⌃ Q → Force Quit Applications
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd","alt","ctrl"}, "q", function()
    hs.execute("osascript -e 'tell application \"System Events\" to key code 53 using {command down, option down}'")
    hs.alert("💀 Force Quit Applications")
  end)

  -- ⌘ ⌥ ⌃ A → Activity Monitor
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd","alt","ctrl"}, "a", function()
    hs.execute("open -a 'Activity Monitor'")
    hs.alert("📊 Activity Monitor")
  end)

  -- ⌘ ⌥ ⌃ P → Passwords
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd","alt","ctrl"}, "p", function()
    hs.execute("open -a 'Passwords'")
    hs.alert("🔐 Passwords")
  end)

  -- ⌘ ⌥ ⌃ Space → Show Desktop
  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd","alt","ctrl"}, "space", function()
    hs.execute("osascript -e 'tell application \"System Events\" to key code 103 using function down'")
    hs.alert("🖥️ Show Desktop")
  end)

  hs.alert("🔨 CustomShortcuts carregado! 7 atalhos ativos.")
  return self
end

--- CustomShortcuts:stop()
--- Method
--- Para todos os atalhos personalizados
---
--- Parameters:
---  * None
---
--- Returns:
---  * The CustomShortcuts object
function obj:stop()
  for _, hotkey in ipairs(self.hotkeys) do
    hotkey:delete()
  end
  self.hotkeys = {}
  hs.alert("🔨 CustomShortcuts descarregado")
  return self
end

return obj
