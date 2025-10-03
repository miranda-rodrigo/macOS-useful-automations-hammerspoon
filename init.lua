--------------------------------------------------------------------
-- 🔨  Hammerspoon – Atalhos Personalizados (13 atalhos)
--------------------------------------------------------------------
-- 1. ⌘ I            → Abrir arquivos/URLs/caminhos
-- 2. ⌘ J            → Mission Control
-- 3. ⌘ ⌥ ⌃ T        → Digital Color Meter
-- 4. ⌘ ⌥ ⌃ Q        → Force Quit
-- 5. ⌘ ⌥ ⌃ A        → Activity Monitor
-- 6. ⌘ ⌥ ⌃ P        → Passwords
-- 7. ⌘ ⌥ ⌃ Space    → Show Desktop
-- 8. ⌘ ⇧ U / var.   → Encurtador de URLs  (TinyURL / QR / Bit.ly)
-- 9. ⌘ ⇧ W          → Copiar caminho do Finder
-- 10. ⌘ ⌥ ⌃ R       → Text Replacement (Configurações)
-- 11. ⇧ ⌃ ⌘ R       → OCR Reader (captura área da tela)
-- 12. ⇧ ⌃ ⌘ F       → OCR de imagem no clipboard
-- 13. ⇧ ⌃ ⌘ Y       → Transcrever vídeo do YouTube
--------------------------------------------------------------------

--------------------------------------------------------------------
-- Helper: diretório-pai de um caminho
--------------------------------------------------------------------
local function parent_dir(p)
  p = p:gsub("/+$", "")
  return p:match("(.+)/[^/]+$") or p
end

--------------------------------------------------------------------
-- Helper: valida URL simples
--------------------------------------------------------------------
local function is_url(u) return u and u:match("^https?://") end

--------------------------------------------------------------------
-- Helper: TinyURL (usando curl - mais confiável)
--------------------------------------------------------------------
local function shorten_tiny(url)
  local escapedUrl = url:gsub("([^%w%.%-%_])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  
  local cmd = string.format('curl -s "https://tinyurl.com/api-create.php?url=%s"', escapedUrl)
  local handle = io.popen(cmd)
  if not handle then return nil end
  
  local result = handle:read("*a")
  handle:close()
  
  if result and result ~= "" then
    return result:gsub("%s+", "") -- trim whitespace
  end
  return nil
end

--------------------------------------------------------------------
-- Helper: Bit.ly  (adicione seu token se quiser)
--------------------------------------------------------------------
local BITLY_TOKEN = nil   -- coloque aqui se tiver → "xxxxxxxxxxxxxxxxxxxx"
local function shorten_bitly(url)
  if not BITLY_TOKEN then return nil,"token ausente" end
  local body = string.format('{"long_url":"%s"}', url)
  local hdrs = {
    ["Authorization"] = "Bearer " .. BITLY_TOKEN,
    ["Content-Type"]  = "application/json"
  }
  local ok, res = hs.http.doRequest(
        "https://api-ssl.bitly.com/v4/shorten", "POST", body, hdrs)
  local link = res and res:match('%"link"%s*:%s*%"([^"]+)"')
  return ok and link or nil
end

--------------------------------------------------------------------
-- Helper: gera QR-Code no navegador
--------------------------------------------------------------------
local function open_qr(url)
  local escapedUrl = url:gsub("([^%w%.%-%_])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  local qrUrl = string.format("https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=%s", escapedUrl)
  hs.execute(string.format('open "%s"', qrUrl))
end

--------------------------------------------------------------------
-- SECTION 1 ─ Abrir arquivos / URLs  (⌘ I)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd"}, "i", function()
  hs.eventtap.keyStroke({"cmd"}, "c")
  hs.timer.doAfter(0.3, function()
    local sel = hs.pasteboard.getContents()
    if sel and sel~="" then
      sel = sel:match("^%s*(.-)%s*$"):gsub("^file://","")
      if hs.fs.attributes(sel) then           -- caminho válido
        if hs.fs.attributes(sel).mode~="directory" then sel = parent_dir(sel) end
        hs.execute('open "'..sel..'"'); hs.alert("📂 "..sel); return
      end
      if is_url(sel) or sel:match("^www%.") then
        hs.execute('open "'..sel..'"'); hs.alert("🌐 "..sel); return
      end
    end
    local script=[[
      tell application "Finder"
        if (count of selection)=0 then return ""
        POSIX path of (item 1 of selection as alias)
      end tell]]
    local ok,res=hs.osascript.applescript(script)
    if ok and res~="" then hs.execute('open "'..res..'"')
    else hs.alert("⚠️ Nada selecionado") end
  end)
end)

--------------------------------------------------------------------
-- SECTION 2 ─ Mission Control  (⌘ J)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd"}, "j",
  function() hs.execute("open -b com.apple.exposelauncher"); hs.alert("📱 Mission Control") end)

