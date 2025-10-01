--- === URLShortener ===
---
--- Shorten URLs using multiple services (TinyURL, Bit.ly, etc.)
---
--- Download: https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon
--- 
--- Funcionalidades:
---   • ⌘ ⇧ U → Shorten selected URL (TinyURL)
---   • ⌘ ⇧ ⌥ U → Shorten URL + show QR code
---   • ⌘ ⇧ ⌃ U → Shorten with Bit.ly (requires API token)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "URLShortener"
obj.version = "1.0"
obj.author = "Rodrigo Miranda"
obj.homepage = "https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Variables
obj.hotkeys = {}
obj.bitlyToken = nil -- Set this to your Bit.ly API token

--- URLShortener:setBitlyToken(token)
--- Method
--- Set Bit.ly API token for premium shortening
---
--- Parameters:
---  * token - Your Bit.ly API access token
---
--- Returns:
---  * The URLShortener object
function obj:setBitlyToken(token)
    self.bitlyToken = token
    return self
end

--- Helper: Shorten URL with TinyURL (free, no API key required)
local function shortenWithTinyURL(url)
    local escapedUrl = url:gsub("([^%w%.%-%_])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    
    local cmd = string.format('curl -s "http://tinyurl.com/api-create.php?url=%s"', escapedUrl)
    local handle = io.popen(cmd)
    if not handle then return nil end
    
    local result = handle:read("*a")
    handle:close()
    
    if result and result ~= "" then
        return result:gsub("%s+", "") -- trim whitespace
    end
    return nil
end

--- Helper: Shorten URL with Bit.ly (requires API token)
local function shortenWithBitly(url, apiToken)
    if not apiToken or apiToken == "" then
        return nil, "Bit.ly API token not configured"
    end
    
    local cmd = string.format([[
        curl -s -X POST "https://api-ssl.bitly.com/v4/shorten" \
        -H "Authorization: Bearer %s" \
        -H "Content-Type: application/json" \
        -d '{"long_url": "%s"}'
    ]], apiToken, url)
    
    local handle = io.popen(cmd)
    if not handle then return nil end
    
    local result = handle:read("*a")
    handle:close()
    
    -- Parse JSON response
    local shortUrl = result:match('"link":"([^"]+)"')
    if shortUrl then
        return shortUrl:gsub("\\/", "/") -- unescape slashes
    end
    
    -- Check for error
    local error = result:match('"message":"([^"]+)"')
    return nil, error or "Unknown Bit.ly error"
end

--- Helper: Generate QR code for URL
local function generateQR(url)
    local escapedUrl = url:gsub("([^%w%.%-%_])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    local qrUrl = string.format("https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=%s", escapedUrl)
    hs.execute(string.format('open "%s"', qrUrl))
end

--- Helper: Validate URL
local function isValidURL(url)
    if not url or url == "" then return false end
    return url:match("^https?://") ~= nil
end

--- URLShortener:start()
--- Method
--- Start the URL shortener with hotkeys
---
--- Parameters:
---  * None
---
--- Returns:
---  * The URLShortener object
function obj:start()
    -- ⌘ ⇧ U → Shorten with TinyURL
    self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd", "shift"}, "u", function()
        -- Get selected text
        hs.eventtap.keyStroke({"cmd"}, "c")
        hs.timer.doAfter(0.3, function()
            local url = hs.pasteboard.getContents()
            
            if not isValidURL(url) then
                hs.alert("⚠️ Please select a valid URL (must start with http:// or https://)")
                return
            end
            
            hs.alert("🔄 Shortening URL...")
            local shortUrl = shortenWithTinyURL(url)
            
            if shortUrl and shortUrl ~= "" then
                hs.pasteboard.setContents(shortUrl)
                hs.alert("🔗 URL shortened and copied!\n" .. shortUrl, 3)
            else
                hs.alert("❌ Failed to shorten URL with TinyURL")
            end
        end)
    end)

    -- ⌘ ⇧ ⌥ U → Shorten with TinyURL + show QR code
    self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd", "shift", "alt"}, "u", function()
        -- Get selected text
        hs.eventtap.keyStroke({"cmd"}, "c")
        hs.timer.doAfter(0.3, function()
            local url = hs.pasteboard.getContents()
            
            if not isValidURL(url) then
                hs.alert("⚠️ Please select a valid URL (must start with http:// or https://)")
                return
            end
            
            hs.alert("🔄 Shortening URL...")
            local shortUrl = shortenWithTinyURL(url)
            
            if shortUrl and shortUrl ~= "" then
                hs.pasteboard.setContents(shortUrl)
                hs.alert("🔗 URL shortened and copied!\n" .. shortUrl, 3)
                
                -- Generate QR code
                hs.timer.doAfter(1, function()
                    generateQR(shortUrl)
                    hs.alert("📱 QR code opened in browser", 2)
                end)
            else
                hs.alert("❌ Failed to shorten URL with TinyURL")
            end
        end)
    end)

    -- ⌘ ⇧ ⌃ U → Shorten with Bit.ly (premium)
    self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd", "shift", "ctrl"}, "u", function()
        if not self.bitlyToken then
            hs.alert("⚠️ Bit.ly API token not configured!\nUse: spoon.URLShortener:setBitlyToken('your_token')")
            return
        end
        
        -- Get selected text
        hs.eventtap.keyStroke({"cmd"}, "c")
        hs.timer.doAfter(0.3, function()
            local url = hs.pasteboard.getContents()
            
            if not isValidURL(url) then
                hs.alert("⚠️ Please select a valid URL (must start with http:// or https://)")
                return
            end
            
            hs.alert("🔄 Shortening URL with Bit.ly...")
            local shortUrl, error = shortenWithBitly(url, self.bitlyToken)
            
            if shortUrl then
                hs.pasteboard.setContents(shortUrl)
                hs.alert("🔗 Bit.ly URL shortened and copied!\n" .. shortUrl, 3)
            else
                hs.alert("❌ Bit.ly error: " .. (error or "Unknown error"))
            end
        end)
    end)

    hs.alert("🔗 URLShortener loaded! 3 shortcuts active.")
    return self
end

--- URLShortener:stop()
--- Method
--- Stop all URL shortener hotkeys
---
--- Parameters:
---  * None
---
--- Returns:
---  * The URLShortener object
function obj:stop()
    for _, hotkey in ipairs(self.hotkeys) do
        hotkey:delete()
    end
    self.hotkeys = {}
    hs.alert("🔗 URLShortener unloaded")
    return self
end

return obj