--- === YouTubeTranscriber ===
---
--- Transcreve vídeos do YouTube para texto usando yt-dlp
--- e copia o resultado para a área de transferência.
--- Atalho: ⇧ ⌃ ⌘ Y

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "YouTubeTranscriber"
obj.version = "1.0.0"
obj.author = "Rodrigo Miranda"
obj.homepage = "https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- State
obj.hotkeys = {}
obj.languages = {"pt-BR", "pt", "en"}
obj.maxPreviewChars = 180

-- Helpers
local function trim(str)
  if not str then return "" end
  return (str:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function isYouTubeURL(url)
  if not url or url == "" then return false end
  local lower = url:lower()
  if not lower:match("^https?://") then return false end
  return lower:match("youtu%.be/") or lower:match("youtube%.com/")
end

local function resolveYtDlpPath()
  local candidates = {
    "yt-dlp",
    "/opt/homebrew/bin/yt-dlp",
    "/usr/local/bin/yt-dlp",
    "/usr/bin/yt-dlp",
  }
  for _, bin in ipairs(candidates) do
    local ok, out = hs.execute(string.format("command -v %q 2>/dev/null || true", bin), true)
    out = trim(out)
    if out and out ~= "" then
      return out
    end
  end
  return nil
end

local function ensureTempDir()
  local base = hs.fs.temporaryDirectory() or "/tmp"
  base = base:gsub("/+$", "")
  local path = string.format("%s/yt_transcriber_%d_%d", base, os.time(), math.random(1000, 9999))
  hs.execute(string.format("mkdir -p %q", path), true)
  return path
end

local function listFiles(dir, pattern)
  local result = {}
  for name in hs.fs.dir(dir) do
    if name ~= "." and name ~= ".." then
      if not pattern or name:match(pattern) then
        table.insert(result, dir .. "/" .. name)
      end
    end
  end
  return result
end

local function readFile(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local c = f:read("*a")
  f:close()
  return c
end

local function vttToPlainText(vtt)
  if not vtt or vtt == "" then return "" end
  local lines = {}
  local seen = {}
  for raw in vtt:gmatch("[^\r\n]+") do
    local line = trim(raw)
    if line ~= "" then
      if line == "WEBVTT" or line:match("^NOTE") or line:match("^Kind:") or line:match("^Language:") or line:match("^Style:") then
        -- skip metadata
      elseif line:match("^%d+$") then
        -- skip srt indices
      elseif line:match("^%d%d:%d%d:%d%d%.%d%d%d%s+%-%-%>%s+%d%d:%d%d:%d%d%.%d%d%d") then
        -- skip timecodes
      else
        local normalized = line:gsub("%s+", " ")
        if not seen[normalized] then
          seen[normalized] = true
          table.insert(lines, normalized)
        end
      end
    end
  end
  local text = table.concat(lines, " ")
  text = text:gsub("%s+", " ")
  return trim(text)
end

local function buildLangsCsv(langs)
  local clean = {}
  for _, l in ipairs(langs or {}) do
    if type(l) == "string" and l ~= "" then table.insert(clean, l) end
  end
  if #clean == 0 then clean = {"en"} end
  return table.concat(clean, ",")
end

local function tryDownloadSubs(ytDlp, url, langsCsv, tempDir, useAuto)
  local flag = useAuto and "--write-auto-sub" or "--write-sub"
  local cmd = string.format(
    "%s --skip-download %s --sub-langs %q --sub-format vtt --output %q %q 2>&1",
    ytDlp, flag, langsCsv, tempDir .. "/%(id)s", url
  )
  local ok, out = hs.execute(cmd, true)
  return ok, out
end

local function findBestVtt(tempDir, preferredLangs)
  local files = listFiles(tempDir, "%.vtt$")
  if #files == 0 then return nil end
  local function langOf(p)
    return p:match("%.([%a%-]+)%.vtt$")
  end
  for _, pref in ipairs(preferredLangs or {}) do
    for _, f in ipairs(files) do
      local l = langOf(f)
      if l and l:lower() == pref:lower() then return f end
    end
  end
  return files[1]
end

function obj:setLanguages(langs)
  if type(langs) == "table" and #langs > 0 then
    self.languages = langs
  end
  return self
end

function obj:transcribeURL(url)
  if not isYouTubeURL(url) then
    hs.alert("⚠️ Selecione um link válido do YouTube")
    return
  end

  local ytDlp = resolveYtDlpPath()
  if not ytDlp then
    hs.alert("❌ yt-dlp não encontrado. Instale com: brew install yt-dlp")
    return
  end

  hs.alert("🔄 Buscando legendas (yt-dlp)…")
  local tempDir = ensureTempDir()
  local langsCsv = buildLangsCsv(self.languages)

  -- 1) Tenta legendas automáticas
  tryDownloadSubs(ytDlp, url, langsCsv, tempDir, true)
  local vttPath = findBestVtt(tempDir, self.languages)

  -- 2) Se não achou, tenta legendas manuais
  if not vttPath then
    tryDownloadSubs(ytDlp, url, langsCsv, tempDir, false)
    vttPath = findBestVtt(tempDir, self.languages)
  end

  if not vttPath then
    hs.alert("❌ Não encontrei legendas (auto/manuais)")
    hs.execute(string.format("rm -rf %q", tempDir), true)
    return
  end

  local vtt = readFile(vttPath)
  local text = vttToPlainText(vtt)
  if not text or text == "" then
    hs.alert("❌ Falha ao extrair texto das legendas")
    hs.execute(string.format("rm -rf %q", tempDir), true)
    return
  end

  hs.pasteboard.setContents(text)
  local preview = text
  if #preview > self.maxPreviewChars then
    preview = preview:sub(1, self.maxPreviewChars) .. "…"
  end
  hs.alert("✅ Transcrição copiada!\n" .. preview, 4)

  -- Limpa arquivos temporários
  hs.execute(string.format("rm -rf %q", tempDir), true)
end

function obj:start()
  local function onHotkey()
    -- Copia seleção atual (URL do YouTube)
    hs.eventtap.keyStroke({"cmd"}, "c")
    hs.timer.doAfter(0.25, function()
      local url = hs.pasteboard.getContents()
      url = trim(url)
      self:transcribeURL(url)
    end)
  end

  self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"shift","ctrl","cmd"}, "y", onHotkey)
  hs.alert("🎬 YouTubeTranscriber carregado (⇧ ⌃ ⌘ Y)")
  return self
end

function obj:stop()
  for _, hk in ipairs(self.hotkeys) do hk:delete() end
  self.hotkeys = {}
  hs.alert("🎬 YouTubeTranscriber descarregado")
  return self
end

return obj