--------------------------------------------------------------------
-- SECTION 3 ─ Digital Color Meter  (⌘ ⌥ ⌃ T)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","alt","ctrl"}, "t",
  function() hs.execute([[osascript -e 'tell application "Digital Color Meter" to activate']])
           hs.alert("🎨 Digital Color Meter") end)

--------------------------------------------------------------------
-- SECTION 4 ─ Force Quit  (⌘ ⌥ ⌃ Q)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","alt","ctrl"}, "q", function()
  -- Método mais confiável para Force Quit
  hs.execute([[osascript -e 'tell application "System Events" to key code 53 using {command down, option down}']])
  hs.alert("💀 Force Quit Applications")
end)

--------------------------------------------------------------------
-- SECTION 5 ─ Activity Monitor  (⌘ ⌥ ⌃ A)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","alt","ctrl"}, "a",
  function() hs.execute("open -a 'Activity Monitor'"); hs.alert("📊 Activity Monitor") end)

--------------------------------------------------------------------
-- SECTION 6 ─ Passwords  (⌘ ⌥ ⌃ P)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","alt","ctrl"}, "p",
  function() hs.execute("open -a 'Passwords'"); hs.alert("🔐 Passwords") end)

--------------------------------------------------------------------
-- SECTION 7 ─ Show Desktop  (⌘ ⌥ ⌃ Space)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","alt","ctrl"}, "space", function()
  -- Tenta F11 e depois fn+F11; em seguida, fallback para ocultar outros apps
  local function tryF11()
    hs.eventtap.keyStroke({}, "F11", 0)
    hs.timer.doAfter(0.12, function() hs.eventtap.keyStroke({"fn"}, "F11", 0) end)
  end
  local function hideOthers()
    local front = hs.application.frontmostApplication()
    if front then
      front:hideOthers()
    else
      for _, app in ipairs(hs.application.runningApplications()) do
        if app:bundleID() ~= "com.apple.finder" then app:hide() end
      end
    end
  end
  pcall(tryF11)
  hs.timer.doAfter(0.25, function() hideOthers() end)
  hs.alert("🖥️ Show Desktop")
end)

--------------------------------------------------------------------
-- SECTION 8 ─ URL Shortener  (⌘ ⇧ U  / var.)
--------------------------------------------------------------------
-- ⌘ ⇧ U  → TinyURL
hs.hotkey.bind({"cmd","shift"}, "u", function()
  hs.eventtap.keyStroke({"cmd"}, "c")
  hs.timer.doAfter(0.3, function()
    local url = hs.pasteboard.getContents()
    if not is_url(url) then return hs.alert("⚠️ Selecione URL válida") end
    hs.alert("🔄 Encurtando…")
    local s = shorten_tiny(url)
    if s then hs.pasteboard.setContents(s); hs.alert("🔗 Copiado!\n"..s,3)
    else     hs.alert("❌ TinyURL falhou") end
  end)
end)

-- ⌘ ⇧ ⌥ U  → TinyURL + QR
hs.hotkey.bind({"cmd","shift","alt"}, "u", function()
  hs.eventtap.keyStroke({"cmd"}, "c")
  hs.timer.doAfter(0.3, function()
    local url = hs.pasteboard.getContents()
    if not is_url(url) then return hs.alert("⚠️ Selecione URL válida") end
    hs.alert("🔄 Encurtando…")
    local s = shorten_tiny(url)
    if s then
      hs.pasteboard.setContents(s)
      hs.alert("🔗 Copiado!\n"..s,3)
      hs.timer.doAfter(1, function() open_qr(s) end)
    else hs.alert("❌ TinyURL falhou") end
  end)
end)

