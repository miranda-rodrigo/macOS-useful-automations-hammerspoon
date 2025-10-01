# 🚀 Quick Start Guide - Hammerspoon Shortcuts

> **Comece a usar em 5 minutos!**

---

## 📦 1. Instalar Hammerspoon

```bash
# Via Homebrew (recomendado)
brew install --cask hammerspoon

# OU baixe manualmente:
# https://github.com/Hammerspoon/hammerspoon/releases/latest
```

---

## ⚙️ 2. Instalar os Spoons

### Opção A: Download Manual

```bash
# 1. Clone este repositório
git clone https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon.git

# 2. Copie os Spoons
cd macOS-useful-automations-hammerspoon
cp -r Spoons/CustomShortcuts.spoon ~/.hammerspoon/Spoons/
cp -r Spoons/URLShortener.spoon ~/.hammerspoon/Spoons/

# 3. Copie o exemplo de configuração (se não tiver init.lua)
cp init.example.lua ~/.hammerspoon/init.lua
```

### Opção B: Script de Instalação Rápida

```bash
# Download e instalação em um comando
curl -fsSL https://raw.githubusercontent.com/miranda-rodrigo/macOS-useful-automations-hammerspoon/main/install.sh | bash
```

---

## 📝 3. Configurar init.lua

Edite `~/.hammerspoon/init.lua`:

```lua
-- Carrega CustomShortcuts (7 atalhos principais)
hs.loadSpoon("CustomShortcuts")
spoon.CustomShortcuts:start()

-- Carrega URLShortener (3 atalhos de URL - opcional)
hs.loadSpoon("URLShortener")
spoon.URLShortener:start()

-- (Opcional) Token do Bit.ly para URL shortener premium
-- spoon.URLShortener:setBitlyToken("seu_token_aqui")

hs.alert("🔨 Hammerspoon carregado!")
```

---

## 🔄 4. Recarregar Configuração

1. Abra Hammerspoon (clique no ícone da colher 🔨 na barra de menu)
2. Clique em "Console"
3. Clique no botão "Reload Config"
4. Você deve ver: "🔨 Hammerspoon carregado!"

**OU via atalho (se configurado):**
```
⌘ ⌥ ⌃ R  →  Reload config
```

---

## 🔐 5. Configurar Permissões

### Obrigatório: Accessibility

1. System Settings (⚙️)
2. Privacy & Security
3. Accessibility
4. Clique no 🔒 para desbloquear
5. Ative ☑️ **Hammerspoon**

### Opcional: Screen Recording (para Color Picker)

1. System Settings (⚙️)
2. Privacy & Security
3. Screen & System Audio Recording
4. Ative ☑️ **Hammerspoon**

---

## ✅ 6. Testar

### Teste 1: Activity Monitor
```
Pressione: ⌘ ⌥ ⌃ A
Resultado: Abre Activity Monitor + alerta "📊 Activity Monitor"
```

### Teste 2: Abrir URL
```
1. Selecione: https://github.com
2. Pressione: ⌘ I
3. Resultado: Abre no navegador + alerta "🌐 Abrindo URL"
```

### Teste 3: URL Shortener
```
1. Selecione: https://github.com/hammerspoon/hammerspoon
2. Pressione: ⌘ ⇧ U
3. Resultado: Copia URL curta + alerta "🔗 Copiado!"
```

### Teste 4: Mission Control
```
Pressione: ⌘ J
Resultado: Mostra todos os desktops e janelas
```

---

## 🎯 Atalhos Disponíveis

### Core Shortcuts (CustomShortcuts.spoon)

| Atalho | Função |
|--------|--------|
| `⌘ I` | Abrir arquivos/URLs/caminhos |
| `⌘ J` | Mission Control |
| `⌘ ⌥ ⌃ T` | Digital Color Meter |
| `⌘ ⌥ ⌃ Q` | Force Quit Applications |
| `⌘ ⌥ ⌃ A` | Activity Monitor |
| `⌘ ⌥ ⌃ P` | Passwords |
| `⌘ ⌥ ⌃ Space` | Show Desktop |

### URL Shortener (URLShortener.spoon)

| Atalho | Função |
|--------|--------|
| `⌘ ⇧ U` | TinyURL |
| `⌘ ⇧ ⌥ U` | TinyURL + QR Code |
| `⌘ ⇧ ⌃ U` | Bit.ly (requer token) |

---

## 🆘 Problemas?

### "Atalhos não funcionam"
✅ Verifique permissões de Accessibility (passo 5)  
✅ Recarregue config (`⌘ ⌥ ⌃ R` ou Console → Reload)  
✅ Veja se Hammerspoon está rodando (ícone 🔨 na barra)

