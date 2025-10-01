## Hammerspoon Shortcuts — Cheat Sheet

Use estes atalhos universais em qualquer app. Se algo não funcionar, verifique as permissões de Acessibilidade/Automação do Hammerspoon.

### Atalhos principais

| Atalho | Função | O que faz | Exemplo rápido |
|---|---|---|---|
| ⌘ I | Abrir Arquivos/URLs | Abre URL, caminho ou item do Finder | Selecione `https://apple.com` → ⌘ I → abre no navegador |
| ⌘ J | Mission Control | Mostra desktops e janelas | Pressione ⌘ J |
| ⌘ ⌥ ⌃ T | Digital Color Meter | Abre o color picker do macOS | ⌘ ⌥ ⌃ T → use ⌘ L para “Lock/Copy” |
| ⌘ ⌥ ⌃ Q | Force Quit | Abre a janela de Forçar Encerrar | ⌘ ⌥ ⌃ Q |
| ⌘ ⌥ ⌃ A | Activity Monitor | Abre o Monitor de Atividade | ⌘ ⌥ ⌃ A |
| ⌘ ⌥ ⌃ P | Passwords | Abre o app Passwords | ⌘ ⌥ ⌃ P |
| ⌘ ⌥ ⌃ Space | Show Desktop | Tenta F11 e faz fallback para ocultar outros | ⌘ ⌥ ⌃ Space |
| ⌘ ⇧ U | URL Shortener (TinyURL) | Encurta URL e copia para a área de transferência | Selecione URL → ⌘ ⇧ U |
| ⌘ ⇧ ⌥ U | URL Shortener + QR | Encurta e abre QR no navegador | Selecione URL → ⌘ ⇧ ⌥ U |
| ⌘ ⇧ ⌃ U | URL Shortener (Bit.ly) | Requer token do Bit.ly | Selecione URL → ⌘ ⇧ ⌃ U |

### Dicas de uso

- Para abrir caminhos, pode colar `file:///Users/voce/arquivo.pdf` ou `/Users/voce/arquivo.pdf` e usar ⌘ I.
- Se o Show Desktop não reagir, o fallback esconde outros apps automaticamente em ~250ms.
- Para encurtar URLs, basta selecionar na tela (em qualquer app) e usar ⌘ ⇧ U.
- QR Code abre no navegador padrão. Copie/baixe a imagem como quiser.

### Requisitos e permissões

- System Settings → Privacy & Security → Accessibility: habilite “Hammerspoon”.
- Para Color Picker, pode ser necessário Screen Recording para capturar cores na tela.

### Personalização

- Usando script direto: edite `~/.hammerspoon/init.lua`.
- Usando Spoons: edite `~/.hammerspoon/Spoons/CustomShortcuts.spoon/init.lua` e `URLShortener.spoon/init.lua`.

### Encurtadores suportados

- TinyURL (sem token): HTTPS via `https://tinyurl.com/api-create.php?url=...`.
- Bit.ly (opcional): configure token e use ⌘ ⇧ ⌃ U.

### Solução de problemas

- Atalho não funciona? Recarregue a config no Hammerspoon (Console → Reload Config) e verifique permissões.
- Conflito de atalho? Altere a combinação no arquivo correspondente e recarregue.

