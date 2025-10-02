# 🔍 Guia de Configuração OCR - Atalhos Corrigidos

## ✅ Correções Implementadas

Os atalhos de OCR foram **completamente corrigidos e estabilizados** para funcionar em **Macs Apple Silicon com Homebrew**:

- **⇧ ⌃ ⌘ R** – OCR da área da tela (captura interativa)
- **⇧ ⌃ ⌘ F** – OCR de imagem no clipboard

## 🛠️ Instalação Obrigatória

### 1. Instalar Tesseract via Homebrew

```bash
# Instalar Tesseract com suporte a idiomas
brew install tesseract tesseract-lang

# Verificar instalação
tesseract --version
```

### 2. Configurar Permissões do Sistema

1. Abra **Configurações do Sistema**
2. Vá em **Privacidade e Segurança**
3. Clique em **Gravação de Tela**
4. Adicione **Hammerspoon** à lista
5. **Reinicie o Hammerspoon**

## 🔧 Melhorias Implementadas

### ✅ Detecção Automática de Arquitetura
- **Apple Silicon (M1/M2/M3)**: Busca Tesseract em `/opt/homebrew/bin/`
- **Intel Macs**: Busca Tesseract em `/usr/local/bin/`
- **Fallback**: Tenta caminhos alternativos automaticamente

### ✅ Configurações Otimizadas do Tesseract
- **Idiomas**: Português + Inglês (`-l por+eng`)
- **PSM Mode**: `--psm 6` (bloco uniforme de texto)
- **OCR Engine**: `--oem 3` (LSTM + Legacy)
- **Tratamento de Erros**: Mensagens claras e instruções de correção

### ✅ Fallback Robusto
- **Primeira opção**: Tesseract (mais preciso)
- **Segunda opção**: Vision API nativo do macOS
- **Tratamento**: Mensagens de erro informativas com soluções

### ✅ Suporte Expandido de Formatos
- **Imagens**: PNG, JPG, JPEG, GIF, BMP, TIFF, WebP
- **Documentos**: PDF (novo!)

### ✅ Tratamento Correto de Códigos de Retorno
- **Código 0**: Captura bem-sucedida → Processa OCR
- **Código 1**: Usuário cancelou (ESC) → Mensagem "Captura cancelada"
- **Outros códigos**: Erro real → Mensagem de permissão e abre configurações

### ✅ Workflow Simplificado
- **⇧ ⌃ ⌘ R**: Captura área da tela → clipboard → OCR
- **⇧ ⌃ ⌘ F**: OCR direto do que está no clipboard
- **Uso de hs.task**: Execução assíncrona sem travamentos

## 🚀 Como Usar

### OCR de Área da Tela (⇧ ⌃ ⌘ R)

1. **Opção 1 - Captura da Tela**:
   - Pressione `⇧ ⌃ ⌘ R`
   - Selecione área da tela com texto
   - Texto é extraído e copiado automaticamente

2. **Opção 2 - Imagem da Área de Transferência**:
   - Copie uma imagem (⌘C)
   - Pressione `⇧ ⌃ ⌘ R`
   - Texto da imagem é extraído

### OCR de Imagem no Clipboard (⇧ ⌃ ⌘ F)

1. Copie qualquer imagem (⌘C) - do Preview, Finder, navegador, etc.
2. Pressione `⇧ ⌃ ⌘ F`
3. Texto da imagem é extraído e copiado automaticamente

## 🔍 Teste de Configuração

Execute este comando no Terminal para verificar se tudo está configurado:

```bash
# Verificar Tesseract
which tesseract && tesseract --version

# Verificar idiomas instalados
tesseract --list-langs
```

## ⚠️ Solução de Problemas

### "OCR falhou ou nenhum texto encontrado"

**Causa**: Tesseract não instalado ou não encontrado

**Solução**:
```bash
brew install tesseract tesseract-lang
```

### "Falha na captura"

**Causa**: Permissões de gravação de tela não configuradas

**Solução**:
1. Configurações → Privacidade → Gravação de Tela
2. Adicionar Hammerspoon
3. Reiniciar Hammerspoon

### Tesseract não encontrado em Apple Silicon

**Causa**: Caminho incorreto

**Solução**: O código agora detecta automaticamente:
- `/opt/homebrew/bin/tesseract` (Apple Silicon)
- `/usr/local/bin/tesseract` (Intel)

## 📊 Recursos Técnicos

- **Detecção automática de arquitetura** (Apple Silicon vs Intel)
- **Múltiplos engines OCR** (Tesseract + Vision API)
- **Configurações otimizadas** para melhor precisão
- **Tratamento robusto de erros** com mensagens claras
- **Suporte a múltiplos formatos** de imagem
- **Organização inteligente de texto** por posição vertical

## ✨ Resultado

Após as correções, os atalhos OCR agora funcionam de forma **estável e confiável** em Macs Apple Silicon com Homebrew, com fallbacks robustos e mensagens de erro informativas.