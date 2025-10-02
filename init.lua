--------------------------------------------------------------------
-- 🔨  Hammerspoon – Atalhos Personalizados (12 atalhos)
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
-- 12. ⇧ ⌃ ⌘ F       → OCR de arquivo (imagem selecionada no Finder)
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
-- SECTION 11 ─ OCR Reader  (⇧ ⌃ ⌘ R)
--------------------------------------------------------------------
-- Helper: Tenta salvar imagem da área de transferência
local function saveClipboardImage()
  local tempDir = os.getenv("TMPDIR") or "/tmp"
  local tempFile = tempDir .. "/hammerspoon_clipboard_ocr.png"
  
  os.remove(tempFile)
  
  local script = string.format([[
    try
      set theImage to the clipboard as «class PNGf»
      set theFile to open for access POSIX file "%s" with write permission
      write theImage to theFile
      close access theFile
      return "success"
    on error
      try
        close access theFile
      end try
      return "no_image"
    end try
  ]], tempFile)
  
  local ok, result = hs.osascript.applescript(script)
  if ok and result == "success" then
    return tempFile
  end
  return nil
end

hs.hotkey.bind({"shift","ctrl","cmd"}, "r", function()
  local tempDir = os.getenv("TMPDIR") or "/tmp"
  local tempImage = tempDir .. "/hammerspoon_ocr.png"
  local imagePath = nil
  
  -- Primeiro tenta imagem da área de transferência
  local clipboardImage = saveClipboardImage()
  if clipboardImage then
    hs.alert("📋 Processando imagem da área de transferência...")
    imagePath = clipboardImage
  else
    -- Se não há imagem na área de transferência, captura da tela
    hs.alert("🔍 Selecione área da tela com texto...")
    
    os.remove(tempImage)
    
    -- Tenta captura interativa
    local captureCmd = string.format('screencapture -i -s "%s"', tempImage)
    local success = os.execute(captureCmd)
    
    -- Verifica se arquivo foi criado e tem conteúdo
    local attr = hs.fs.attributes(tempImage)
    if success == 0 and attr and attr.size > 0 then
      imagePath = tempImage
      hs.alert("📸 Captura realizada! Processando...")
    else
      -- Verifica se é problema de permissões
      hs.alert("❌ Falha na captura\n\n🔧 Solução:\n1. Vá em Configurações\n2. Privacidade → Gravação de Tela\n3. Adicione Hammerspoon\n4. Reinicie Hammerspoon", 6)
      
      -- Abre automaticamente as configurações
      hs.timer.doAfter(1, function()
        hs.execute('open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"')
      end)
      return
    end
  end
  
  if imagePath then
    hs.alert("📝 Processando texto...")
    
    -- Usa OCR nativo do macOS via Python/Vision
    hs.timer.doAfter(0.5, function()
      -- Primeiro tenta Tesseract (mais confiável)
      local tesseractCmd = string.format('tesseract "%s" stdout -l por+eng 2>/dev/null', imagePath)
      local handle = io.popen(tesseractCmd)
      local result = ""
      
      if handle then
        result = handle:read("*a")
        handle:close()
      end
      
      -- Se Tesseract não funcionou, tenta Vision API
      if not result or result:gsub("%s", "") == "" then
        local pythonOCR = string.format([[
python3 -c "
import sys, os
try:
    # Usa Vision API (macOS 10.15+)
    import Vision, Quartz, Foundation
    
    url = Foundation.NSURL.fileURLWithPath_('%s')
    image = Quartz.CIImage.imageWithContentsOfURL_(url)
    
    if image:
        request = Vision.VNRecognizeTextRequest.alloc().init()
        request.setRecognitionLevel_(Vision.VNRequestTextRecognitionLevelAccurate)
        request.setUsesLanguageCorrection_(True)
        
        handler = Vision.VNImageRequestHandler.alloc().initWithCIImage_options_(image, {})
        success = handler.performRequests_error_([request], None)
        
        if success[0]:
            observations = request.results()
            if observations:
                # Organiza texto por posição vertical
                text_blocks = []
                for obs in observations:
                    text = obs.topCandidates_(1)[0].string()
                    bbox = obs.boundingBox()
                    y_pos = 1.0 - bbox.origin.y - bbox.size.height
                    text_blocks.append((y_pos, text))
                
                # Ordena e agrupa
                text_blocks.sort(reverse=True)
                paragraphs = []
                current_para = []
                last_y = None
                
                for y_pos, text in text_blocks:
                    if last_y is None or abs(last_y - y_pos) < 0.05:
                        current_para.append(text)
                    else:
                        if current_para:
                            paragraphs.append(' '.join(current_para))
                        current_para = [text]
                    last_y = y_pos
                
                if current_para:
                    paragraphs.append(' '.join(current_para))
                
                result = '\\n\\n'.join(paragraphs).strip()
                print(result)
            else:
                print('Nenhum texto encontrado')
        else:
            print('Erro no processamento Vision')
    else:
        print('Erro ao carregar imagem')
        
except ImportError:
    print('Vision API não disponível')
except Exception as e:
    print(f'Erro Vision: {e}')
"]], imagePath)
        
        local handle2 = io.popen(pythonOCR)
        if handle2 then
          result = handle2:read("*a")
          handle2:close()
        end
      end
      
      -- Limpa arquivos temporários
      os.remove(tempImage)
      if clipboardImage then
        os.remove(clipboardImage)
      end
      
      if result and result ~= "" and not result:match("^Erro:") and not result:match("falhou") and not result:match("não disponível") then
        -- Limpa e formata o texto
        result = result:gsub("^%s*(.-)%s*$", "%1") -- trim
        result = result:gsub("\n\n+", "\n\n") -- remove quebras excessivas
        
        -- Copia para clipboard
        hs.pasteboard.setContents(result)
        
        -- Mostra preview
        local preview = result
        if #preview > 120 then
          preview = preview:sub(1, 120) .. "..."
        end
        
        hs.alert("✅ Texto extraído e copiado!\n\n" .. preview, 4)
        
        -- Log completo no console
        print("=== OCR RESULTADO COMPLETO ===")
        print(result)
        print("============================")
      else
        hs.alert("❌ OCR falhou ou nenhum texto encontrado\n\nVerifique:\n• Qualidade da imagem\n• Contraste do texto\n• Idioma correto", 4)
        print("=== DEBUG OCR ===")
        print("Resultado bruto:", result)
        print("==================")
      end
    end)
  else
    hs.alert("❌ Captura cancelada", 2)
  end
end)

--------------------------------------------------------------------
-- SECTION 12 ─ OCR de arquivo selecionado  (⇧ ⌃ ⌘ F)
--------------------------------------------------------------------
hs.hotkey.bind({"shift","ctrl","cmd"}, "f", function()
  -- Pega arquivo selecionado no Finder
  local script = [[
    tell application "Finder"
      set sel to selection
      if sel is {} then return ""
      set theItem to item 1 of sel
      set itemPath to POSIX path of (theItem as alias)
      set itemName to name of theItem
      
      -- Verifica se é uma imagem
      if itemName ends with ".png" or itemName ends with ".jpg" or itemName ends with ".jpeg" or itemName ends with ".gif" or itemName ends with ".bmp" or itemName ends with ".tiff" or itemName ends with ".webp" then
        return itemPath
      else
        return "not_image"
      end if
    end tell
  ]]
  
  local ok, result = hs.osascript.applescript(script)
  if ok and result ~= "" and result ~= "not_image" then
    local imagePath = result:gsub("^%s*(.-)%s*$", "%1")  -- trim
    hs.alert("📁 Processando arquivo selecionado...")
    
    hs.timer.doAfter(0.3, function()
      -- Usa Tesseract
      local tesseractCmd = string.format('tesseract "%s" stdout -l por+eng 2>/dev/null', imagePath)
      local handle = io.popen(tesseractCmd)
      local result = ""
      
      if handle then
        result = handle:read("*a")
        handle:close()
      end
      
      if result and result:gsub("%s", "") ~= "" then
        -- Limpa e formata o texto
        result = result:gsub("^%s*(.-)%s*$", "%1") -- trim
        result = result:gsub("\n\n+", "\n\n") -- remove quebras excessivas
        
        -- Copia para clipboard
        hs.pasteboard.setContents(result)
        
        -- Mostra preview
        local preview = result
        if #preview > 120 then
          preview = preview:sub(1, 120) .. "..."
        end
        
        hs.alert("✅ Texto do arquivo extraído!\n\n" .. preview, 4)
        
        print("=== OCR ARQUIVO RESULTADO ===")
        print(result)
        print("===========================")
      else
        hs.alert("❌ Nenhum texto encontrado no arquivo", 3)
      end
    end)
  elseif result == "not_image" then
    hs.alert("⚠️ Selecione um arquivo de imagem\n(PNG, JPG, GIF, etc.)", 3)
  else
    hs.alert("⚠️ Selecione uma imagem no Finder primeiro", 3)
  end
end)

--------------------------------------------------------------------
hs.alert("🔨 Atalhos Hammerspoon carregados! (12 ativos)")
--------------------------------------------------------------------
