# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### 1. ❌ Force Quit não funciona

**Problema:** Pressionar `⌘ ⌥ ⌃ Q` não abre o Force Quit dialog.

**Solução:**
- ✅ **FIXED** na versão atual!
- O código agora usa `key code 53` (Esc) com `⌘ ⌥` que é o atalho correto do macOS
- Se ainda não funcionar:
  1. Verifique se Hammerspoon tem permissão de Accessibility
  2. Teste manualmente: `⌘ ⌥ Esc` (deve abrir Force Quit)
  3. Recarregue o config: `⌘ ⌥ ⌃ R` ou Hammerspoon Console → Reload

**Código corrigido:**
```lua
hs.hotkey.bind({"cmd","alt","ctrl"}, "q", function()
  hs.execute([[osascript -e 'tell application "System Events" to key code 53 using {command down, option down}']])
  hs.alert("💀 Force Quit Applications")
end)
```

---

### 2. ❌ Show Desktop não funciona

**Problema:** Pressionar `⌘ ⌥ ⌃ Space` não esconde/mostra janelas.

**Solução:**
- ✅ **FIXED** na versão atual!
- Código agora usa múltiplas estratégias de fallback
- Método 1: Simula `⌘ ⌥ ⌃ D` via AppleScript
- Método 2: Usa API nativa `hs.spaces.toggleShowDesktop()`

**Se ainda não funcionar:**
1. Verifique se não há conflito de shortcuts:
   - System Settings → Keyboard → Keyboard Shortcuts → Mission Control
   - Verifique se "Show Desktop" está habilitado e qual é o atalho
2. Teste alternativas:
   - F11 (se configurado no Mission Control)
   - Gesto: Abrir polegar + 3 dedos (trackpad)
3. Configure manualmente no macOS:
   - System Settings → Keyboard → Keyboard Shortcuts → Mission Control
   - Defina "Show Desktop" como `⌘ ⌥ ⌃ D`

**Código melhorado:**
```lua
hs.hotkey.bind({"cmd","alt","ctrl"}, "space", function()
  local success = hs.osascript.applescript([[
    tell application "System Events"
      keystroke "d" using {command down, option down, control down}
    end tell
  ]])
  
  if not success then
    hs.spaces.toggleShowDesktop()
  end
  
  hs.alert("🖥️ Show Desktop")
end)
```

---

### 3. ⚠️ TinyURL às vezes falha

**Problema:** URL shortening retorna erro ou não funciona.

**Possíveis causas:**
1. **Sem conexão internet** → Verifique sua conexão
2. **URL inválida** → Certifique-se de que começa com `http://` ou `https://`
3. **Timeout do curl** → API do TinyURL pode estar lenta
4. **Caracteres especiais** → URL pode ter encoding incorreto

**Melhorias implementadas:**
- ✅ Mudado de HTTP para **HTTPS** (mais seguro)
- ✅ Adicionado timeout de 10 segundos (`-m 10`)
- ✅ Adicionado flag para seguir redirects (`-L`)
- ✅ Validação de resposta (verifica se retornou URL válida)
- ✅ Detecção de erros na resposta

**Testes:**
```bash
# Teste manual no terminal:
curl -s -L -m 10 "https://tinyurl.com/api-create.php?url=https%3A%2F%2Fgithub.com"

# Deve retornar algo como: https://tinyurl.com/abc123
```

**Se ainda falhar:**
1. Teste o comando `curl` manualmente
2. Verifique firewall/proxy bloqueando conexões
3. Use Bit.ly como alternativa (requer API token)

---

### 4. ⚠️ Bit.ly não funciona

**Problema:** `⌘ ⇧ ⌃ U` não encurta URLs com Bit.ly.

**Causa:** Bit.ly requer API token (não é gratuito sem limites).

**Solução:**
1. Obtenha um token grátis:
   - Acesse: https://app.bitly.com/
   - Crie conta (tem plano free com limite)
   - Settings → Developer Settings → API → Generate Token
   
2. Configure no seu `init.lua`:
   ```lua
   -- Se usando Spoon:
   hs.loadSpoon("URLShortener")
   spoon.URLShortener:setBitlyToken("seu_token_aqui")
   spoon.URLShortener:start()
   
   -- Se usando script standalone:
   local BITLY_TOKEN = "seu_token_aqui"
   ```

3. Teste novamente

**Alternativa:** Use apenas TinyURL (`⌘ ⇧ U`) que não requer token.

---

### 5. ❌ Hammerspoon não carrega

**Sintomas:**
- Ícone do Hammerspoon não aparece na barra de menu
- Atalhos não funcionam
- Console não abre

**Soluções:**

#### Verificar se está rodando:
```bash
ps aux | grep Hammerspoon
```

#### Abrir Console para ver erros:
1. Abra `/Applications/Hammerspoon.app`
2. Clique no ícone na barra de menu → Console
3. Olhe por erros em vermelho

#### Erros comuns no Console:

**Erro de sintaxe Lua:**
```
.../.hammerspoon/init.lua:42: unexpected symbol near ')'
```
→ Verifique sintaxe Lua na linha indicada

**Spoon não encontrado:**
```
Error loading Spoon: CustomShortcuts
```
→ Verifique se Spoon está em `~/.hammerspoon/Spoons/CustomShortcuts.spoon/init.lua`

