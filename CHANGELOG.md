# 📋 Changelog

All notable changes and improvements to this project.

---

## [v1.1.0] - 2025-10-01

### 🐛 Fixed

#### Force Quit não funcionava
**Problema:** Atalho `⌘ ⌥ ⌃ Q` tentava simular `keystroke "q"` ao invés do atalho correto.

**Corrigido:**
```lua
-- ❌ Antes (ERRADO)
hs.execute([[osascript -e 'tell application "System Events" to keystroke "q" using {command down, option down}']])

-- ✅ Agora (CORRETO)
hs.execute([[osascript -e 'tell application "System Events" to key code 53 using {command down, option down}']])
```
- Agora usa `key code 53` (tecla Esc) que é o atalho nativo do Force Quit (`⌘ ⌥ Esc`)
- Testado e funcionando em macOS 12+

#### Show Desktop não funcionava
**Problema:** Dependia de configuração F11 do usuário, que varia.

**Corrigido:**
```lua
-- Método 1: Tenta AppleScript com ⌘ ⌥ ⌃ D
local success = hs.osascript.applescript([[
  tell application "System Events"
    keystroke "d" using {command down, option down, control down}
  end tell
]])

-- Método 2: Fallback para API nativa
if not success then
  hs.spaces.toggleShowDesktop()
end
```
- Implementado sistema de fallback com 2 métodos
- Maior compatibilidade entre diferentes configurações do macOS
- Funciona mesmo se usuário desabilitou atalho F11

#### TinyURL às vezes falhava
**Problema:** 
- Usava HTTP ao invés de HTTPS
- Sem timeout (podia travar)
- Não validava resposta

**Corrigido:**
```lua
-- ✅ Melhorias
local cmd = string.format('curl -s -L -m 10 "https://tinyurl.com/api-create.php?url=%s"', escapedUrl)
-- -s = silent
-- -L = follow redirects
-- -m 10 = timeout 10 segundos
-- https:// = conexão segura

-- Validação de resposta
if result and result ~= "" and not result:match("Error") then
  result = result:gsub("%s+", "")
  if result:match("^https?://") then  -- verifica se é URL válida
    return result
  end
end
```

---

### ✨ Improvements

#### 1. Documentação completa
- ✅ **TROUBLESHOOTING.md** - Guia detalhado de solução de problemas
- ✅ **ARCHITECTURE.md** - Documentação técnica e decisões de design
- ✅ **init.example.lua** - Arquivo de exemplo comentado para usuários
- ✅ **CHANGELOG.md** - Este arquivo!

#### 2. Código mais robusto
- Validação de URLs melhorada
- Tratamento de erros mais completo
- Timeouts em chamadas externas
- Sistema de fallback para comandos críticos

#### 3. Segurança
- HTTPS em todas as APIs externas
- URL encoding seguro contra injection
- Bit.ly token via setter ao invés de hardcoded

#### 4. Código mais limpo
- Comentários explicativos em português
- Estrutura consistente entre Spoons
- Seguindo convenções Hammerspoon oficiais
- Melhor organização de helpers

---

## [v1.0.0] - Initial Release

### Features

#### CustomShortcuts.spoon
- ⌘ I → Abrir arquivos/URLs/caminhos
- ⌘ J → Mission Control
- ⌘ ⌥ ⌃ T → Digital Color Meter
- ⌘ ⌥ ⌃ Q → Force Quit Applications (com bug)
- ⌘ ⌥ ⌃ A → Activity Monitor
- ⌘ ⌥ ⌃ P → Passwords
- ⌘ ⌥ ⌃ Space → Show Desktop (com bug)

#### URLShortener.spoon
- ⌘ ⇧ U → TinyURL
- ⌘ ⇧ ⌥ U → TinyURL + QR Code
- ⌘ ⇧ ⌃ U → Bit.ly (requer token)

#### Documentation
- README.md with installation instructions
- Spoons cheat sheet (HTML)
- Basic troubleshooting

---

## 🔮 Roadmap

### v1.2.0 (Planned)
- [ ] Configuration file (JSON/YAML) for custom shortcuts
- [ ] Conflict detection with system shortcuts
- [ ] More URL shorteners (is.gd, v.gd, Rebrandly)
- [ ] Automated tests with busted
- [ ] CI/CD with GitHub Actions

### v1.3.0 (Planned)
- [ ] Visual shortcut editor (Chooser interface)
- [ ] Usage analytics (local only)
- [ ] Localization support (EN, PT, ES)
- [ ] Cloud sync via iCloud Drive

### v2.0.0 (Future)
- [ ] Plugin system for custom shortcuts
- [ ] GUI configuration app
- [ ] Shortcut suggestions based on usage
- [ ] Integration with other Spoons

---

## 📊 Migration Guide

### v1.0.0 → v1.1.0

**No breaking changes!** Just update files and reload.

#### If using Spoons:
```bash
# Backup current version (optional)
mv ~/.hammerspoon/Spoons/CustomShortcuts.spoon ~/.hammerspoon/Spoons/CustomShortcuts.spoon.bak

# Install new version
cp -r Spoons/CustomShortcuts.spoon ~/.hammerspoon/Spoons/
cp -r Spoons/URLShortener.spoon ~/.hammerspoon/Spoons/

# Reload Hammerspoon
# (Hammerspoon menu → Console → Reload Config)
```

#### If using standalone script:
```bash
# Backup current init.lua
cp ~/.hammerspoon/init.lua ~/.hammerspoon/init.lua.bak

# Copy new version
cp init.lua ~/.hammerspoon/init.lua

# Reload Hammerspoon
```

**All settings and customizations will be preserved!**

---

## 🐛 Known Issues

### v1.1.0
- Show Desktop pode não funcionar no primeiro uso (permissões)
  - **Workaround:** Aceite prompt de permissão quando aparecer
  
- Bit.ly pode retornar erro se token inválido
  - **Workaround:** Verifique token em https://app.bitly.com/settings/api/

- QR code abre em nova janela do navegador
  - **Não é bug:** Comportamento esperado para visualizar QR code

### Reporting Bugs
Encontrou um bug? [Abra uma issue no GitHub](https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon/issues) com:
1. Versão do macOS
2. Versão do Hammerspoon (`hs.processInfo.version`)
3. Logs do Console (se houver erros)
4. Passos para reproduzir

---

## 🙏 Contributors

- **Rodrigo Miranda** - Initial work and v1.0
- **AI Assistant** - Code review, fixes, and documentation for v1.1

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.
