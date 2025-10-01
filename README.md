# 🔨 Hammerspoon Custom Shortcuts

**8 atalhos personalizados para otimizar seu workflow no macOS usando Hammerspoon**

Este projeto adiciona atalhos poderosos e confiáveis que funcionam universalmente em qualquer aplicativo, usando comandos de terminal para máxima compatibilidade.

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

## 📁 Arquivos

```
├── CustomShortcuts.spoon/      # Spoon principal (7 atalhos básicos)
│   └── init.lua               # Script principal do Spoon
├── URLShortener.spoon/         # Spoon para encurtar URLs
│   ├── init.lua               # Script do URL Shortener
│   └── README.md              # Documentação específica
├── init.lua                   # Script standalone (alternativa)
├── spoons_cheat_sheet.html    # Guia visual interativo
└── README.md                  # Este arquivo
```

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

### Conflitos com outros apps?
- Os atalhos foram escolhidos para evitar conflitos
- Se necessário, personalize no `init.lua`

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