**Permissão negada:**
```
Accessibility permission denied
```
→ System Settings → Privacy & Security → Accessibility → Ative Hammerspoon

---

### 6. ⚠️ Atalhos conflitam com outros apps

**Problema:** Alguns atalhos não funcionam em determinados apps.

**Causa:** Conflito de keyboard shortcuts.

**Soluções:**

1. **Identificar conflito:**
   - Abra o app problemático
   - Vá em `Menu > Preferences > Keyboard Shortcuts`
   - Procure por atalhos que usam as mesmas teclas

2. **Desabilitar atalho conflitante:**
   - No app: desabilite o atalho conflitante
   - OU no Hammerspoon: mude o atalho editando o código

3. **Exemplos comuns:**
   - `⌘ I` pode conflitar com "Get Info" no Finder
   - `⌘ J` pode conflitar com "Jump to Selection"
   
4. **Desabilitar atalho específico no Hammerspoon:**
   ```lua
   -- No seu init.lua, comente a linha:
   -- hs.hotkey.bind({"cmd"}, "i", function() ... end)
   ```

---

### 7. 🔐 Permissões necessárias

**Hammerspoon precisa de permissões especiais para funcionar corretamente.**

#### Verificar permissões:

**System Settings → Privacy & Security:**

1. **✅ Accessibility** (OBRIGATÓRIO)
   - Permite controlar teclado/mouse
   - Necessário para: TODOS os atalhos
   - Sem isso, NADA funciona

2. **✅ Screen & System Audio Recording** (Opcional)
   - Necessário para: Color Picker
   - Se não ativar: Digital Color Meter pode não funcionar

3. **Automation** (Automático)
   - macOS solicita quando necessário
   - Ex: "Hammerspoon wants to control System Events"
   - Clique "OK" quando aparecer

#### Como ativar:
1. System Settings (⌘ ,)
2. Privacy & Security
3. Accessibility
4. Clique no 🔒 para desbloquear
5. Ative ☑️ Hammerspoon
6. Repita para "Screen Recording" se necessário

---

### 8. 🔄 Como recarregar configuração

**Método 1: Atalho** (recomendado)
- Pressione `⌘ ⌥ ⌃ R` (se configurado no `init.example.lua`)

**Método 2: Console**
1. Hammerspoon menu → Console
2. Clique botão "Reload Config"

**Método 3: Código**
```lua
hs.reload()
```

**Método 4: Terminal**
```bash
# Reiniciar Hammerspoon completamente
killall Hammerspoon && open -a Hammerspoon
```

---

### 9. 🧪 Testar se está funcionando

**Teste rápido:**
1. Abra Hammerspoon Console
2. Cole e execute:
   ```lua
   hs.alert("Hammerspoon works! ✅")
   ```
3. Deve aparecer alerta na tela

**Teste atalhos:**
1. Pressione `⌘ ⌥ ⌃ A` (Activity Monitor)
2. Deve abrir o Activity Monitor e mostrar alerta

**Teste TinyURL:**
1. Selecione texto: `https://github.com`
2. Pressione `⌘ ⇧ U`
3. Deve mostrar "🔄 Encurtando…" e depois o link curto

---

### 10. 📝 Logs e debugging

**Ver logs em tempo real:**
```lua
-- Adicione no seu código para debug:
hs.console.printStyledtext("Debug: URL = " .. url)
```

**Abrir console automaticamente:**
```lua
-- No init.lua:
hs.console.clearConsole()
hs.console.show()
```

**Testar comandos shell:**
```lua
-- No console Hammerspoon:
hs.execute("echo 'test'")
```

**Verificar variáveis:**
```lua
print(hs.inspect(minhaVariavel))
```

---

## 🆘 Ainda não funciona?

1. **Restart Hammerspoon:**
   ```bash
   killall Hammerspoon && open -a Hammerspoon
   ```

2. **Restart macOS:**
   - Às vezes permissões só são aplicadas após reiniciar

3. **Reinstalar Hammerspoon:**
   ```bash
   brew uninstall --cask hammerspoon
   brew install --cask hammerspoon
   ```

4. **Verificar versão do macOS:**
   - Hammerspoon funciona melhor no macOS 12.0+
   - Algumas APIs não funcionam em versões antigas

5. **Reportar bug:**
   - Abra issue no GitHub com:
     - Versão do macOS
     - Versão do Hammerspoon
     - Logs do Console
     - Descrição do problema

---

## ✅ Checklist de diagnóstico

- [ ] Hammerspoon está rodando (ícone na barra de menu)
- [ ] Console não mostra erros em vermelho
- [ ] Permissões de Accessibility ativadas
- [ ] Spoons estão em `~/.hammerspoon/Spoons/`
- [ ] Config recarregado (`⌘ ⌥ ⌃ R` ou Console → Reload)
- [ ] Testado `hs.alert("test")` no Console (funciona?)
- [ ] Testado atalho `⌘ ⌥ ⌃ A` (abre Activity Monitor?)
- [ ] Verificado conflitos de shortcuts com outros apps
- [ ] Verificado conexão internet (para TinyURL)
- [ ] Verificado versão do macOS (12.0+)

Se TODOS os itens acima estão ✅ e ainda não funciona, abra uma issue no GitHub!
