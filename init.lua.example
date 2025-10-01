--------------------------------------------------------------------
-- 📌 Hammerspoon Custom Shortcuts
--
-- Funcionalidades:
--   1. ⌘ I → Abre arquivos/URLs/caminhos selecionados (funciona em qualquer lugar).
--   2. ⌘ J → Mostra todos os Desktops/Mission Control (via terminal - mais confiável).
--   3. ⌘ ⌥ ⌃ T → Digital Color Meter nativo (use ⌘+L para copiar).
--   4. ⌘ ⌥ ⌃ Q → Force Quit Applications (mata apps travados).
--   5. ⌘ ⌥ ⌃ A → Activity Monitor (monitor de processos).
--   6. ⌘ ⌥ ⌃ P → Passwords (gerenciador de senhas nativo).
--   7. ⌘ ⌥ ⌃ Space → Show Desktop (esconde todas as janelas).
--
-- Uso:
--   - Para abrir arquivos/URLs: selecione texto (URL/caminho) OU arquivo no Finder e pressione ⌘ I.
--   - Para ver os Desktops: pressione ⌘ J (usa comando terminal).
--   - Para color picker nativo: pressione ⌘ ⌥ ⌃ T (abre Digital Color Meter, use ⌘+L para copiar).
--   - Para force quit: pressione ⌘ ⌥ ⌃ Q (abre janela para matar apps).
--   - Para Activity Monitor: pressione ⌘ ⌥ ⌃ A (monitor de processos e CPU).
--   - Para Passwords: pressione ⌘ ⌥ ⌃ P (gerenciador de senhas).
--   - Para mostrar Desktop: pressione ⌘ ⌥ ⌃ Space (esconde todas as janelas).
--------------------------------------------------------------------

-- ====================================================================
-- Helper: retorna o diretório pai de um caminho
-- ====================================================================
local function parentDir(p)
  p = p:gsub("/+$", "")               -- remove barras finais
  return p:match("(.+)/[^/]+$") or p  -- captura até a última barra
end

-- ====================================================================
-- SECTION 1: Abrir item selecionado no Finder ou URL/caminho selecionado (⌘ I)
-- ====================================================================
hs.hotkey.bind({"cmd"}, "i", function()
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

-- ====================================================================
-- SECTION 2: Mostrar todos os Desktops (⌘ J → Mission Control)
-- ====================================================================
hs.hotkey.bind({"cmd"}, "j", function()
  -- Usa comando de terminal para abrir Mission Control (mais confiável)
  hs.execute("open -b com.apple.exposelauncher")
  hs.alert("📱 Mission Control")
end)


-- ====================================================================
-- SECTION 3: Digital Color Meter (⌘ ⌥ ⌃ T)
-- ====================================================================
hs.hotkey.bind({"cmd","alt","ctrl"}, "t", function()
  -- Usa o eyedropper nativo do macOS via terminal
  hs.execute("osascript -e 'tell application \"Digital Color Meter\" to activate'")
  hs.alert("🎨 Digital Color Meter aberto\n(⌘+L para lock/copy)")
end)

-- ====================================================================
-- SECTION 4: Force Quit App (⌘ ⌥ ⌃ Q)
-- ====================================================================
hs.hotkey.bind({"cmd","alt","ctrl"}, "q", function()
  -- Abre o Force Quit Applications nativo do macOS
  hs.execute("osascript -e 'tell application \"System Events\" to key code 53 using {command down, option down}'")
  hs.alert("💀 Force Quit Applications")
end)

-- ====================================================================
-- SECTION 5: Activity Monitor (⌘ ⌥ ⌃ A)
-- ====================================================================
hs.hotkey.bind({"cmd","alt","ctrl"}, "a", function()
  -- Abre Activity Monitor via terminal
  hs.execute("open -a 'Activity Monitor'")
  hs.alert("📊 Activity Monitor")
end)

-- ====================================================================
-- SECTION 6: Passwords App (⌘ ⌥ ⌃ P)
-- ====================================================================
hs.hotkey.bind({"cmd","alt","ctrl"}, "p", function()
  -- Abre o app Passwords nativo do macOS
  hs.execute("open -a 'Passwords'")
  hs.alert("🔐 Passwords")
end)

-- ====================================================================
-- SECTION 7: Show Desktop (⌘ ⌥ ⌃ Space)
-- ====================================================================
hs.hotkey.bind({"cmd","alt","ctrl"}, "space", function()
  -- Mostra o Desktop (esconde todas as janelas)
  hs.execute("osascript -e 'tell application \"System Events\" to key code 103 using function down'")
  hs.alert("🖥️ Show Desktop")
end)
