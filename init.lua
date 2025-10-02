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
-- 12. ⇧ ⌃ ⌘ F       → OCR de imagem no clipboard
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
-- SECTION 11 ─ OCR Reader  (⇧ ⌃ ⌘ R e ⇧ ⌃ ⌘ F)
--------------------------------------------------------------------
-- OCR simples: captura → clipboard → OCR
--------------------------------------------------------------------
local OCR_LANGS = "por+eng"

local function have(cmd)
  -- Verifica se um binário está disponível no PATH
  local _, success = hs.execute('command -v "'..cmd..'" >/dev/null 2>&1')
  return success == true
end

local function ocrFromImage(img, imagePath)
  if not img then
    hs.alert("⚠️ Imagem inválida")
    return
  end
  
  hs.alert("🔍 Processando OCR...")
  local tmp = imagePath or ((os.getenv("TMPDIR") or "/tmp") .. "/hsp_ocr_temp.png")
  
  if not imagePath then
    os.remove(tmp)
    img:saveToFile(tmp)
  end

  local tesseractPath = nil
  local possiblePaths = {
    "/opt/homebrew/bin/tesseract",
    "/usr/local/bin/tesseract",
    "/usr/bin/tesseract",
    "tesseract"
  }
  
  for _, path in ipairs(possiblePaths) do
    if path == "tesseract" then
      if have("tesseract") then
        tesseractPath = path
        break
      end
    else
      if hs.fs.attributes(path) then
        tesseractPath = path
        break
      end
    end
  end
  
  if tesseractPath then
    local out = {}
    local t = hs.task.new(tesseractPath, function(exitCode, stdout, stderr)
      if imagePath then
        os.remove(tmp)
      end
      local result = table.concat(out)
      result = result:gsub("^%s*(.-)%s*$","%1"):gsub("\n\n+","\n\n")
      if exitCode==0 and result~="" then
        hs.pasteboard.setContents(result)
        hs.alert("✅ OCR copiado!")
        print("=== OCR (tesseract) ===\n"..result.."\n=======================")
      else
        hs.alert("❌ OCR vazio/falhou (tesseract)")
        print("OCR Error - Exit code: " .. exitCode .. ", stderr: " .. (stderr or ""))
      end
    end, {tmp, "stdout", "-l", OCR_LANGS, "--psm", "6", "--oem", "3"})
    t:setStdoutCallback(function(_, data) table.insert(out, data or "") end)
    t:start()
  else
    hs.alert("❌ Tesseract não encontrado. Instale: brew install tesseract")
    local py = [[
import sys,Foundation,Quartz,Vision
from Cocoa import NSURL
p = sys.argv[1]
url = Foundation.NSURL.fileURLWithPath_(p)
img = Quartz.CIImage.imageWithContentsOfURL_(url)
req = Vision.VNRecognizeTextRequest.new()
req.setRecognitionLevel_(Vision.VNRequestTextRecognitionLevelAccurate)
req.setUsesLanguageCorrection_(True)
h = Vision.VNImageRequestHandler.alloc().initWithCIImage_options_(img,{})
ok = h.performRequests_error_([req], None)
res=[]
if ok[0]:
    for o in req.results() or []:
        c = o.topCandidates_(1)
        if c and len(c)>0: res.append(c[0].string())
print("\n".join(res))
]]
    local out = {}
    local t = hs.task.new("/usr/bin/python3", function(exitCode, stdout, stderr)
      if imagePath then
        os.remove(tmp)
      end
      local result = table.concat(out)
      result = result:gsub("^%s*(.-)%s*$","%1"):gsub("\n\n+","\n\n")
      if exitCode==0 and result~="" then
        hs.pasteboard.setContents(result)
        hs.alert("✅ OCR copiado (Vision)")
      else
        hs.alert("❌ OCR falhou (Vision). Instale tesseract: brew install tesseract")
      end
    end, {"-c", py, tmp})
    t:setStdoutCallback(function(_, data) table.insert(out, data or "") end)
    t:start()
  end
end

local function ocrClipboard()
  local img = hs.image.imageFromClipboard()
  if not img then
    hs.alert("⚠️ Sem imagem no clipboard")
    return
  end
  ocrFromImage(img)
end