### "Force Quit não abre"
✅ Atualizado na v1.1.0! Baixe última versão  
✅ Teste manualmente: `⌘ ⌥ Esc` (deve funcionar)

### "TinyURL retorna erro"
✅ Verifique conexão internet  
✅ Certifique-se que selecionou uma URL válida (começa com http:// ou https://)

### "Console mostra erro em vermelho"
📖 Leia: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 📚 Próximos Passos

### Personalizar Atalhos
Edite `~/.hammerspoon/Spoons/CustomShortcuts.spoon/init.lua`

Exemplo: mudar `⌘ J` para `⌘ ⌥ J`:
```lua
-- Linha ~99
self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind({"cmd", "alt"}, "j", function()
  --                                                     ^^^^^ adicione "alt"
  hs.execute("open -b com.apple.exposelauncher")
  hs.alert("📱 Mission Control")
end)
```

Depois: Reload config (`⌘ ⌥ ⌃ R`)

### Adicionar Mais Funcionalidades
1. Explore outros Spoons: https://www.hammerspoon.org/Spoons/
2. Crie seus próprios atalhos em `~/.hammerspoon/init.lua`
3. Leia: [ARCHITECTURE.md](ARCHITECTURE.md) para entender a estrutura

### Contribuir
1. Fork este repositório
2. Adicione sua melhoria
3. Abra Pull Request
4. Veja: [ARCHITECTURE.md](ARCHITECTURE.md) → Contributing

---

## 🎓 Recursos de Aprendizado

| Recurso | Link |
|---------|------|
| **Hammerspoon Docs** | https://www.hammerspoon.org/docs/ |
| **Getting Started** | https://www.hammerspoon.org/go/ |
| **API Reference** | https://www.hammerspoon.org/docs/ |
| **Spoons** | https://www.hammerspoon.org/Spoons/ |
| **Lua Tutorial** | https://tylerneylon.com/a/learn-lua/ |
| **Community** | https://github.com/Hammerspoon/hammerspoon/discussions |

---

## 📖 Documentação Completa

| Documento | Descrição |
|-----------|-----------|
| [README.md](README.md) | Documentação principal |
| [QUICK_START.md](QUICK_START.md) | Este arquivo (início rápido) |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Solução de problemas |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Documentação técnica |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de versões |
| [RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md) | Análise técnica do código |

---

## ✅ Checklist Pós-Instalação

- [ ] Hammerspoon instalado
- [ ] Spoons copiados para `~/.hammerspoon/Spoons/`
- [ ] `init.lua` configurado
- [ ] Permissões de Accessibility ativadas
- [ ] Config recarregado (Reload)
- [ ] Testado atalho `⌘ ⌥ ⌃ A` (funciona?)
- [ ] Testado `⌘ I` com URL (funciona?)

**Se todos ✅ → Pronto para usar! 🎉**

---

## 💡 Dicas Úteis

### Ver Todos os Atalhos
```
⌘ ⌥ ⌃ H  →  Mostra ajuda (se configurado no init.example.lua)
```

### Recarregar Config Rapidamente
```bash
# Via terminal
killall Hammerspoon && open -a Hammerspoon
```

### Debug no Console
```lua
-- Adicione no seu código:
print("Debug: valor = " .. minha_variavel)
hs.alert("Teste!")
```

### Desabilitar Atalho Específico
```lua
-- No init.lua, comente a linha:
-- hs.loadSpoon("URLShortener")
-- spoon.URLShortener:start()
```

---

## 🎯 Casos de Uso

### 1. Desenvolvedor
```
⌘ I       → Abrir caminho de arquivo no editor
⌘ ⌥ ⌃ A   → Ver processos e uso de CPU
⌘ ⌥ ⌃ T   → Pegar cor de um design
⌘ ⇧ U     → Encurtar URL de documentação
```

### 2. Designer
```
⌘ ⌥ ⌃ T       → Color picker para paleta
⌘ ⌥ ⌃ Space   → Esconder janelas para screenshot
⌘ J           → Organizar janelas (Mission Control)
```

### 3. Usuário Geral
```
⌘ I           → Abrir links rapidamente
⌘ ⌥ ⌃ Q       → Forçar fechar app travado
⌘ ⌥ ⌃ P       → Acessar senhas
⌘ ⇧ U         → Encurtar URL para compartilhar
```

---

**Pronto! Você está usando Hammerspoon! 🚀**

*Dúvidas? Abra issue no GitHub ou consulte [TROUBLESHOOTING.md](TROUBLESHOOTING.md)*
