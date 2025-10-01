# 🔨 Hammerspoon Custom Shortcuts

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Hammerspoon](https://img.shields.io/badge/Hammerspoon-0.9.100+-blue.svg)](https://www.hammerspoon.org/)
[![macOS](https://img.shields.io/badge/macOS-12.0+-blue.svg)](https://www.apple.com/macos/)
[![Status](https://img.shields.io/badge/Status-Ready-brightgreen.svg)]()

**8 atalhos personalizados para otimizar seu workflow no macOS usando Hammerspoon**

Este projeto adiciona atalhos poderosos e confiáveis que funcionam universalmente em qualquer aplicativo, usando comandos de terminal para máxima compatibilidade.

> 📝 **v1.1.0** - Force Quit e Show Desktop corrigidos! Veja [CHANGELOG.md](CHANGELOG.md)

---

## 🚀 Quick Start

**Instalação em 2 comandos:**

```bash
# 1. Instalar Hammerspoon
brew install --cask hammerspoon

# 2. Instalar este projeto (script automático)
curl -fsSL https://raw.githubusercontent.com/miranda-rodrigo/macOS-useful-automations-hammerspoon/main/install.sh | bash
```

**OU veja:** [QUICK_START.md](QUICK_START.md) para instalação manual passo-a-passo.

---

## ✨ Funcionalidades

| Atalho | Função | Descrição |
|--------|--------|-----------|
| `⌘ I` | **Abrir Arquivos/URLs** | Abre URLs, caminhos de arquivo ou itens selecionados no Finder |
| `⌘ J` | **Mission Control** | Mostra todos os Desktops e janelas abertas |
| `⌘ ⌥ ⌃ T` | **Color Picker** | Abre Digital Color Meter nativo (⌘+L para copiar) |
| `⌘ ⌥ ⌃ Q` | **Force Quit** | Abre janela Force Quit Applications |
| `⌘ ⌥ ⌃ A` | **Activity Monitor** | Abre monitor de processos e performance |
| `⌘ ⌥ ⌃ P` | **Passwords** | Abre gerenciador de senhas nativo |
| `⌘ ⌥ ⌃ Space` | **Show Desktop** | Esconde/mostra todas as janelas |
| `⌘ ⇧ U` | **URL Shortener** | Encurta URLs usando TinyURL/Bit.ly (Spoon separado) |

## 🚀 Instalação

### 1. Instalar Hammerspoon
```bash
# Via Homebrew
brew install --cask hammerspoon

# Ou baixe diretamente: https://www.hammerspoon.org/
```

### 2. Opção A: Usar como Spoon (Recomendado)
```bash
# Clone este repositório
git clone https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon.git

# Instale os Spoons
cp -r macOS-useful-automations-hammerspoon/CustomShortcuts.spoon ~/.hammerspoon/Spoons/
cp -r macOS-useful-automations-hammerspoon/URLShortener.spoon ~/.hammerspoon/Spoons/

# Adicione ao seu ~/.hammerspoon/init.lua:
hs.loadSpoon("CustomShortcuts")
spoon.CustomShortcuts:start()

# Para usar o URL Shortener (opcional):
hs.loadSpoon("URLShortener")
spoon.URLShortener:start()
-- spoon.URLShortener:setBitlyToken("seu_token_bitly") -- Opcional
```

### 2. Opção B: Usar como script direto
```bash
# Copie o arquivo de configuração
cp macOS-useful-automations-hammerspoon/init.lua ~/.hammerspoon/init.lua
```

### 3. Ativar no Hammerspoon
1. Abra o Hammerspoon
2. Clique no ícone da colher na barra de menu
3. Selecione "Console"
4. Clique "Reload Config"

### 4. Configurar permissões (se necessário)
- **System Settings** → **Privacy & Security**
- **Accessibility** → Ative "Hammerspoon"
- **Screen & System Audio Recording** → Ative "Hammerspoon" (para color picker)

## 📖 Como Usar

### 🌐 Abrir URLs/Arquivos (⌘ I)
**Funciona em qualquer lugar:**
```
• Selecione "https://github.com" → ⌘ I → abre no navegador
• Selecione "/Applications" → ⌘ I → abre pasta Applications  
• Selecione arquivo no Finder → ⌘ I → abre o item
• Funciona com: URLs, caminhos, file:// URLs
```

### 🖥️ Controle de Janelas
```
⌘ J                → Mission Control (todos os desktops)
⌘ ⌥ ⌃ Space       → Show Desktop (esconder/mostrar janelas)
```

### 🛠️ Ferramentas do Sistema
```
⌘ ⌥ ⌃ T           → Digital Color Meter
⌘ ⌥ ⌃ Q           → Force Quit Applications  
⌘ ⌥ ⌃ A           → Activity Monitor
⌘ ⌥ ⌃ P           → Passwords App
⌘ ⇧ U             → URL Shortener (TinyURL)
⌘ ⇧ ⌥ U           → URL Shortener + QR Code
⌘ ⇧ ⌃ U           → URL Shortener (Bit.ly)
```

## 🎯 Vantagens

- **✅ Universal**: Funciona em qualquer aplicativo
- **✅ Confiável**: Usa comandos de terminal, não simula teclas
- **✅ Sem conflitos**: Atalhos únicos que não interferem com apps
- **✅ Sem permissões especiais**: Maioria funciona sem configuração extra
- **✅ Rápido**: Acesso instantâneo a ferramentas essenciais

## 📁 Estrutura do Projeto

```
├── Spoons/
│   ├── CustomShortcuts.spoon/  # Spoon principal (7 atalhos básicos)
│   │   └── init.lua
│   └── URLShortener.spoon/     # Spoon para encurtar URLs
│       └── init.lua
│
├── init.lua                    # Script standalone (alternativa)
├── init.example.lua            # 📖 Exemplo de configuração comentado
├── install.sh                  # 🔧 Script de instalação automática
│
├── README.md                   # 📖 Este arquivo (começe aqui!)
├── QUICK_START.md              # 🚀 Guia rápido (5 minutos)
├── RESUMO_EXECUTIVO.md         # 📊 Resumo técnico e melhorias
├── TROUBLESHOOTING.md          # 🔧 Guia de solução de problemas (10 tópicos)
├── ARCHITECTURE.md             # 🏗️ Documentação técnica detalhada
├── CHANGELOG.md                # 📋 Histórico de versões
├── LICENSE                     # 📄 MIT License
│
└── docs/
    └── spoons_cheat_sheet.html # Guia visual interativo
```

### 📖 Guia de Documentação

| Arquivo | Descrição | Para quem? |
|---------|-----------|------------|
| **README.md** | Documentação principal completa | 👤 Todos os usuários |
| **QUICK_START.md** | Guia rápido de início (5 min) | 🚀 Novos usuários |
| **RESUMO_EXECUTIVO.md** | Resumo das melhorias (v1.1.0) | 👨‍💻 Desenvolvedores |
| **TROUBLESHOOTING.md** | Solução de 10 problemas comuns | 🆘 Usuários com problemas |
| **ARCHITECTURE.md** | Decisões técnicas e estrutura | 🏗️ Contribuidores |
| **CHANGELOG.md** | Histórico de mudanças | 📋 Todos |
| **init.example.lua** | Config de exemplo comentado | ⚙️ Configuração |
| **install.sh** | Script de instalação automática | 🔧 Instalação rápida |

## 🔧 Personalização

### Se usando como Spoon:
Edite `~/.hammerspoon/Spoons/CustomShortcuts.spoon/init.lua` e depois:
```lua
-- No seu ~/.hammerspoon/init.lua
spoon.CustomShortcuts:stop()  -- Para os atalhos atuais
hs.reload()                   -- Recarrega a configuração
```

### Se usando como script direto:
Edite `~/.hammerspoon/init.lua` diretamente:
```lua
-- Exemplo: mudar ⌘ J para ⌘ ⌥ J
hs.hotkey.bind({"cmd", "alt"}, "j", function()
  hs.execute("open -b com.apple.exposelauncher")
  hs.alert("📱 Mission Control")
end)
```

Após qualquer mudança:
1. Salve o arquivo
2. Abra Hammerspoon Console
3. Clique "Reload Config"

## 🐛 Solução de Problemas

### Atalhos não funcionam?
1. Verifique se o Hammerspoon está rodando
2. Reload config no Console
3. Verifique permissões de Accessibility

### Color picker não funciona?
- Ative "Screen & System Audio Recording" para Hammerspoon

### Force Quit ou Show Desktop não funcionam?
- ✅ **FIXED** na última versão!
- Atualize para a versão mais recente
- Veja [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para detalhes

### TinyURL retorna erro?
- ✅ **IMPROVED** - Agora usa HTTPS com timeout
- Verifique sua conexão internet
- Veja [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para diagnóstico completo

### Conflitos com outros apps?
- Os atalhos foram escolhidos para evitar conflitos
- Se necessário, personalize no `init.lua`
- Veja [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para resolver conflitos

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch: `git checkout -b nova-funcionalidade`
3. Commit: `git commit -m 'Adiciona nova funcionalidade'`
4. Push: `git push origin nova-funcionalidade`
5. Abra um Pull Request

## 📄 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

## ⭐ Créditos

Criado com ❤️ para otimizar o workflow no macOS usando [Hammerspoon](https://www.hammerspoon.org/).

---

**💡 Dica:** Abra o arquivo `hammerspoon-shortcuts.html` no navegador para um guia visual interativo com exemplos práticos!
