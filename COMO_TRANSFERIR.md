# 📦 Como Transferir os Arquivos para o Diretório Correto

Este guia mostra como transferir todos os arquivos da extensão Explorer Tools do workspace atual para o diretório de destino.

---

## 🎯 Diretório de Destino

```
/Users/rodrigomiranda/useful-repos/cursor-vscode-utils/
```

---

## ✅ Método 1: Script Automático (Recomendado)

### Passo a Passo:

1. **Abra um terminal no seu Mac**

2. **Execute o script de transferência:**
   ```bash
   bash /workspace/TRANSFER_FILES.sh
   ```

3. **O script vai:**
   - Criar o diretório de destino se não existir
   - Copiar todos os arquivos necessários
   - Copiar os diretórios `src/`, `.vscode/` e `media/`
   - Mostrar progresso da cópia

4. **Pronto!** Todos os arquivos estarão em:
   ```
   /Users/rodrigomiranda/useful-repos/cursor-vscode-utils/
   ```

---

## 📋 Método 2: Cópia Manual

Se o script não funcionar, use estes comandos:

### 1. Criar diretório de destino
```bash
mkdir -p /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
cd /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
```

### 2. Copiar arquivos de configuração
```bash
cp /workspace/package.json .
cp /workspace/tsconfig.json .
cp /workspace/.eslintrc.json .
cp /workspace/.gitignore .
cp /workspace/.vscodeignore .
cp /workspace/.editorconfig .
cp /workspace/.npmrc .
```

### 3. Copiar documentação
```bash
cp /workspace/README.md .
cp /workspace/QUICK_START.md .
cp /workspace/DEVELOPMENT.md .
cp /workspace/INSTALL.md .
cp /workspace/CHANGELOG.md .
cp /workspace/LICENSE .
cp /workspace/REPOSITORY_SUMMARY.md .
cp /workspace/FILE_INDEX.md .
cp /workspace/PROJECT_STRUCTURE.txt .
cp /workspace/EXECUTIVE_SUMMARY.md .
cp /workspace/INDEX.md .
cp /workspace/LEIA-ME.md .
```

### 4. Copiar diretórios
```bash
cp -r /workspace/src .
cp -r /workspace/.vscode .
cp -r /workspace/media .
```

---

## 🔍 Método 3: Via Finder (Interface Gráfica)

1. **Abra o Finder**

2. **Navegue até:** `/workspace/`

3. **Selecione todos estes arquivos e pastas:**
   - ✅ `package.json`
   - ✅ `tsconfig.json`
   - ✅ `.eslintrc.json`
   - ✅ `.gitignore`
   - ✅ `.vscodeignore`
   - ✅ `.editorconfig`
   - ✅ `.npmrc`
   - ✅ Todos os arquivos `.md`
   - ✅ `LICENSE`
   - ✅ `PROJECT_STRUCTURE.txt`
   - ✅ Pasta `src/`
   - ✅ Pasta `.vscode/`
   - ✅ Pasta `media/`

4. **Copie** (`Cmd+C`)

5. **Navegue até:** `/Users/rodrigomiranda/useful-repos/`

6. **Crie a pasta** `cursor-vscode-utils` (se não existir)

7. **Entre na pasta** e **cole** (`Cmd+V`)

---

## 📦 Lista de Arquivos a Transferir

### Arquivos de Configuração (7)
- [x] `package.json`
- [x] `tsconfig.json`
- [x] `.eslintrc.json`
- [x] `.gitignore`
- [x] `.vscodeignore`
- [x] `.editorconfig`
- [x] `.npmrc`

### Documentação (12)
- [x] `README.md`
- [x] `QUICK_START.md`
- [x] `DEVELOPMENT.md`
- [x] `INSTALL.md`
- [x] `CHANGELOG.md`
- [x] `LICENSE`
- [x] `REPOSITORY_SUMMARY.md`
- [x] `FILE_INDEX.md`
- [x] `PROJECT_STRUCTURE.txt`
- [x] `EXECUTIVE_SUMMARY.md`
- [x] `INDEX.md`
- [x] `LEIA-ME.md`

