--- === YouTubeTranscriber ===
---
--- Transcribe YouTube videos to clipboard using yt-dlp
---
--- Download: https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon
--- 
--- Funcionalidades:
---   • ⇧ ⌃ ⌘ Y → Transcribe YouTube video URL from clipboard
---
--- Requisitos:
---   • yt-dlp instalado (brew install yt-dlp)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "YouTubeTranscriber"
obj.version = "1.0"
obj.author = "Rodrigo Miranda"
obj.homepage = "https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Variables
obj.hotkeys = {}

--- Helper: Validate YouTube URL
local function isYouTubeURL(url)
    if not url or url == "" then return false end
    -- Matches youtube.com, youtu.be, m.youtube.com, etc.
    return url:match("youtube%.com/watch") or 
           url:match("youtu%.be/") or 
           url:match("youtube%.com/shorts/") or
           url:match("m%.youtube%.com/watch")
end

--- Helper: Extract video ID from YouTube URL
local function extractVideoID(url)
    -- youtube.com/watch?v=VIDEO_ID
    local id = url:match("youtube%.com/watch%?v=([^&]+)")
    if id then return id end
    
    -- youtu.be/VIDEO_ID
    id = url:match("youtu%.be/([^?]+)")
    if id then return id end
    
    -- youtube.com/shorts/VIDEO_ID
    id = url:match("youtube%.com/shorts/([^?]+)")
    if id then return id end
    
    return nil
end

--- Helper: Check if yt-dlp is installed
local function checkYtDlp()
    local handle = io.popen("which yt-dlp 2>/dev/null")
    if not handle then return false end
    
    local result = handle:read("*a")
    handle:close()
    
    return result and result ~= ""
end

--- Helper: Transcribe YouTube video
local function transcribeVideo(url, callback)
    -- Check if yt-dlp is installed
    if not checkYtDlp() then
        callback(nil, "yt-dlp não está instalado.\n\nInstale com: brew install yt-dlp")
        return
    end
    
    -- Create temporary file for subtitle
    local tmpFile = os.tmpname() .. ".txt"
    
    -- Build yt-dlp command to extract subtitles
    -- Tries to get auto-generated subtitles in Portuguese, then English, then any available
    local cmd = string.format([[
        yt-dlp --skip-download \
               --write-auto-sub \
               --sub-lang "pt,pt-BR,en,en-US" \
               --convert-subs txt \
               --output "%s" \
               --no-warnings \
               "%s" 2>&1
    ]], tmpFile:gsub("%.txt$", ""), url)
    
    hs.task.new("/bin/bash", function(exitCode, stdout, stderr)
        -- Find the generated subtitle file
        local subtitleFile = nil
        local possibleExtensions = {".pt.txt", ".pt-BR.txt", ".en.txt", ".en-US.txt", ".txt"}
        
        for _, ext in ipairs(possibleExtensions) do
            local testFile = tmpFile:gsub("%.txt$", "") .. ext
            local f = io.open(testFile, "r")
            if f then
                f:close()
                subtitleFile = testFile
                break
            end
        end
        
        if not subtitleFile then
            -- Try to get manual subtitles if auto-generated failed
            local cmd2 = string.format([[
                yt-dlp --skip-download \
                       --write-sub \
                       --sub-lang "pt,pt-BR,en,en-US" \
                       --convert-subs txt \
                       --output "%s" \
                       --no-warnings \
                       "%s" 2>&1
            ]], tmpFile:gsub("%.txt$", ""), url)
            
            hs.task.new("/bin/bash", function(exitCode2, stdout2, stderr2)
                for _, ext in ipairs(possibleExtensions) do
                    local testFile = tmpFile:gsub("%.txt$", "") .. ext
                    local f = io.open(testFile, "r")
                    if f then
                        f:close()
                        subtitleFile = testFile
                        break
                    end
                end
                
                if subtitleFile then
                    local file = io.open(subtitleFile, "r")
                    if file then
                        local content = file:read("*a")
                        file:close()
                        
                        -- Clean up temporary files
                        os.remove(subtitleFile)
                        os.remove(tmpFile)
                        
                        if content and content ~= "" then
                            callback(content, nil)
                        else
                            callback(nil, "Arquivo de legenda vazio")
                        end
                    else
                        callback(nil, "Não foi possível ler o arquivo de legenda")
                    end
                else
                    callback(nil, "Este vídeo não possui legendas disponíveis.\n\nTente outro vídeo.")
                end
            end, {"-c", cmd2}):start()
            return
        end
        
        -- Read subtitle content
        local file = io.open(subtitleFile, "r")
        if file then
            local content = file:read("*a")
            file:close()
            
            -- Clean up temporary files
            os.remove(subtitleFile)
            os.remove(tmpFile)
            
            if content and content ~= "" then
                callback(content, nil)
            else
                callback(nil, "Arquivo de legenda vazio")
            end
        else
            callback(nil, "Não foi possível ler o arquivo de legenda")
        end
    end, {"-c", cmd}):start()
end

--- YouTubeTranscriber:start()
--- Method
--- Start the YouTube transcriber with hotkey
---
--- Parameters:
---  * None
---
--- Returns:
---  * The YouTubeTranscriber object
function obj:start()
    -- ⇧ ⌃ ⌘ Y → Transcribe YouTube video from clipboard
    self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"shift", "ctrl", "cmd"}, "y", function()
        local url = hs.pasteboard.getContents()
        
        if not isYouTubeURL(url) then
            hs.alert("⚠️ Copie um link do YouTube primeiro!\n\nFormatos aceitos:\n• youtube.com/watch?v=...\n• youtu.be/...\n• youtube.com/shorts/...", 5)
            return
        end
        
        local videoID = extractVideoID(url)
        if not videoID then
            hs.alert("❌ Não foi possível extrair o ID do vídeo")
            return
        end
        
        hs.alert("📹 Baixando transcrição...\n\nIsso pode levar alguns segundos.", 3)
        
        transcribeVideo(url, function(transcript, error)
            if error then
                hs.alert("❌ Erro: " .. error, 5)
            elseif transcript then
                -- Copy transcript to clipboard
                hs.pasteboard.setContents(transcript)
                
                -- Count words for feedback
                local wordCount = 0
                for _ in transcript:gmatch("%S+") do
                    wordCount = wordCount + 1
                end
                
                hs.alert(string.format("✅ Transcrição copiada!\n\n📝 %d palavras\n🎬 ID: %s", 
                    wordCount, videoID:sub(1, 11)), 4)
            else
                hs.alert("❌ Erro desconhecido ao processar transcrição", 3)
            end
        end)
    end)
    
    hs.alert("📹 YouTubeTranscriber carregado!\n⇧ ⌃ ⌘ Y para transcrever", 3)
    return self
end

--- YouTubeTranscriber:stop()
--- Method
--- Stop the YouTube transcriber
---
--- Parameters:
---  * None
---
--- Returns:
---  * The YouTubeTranscriber object
function obj:stop()
    for _, hotkey in ipairs(self.hotkeys) do
        hotkey:delete()
    end
    self.hotkeys = {}
    hs.alert("📹 YouTubeTranscriber descarregado")
    return self
end

return obj