-- ⌘ ⇧ ⌃ U  → Bit.ly
hs.hotkey.bind({"cmd","shift","ctrl"}, "u", function()
  if not BITLY_TOKEN then return hs.alert("⚠️ Configure BITLY_TOKEN") end
  hs.eventtap.keyStroke({"cmd"}, "c")
  hs.timer.doAfter(0.3, function()
    local url = hs.pasteboard.getContents()
    if not is_url(url) then return hs.alert("⚠️ Selecione URL válida") end
    hs.alert("🔄 Encurtando (Bit.ly)…")
    local s,err = shorten_bitly(url)
    if s then hs.pasteboard.setContents(s); hs.alert("🔗 Copiado!\n"..s,3)
    else     hs.alert("❌ Bit.ly erro: "..(err or "?")) end
  end)
end)

--------------------------------------------------------------------
-- SECTION 9 ─ Copiar Caminho do Finder  (⌘ ⇧ W)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","shift"}, "w", function()
  local script = [[
    tell application "Finder"
      set sel to selection
      if sel is {} then
        -- Se nada selecionado, pega a pasta atual
        set currentFolder to target of front window
        return POSIX path of (currentFolder as alias)
      else
        -- Se algo selecionado, pega o primeiro item
        set theItem to item 1 of sel
        return POSIX path of (theItem as alias)
      end if
    end tell
  ]]
  
  local ok, result = hs.osascript.applescript(script)
  if ok and result ~= "" then
    result = result:match("^%s*(.-)%s*$")  -- trim whitespace
    hs.pasteboard.setContents(result)
    hs.alert("📋 Caminho copiado!\n" .. result, 3)
  else
    hs.alert("⚠️ Erro ao obter caminho do Finder")
  end
end)

--------------------------------------------------------------------
-- SECTION 10 ─ Text Replacement (Configurações)  (⌘ ⌥ ⌃ R)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","alt","ctrl"}, "r", function()
  -- Abre diretamente o painel Text Replacement nas Configurações do Sistema
  hs.execute("open 'x-apple.systempreferences:com.apple.preference.keyboard?Text'")
  hs.alert("⌨️ Text Replacement")
end)

--------------------------------------------------------------------
-- SECTION 13 ─ Abrir Terminal e colar texto  (⌘ ⇧ T)
--------------------------------------------------------------------
hs.hotkey.bind({"cmd","shift"}, "t", function()
  -- Primeiro copia o texto selecionado
  hs.eventtap.keyStroke({"cmd"}, "c")
  
  hs.timer.doAfter(0.3, function()
    local selectedText = hs.pasteboard.getContents()
    
    if not selectedText or selectedText == "" then
      hs.alert("⚠️ Nenhum texto selecionado")
      return
    end
    
    -- Remove quebras de linha extras e espaços desnecessários
    selectedText = selectedText:gsub("^%s*(.-)%s*$", "%1") -- trim
    
    if selectedText == "" then
      hs.alert("⚠️ Texto vazio após limpeza")
      return
    end
    
    -- Coloca o texto no clipboard
    hs.pasteboard.setContents(selectedText)
    
    -- Abre e foca o Terminal (mais confiável que execute)
    hs.application.launchOrFocus("Terminal")
    
    -- Aguarda o Terminal ficar em primeiro plano antes de colar
    local maxWait = 20  -- 2 segundos (20 x 0.1s)
    local waitCount = 0
    
    local checkFocus = function()
      local frontApp = hs.application.frontmostApplication()
      if frontApp and frontApp:name() == "Terminal" then
        -- Terminal está em foco, pode colar
        hs.eventtap.keyStroke({"cmd"}, "v")
        
        -- Mostra confirmação
        local preview = selectedText
        if #preview > 60 then
          preview = preview:sub(1, 60) .. "..."
        end
        hs.alert("🖥️ Terminal aberto!\n📋 " .. preview, 3)
        return true
      end
      return false
    end
    
    -- Tenta imediatamente
    if not checkFocus() then
      -- Se não focou ainda, fica checando de 0.1 em 0.1s
      local timer = hs.timer.doUntil(
        function()
          waitCount = waitCount + 1
          return checkFocus() or waitCount >= maxWait
        end,
        function()
          if waitCount >= maxWait then
            hs.alert("⚠️ Timeout ao focar Terminal")
          end
        end,
        0.1  -- checa a cada 0.1 segundo
      )
    end
  end)
end)

--------------------------------------------------------------------
-- SECTION 14 ─ YouTube Transcriber (⇧ ⌃ ⌘ Y) - usando Spoon
--------------------------------------------------------------------
hs.loadSpoon("YouTubeTranscriber")
spoon.YouTubeTranscriber:start()

--------------------------------------------------------------------
hs.alert("🔨 Atalhos Hammerspoon carregados! (13 ativos)")
--------------------------------------------------------------------