### Diretórios (3)
- [x] `src/` (4 arquivos TypeScript)
- [x] `.vscode/` (3 arquivos de configuração)
- [x] `media/` (2 placeholders)

### Arquivos Auxiliares (Opcionais)
- [ ] `TRANSFER_FILES.sh` (este script)
- [ ] `COMO_TRANSFERIR.md` (este guia)

**Total:** 22 arquivos + 3 diretórios = **25 itens**

---

## ✅ Verificação Após Transferência

Depois de transferir, verifique se tudo está correto:

```bash
cd /Users/rodrigomiranda/useful-repos/cursor-vscode-utils

# Verificar estrutura
ls -la

# Deve mostrar:
# - package.json
# - tsconfig.json
# - src/
# - .vscode/
# - media/
# - Arquivos .md
# - etc.

# Verificar conteúdo do src/
ls -la src/

# Deve mostrar:
# - extension.ts
# - test/

# Testar a instalação
npm install
```

---

## 🚀 Próximos Passos Após Transferência

1. **Navegue até o diretório:**
   ```bash
   cd /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
   ```

2. **Instale as dependências:**
   ```bash
   npm install
   ```

3. **Compile o TypeScript:**
   ```bash
   npm run compile
   ```
   
   Ou use watch mode:
   ```bash
   npm run watch
   ```

4. **Abra no VS Code:**
   ```bash
   code .
   ```

5. **Teste a extensão:**
   - Pressione `F5` no VS Code
   - Abre Extension Development Host
   - Teste os comandos no Explorer

6. **Execute os testes:**
   ```bash
   npm test
   ```

7. **Crie o pacote VSIX:**
   ```bash
   npm run package
   ```

---

## 🐛 Troubleshooting

### Problema: "Permission denied"
```bash
# Verifique permissões
ls -la /Users/rodrigomiranda/useful-repos/

# Se necessário, ajuste permissões
sudo chown -R rodrigomiranda:staff /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
```

### Problema: "Directory not found"
```bash
# Crie os diretórios pai
mkdir -p /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
```

### Problema: "File already exists"
```bash
# Remova o diretório antigo (cuidado!)
rm -rf /Users/rodrigomiranda/useful-repos/cursor-vscode-utils

# E refaça a cópia
bash /workspace/TRANSFER_FILES.sh
```

### Problema: Arquivos ocultos não aparecem no Finder
```bash
# No terminal, mostre arquivos ocultos:
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder
```

---

## 📞 Comandos Úteis

### Ver todos os arquivos (incluindo ocultos)
```bash
ls -la /workspace/
```

### Contar arquivos
```bash
find /workspace -maxdepth 1 -type f | wc -l
```

### Ver estrutura de diretórios
```bash
cd /workspace
find . -type f -not -path "./node_modules/*" -not -path "./out/*" | sort
```

### Verificar se arquivo existe
```bash
test -f /workspace/package.json && echo "Existe" || echo "Não existe"
```

---

## ✨ Dica Final

Se você estiver usando o Cursor, pode simplesmente:

1. Abrir o diretório `/workspace/` no Cursor
2. Selecionar todos os arquivos necessários no Explorer
3. Arrastar e soltar para `/Users/rodrigomiranda/useful-repos/cursor-vscode-utils/`

Ou:

1. `Cmd+C` nos arquivos em `/workspace/`
2. Navegar para `/Users/rodrigomiranda/useful-repos/cursor-vscode-utils/`
3. `Cmd+V` para colar

---

## 📊 Resumo

**Arquivos a copiar:** 22 arquivos + 3 diretórios  
**Tamanho estimado:** ~50 MB (incluindo node_modules após npm install)  
**Tempo estimado:** 1-2 minutos  

**Métodos disponíveis:**
1. ⭐ Script automático (`TRANSFER_FILES.sh`)
2. Terminal manual (comandos `cp`)
3. Finder (interface gráfica)

**Recomendação:** Use o **Método 1** (script) para garantir que todos os arquivos sejam copiados corretamente.

---

**Boa sorte com a transferência!** 🚀

Se tiver problemas, verifique as permissões do diretório de destino.