-- OCR direto de um arquivo (imagem/PDF) no disco, sem apagar o arquivo original
local function ocrFilePath(filePath)
  if not filePath or filePath == "" then
    hs.alert("⚠️ Caminho inválido")
    return
  end
  local attr = hs.fs.attributes(filePath)
  if not attr or attr.mode ~= "file" then
    hs.alert("⚠️ Arquivo não encontrado")
    return
  end

  local ext = string.lower((filePath:match("%.([%w]+)$") or ""))
  local allowed = { png=true, jpg=true, jpeg=true, gif=true, bmp=true, tiff=true, tif=true, webp=true, pdf=true }
  if not allowed[ext] then
    hs.alert("⚠️ Extensão não suportada para OCR")
    return
  end

  hs.alert("🔍 Processando OCR do arquivo…")

  -- Detecta caminho do Tesseract automaticamente
  local tesseractPath = nil
  local possiblePaths = {
    "/opt/homebrew/bin/tesseract",
    "/usr/local/bin/tesseract",
    "/usr/bin/tesseract",
    "tesseract"
  }
  for _, path in ipairs(possiblePaths) do
    if path == "tesseract" then
      if have("tesseract") then tesseractPath = path; break end
    else
      if hs.fs.attributes(path) then tesseractPath = path; break end
    end
  end

  if tesseractPath then
    local out = {}
    local t = hs.task.new(tesseractPath, function(exitCode, stdout, stderr)
      local result = table.concat(out)
      result = result:gsub("^%s*(.-)%s*$","%1"):gsub("\n\n+","\n\n")
      if exitCode==0 and result~="" then
        hs.pasteboard.setContents(result)
        hs.alert("✅ OCR copiado!")
        print("=== OCR (tesseract:file) ===\n"..result.."\n=======================")
      else
        hs.alert("❌ OCR vazio/falhou (tesseract)")
        print("OCR Error - Exit code: " .. exitCode .. ", stderr: " .. (stderr or ""))
      end
    end, {filePath, "stdout", "-l", OCR_LANGS, "--psm", "6", "--oem", "3"})
    t:setStdoutCallback(function(_, data) table.insert(out, data or "") end)
    t:start()
  else
    if ext == "pdf" then
      hs.alert("❌ Tesseract é necessário para PDF. Instale com brew install tesseract")
      return
    end
    -- Fallback Vision apenas para imagens
    local py = [[
import sys,Foundation,Quartz,Vision
from Cocoa import NSURL
p = sys.argv[1]
url = Foundation.NSURL.fileURLWithPath_(p)
img = Quartz.CIImage.imageWithContentsOfURL_(url)
req = Vision.VNRecognizeTextRequest.new()
req.setRecognitionLevel_(Vision.VNRequestTextRecognitionLevelAccurate)
req.setUsesLanguageCorrection_(True)
h = Vision.VNImageRequestHandler.alloc().initWithCIImage_options_(img,{})
ok = h.performRequests_error_([req], None)
res=[]
if ok[0]:
    for o in req.results() or []:
        c = o.topCandidates_(1)
        if c and len(c)>0: res.append(c[0].string())
print("\n".join(res))
]]
    local out = {}
    local t = hs.task.new("/usr/bin/python3", function(exitCode, stdout, stderr)
      local result = table.concat(out)
      result = result:gsub("^%s*(.-)%s*$","%1"):gsub("\n\n+","\n\n")
      if exitCode==0 and result~="" then
        hs.pasteboard.setContents(result)
        hs.alert("✅ OCR copiado (Vision)")
      else
        hs.alert("❌ OCR falhou (Vision). Instale tesseract: brew install tesseract")
      end
    end, {"-c", py, filePath})
    t:setStdoutCallback(function(_, data) table.insert(out, data or "") end)
    t:start()
  end
end

-- Obtém o primeiro arquivo selecionado no Finder (como caminho POSIX)
local function getFinderSelectionPath()
  local script = [[
    tell application "Finder"
      set sel to selection
      if sel is {} then return ""
      set theItem to item 1 of sel
      return POSIX path of (theItem as alias)
    end tell
  ]]
  local ok, result = hs.osascript.applescript(script)
  if ok and result and result ~= "" then
    return result:match("^%s*(.-)%s*$")
  end
  return nil
end

-- OCR do arquivo atualmente selecionado no Finder
local function ocrSelectedFile()
  local path = getFinderSelectionPath()
  if not path or path == "" then
    hs.alert("⚠️ Selecione um arquivo de imagem/PDF no Finder")
    return
  end
  ocrFilePath(path)
end

local function captureToFileThenOCR()
  local tmp = (os.getenv("TMPDIR") or "/tmp") .. "/hsp_screen_capture.png"
  os.remove(tmp)
  
  local t = hs.task.new("/usr/sbin/screencapture", function(exitCode)
    if exitCode==0 then
      hs.timer.doAfter(0.1, function()
        local img = hs.image.imageFromPath(tmp)
        if img then
          ocrFromImage(img, tmp)
        else
          hs.alert("❌ Erro ao carregar imagem capturada")
          os.remove(tmp)
        end
      end)
    elseif exitCode==1 then
      hs.alert("❌ Captura cancelada")
      os.remove(tmp)
    else
      hs.alert("⚠️ Falha na captura. Dê permissão em Privacidade > Screen Recording p/ Hammerspoon")
      os.remove(tmp)
      hs.timer.doAfter(0.8, function()
        hs.execute('open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"')
      end)
    end
  end, {"-i", tmp})
  t:start()
end

--------------------------------------------------------------------
-- Atalhos
--------------------------------------------------------------------
-- ⇧ ⌃ ⌘ R → Selecionar área → salvar em arquivo → OCR
hs.hotkey.bind({"shift","ctrl","cmd"}, "r", captureToFileThenOCR)

-- ⇧ ⌃ ⌘ F → OCR do que já estiver no clipboard (ex.: você copiou uma imagem do Preview/Finder)
hs.hotkey.bind({"shift","ctrl","cmd"}, "f", ocrClipboard)

-- ⇧ ⌃ ⌘ O → OCR do arquivo selecionado no Finder (imagens/PDF)
hs.hotkey.bind({"shift","ctrl","cmd"}, "o", ocrSelectedFile)

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
hs.alert("🔨 Atalhos Hammerspoon carregados! (14 ativos)")
--------------------------------------------------------------------
