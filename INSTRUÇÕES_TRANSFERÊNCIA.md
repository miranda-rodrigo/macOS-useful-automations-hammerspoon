# 🚀 INSTRUÇÕES PARA TRANSFERIR ARQUIVOS

## 📍 SITUAÇÃO ATUAL

- **Arquivos criados em**: `/workspace/`
- **Destino desejado**: `/Users/rodrigomiranda/useful-repos/cursor-vscode-utils/`

---

## ⚡ SOLUÇÃO RÁPIDA (1 comando)

Copie e cole este comando no terminal do seu Mac:

```bash
mkdir -p /Users/rodrigomiranda/useful-repos/cursor-vscode-utils && \
cd /workspace && \
cp -r src .vscode media package.json tsconfig.json .eslintrc.json .gitignore .vscodeignore .editorconfig .npmrc README.md QUICK_START.md DEVELOPMENT.md INSTALL.md CHANGELOG.md LICENSE REPOSITORY_SUMMARY.md FILE_INDEX.md PROJECT_STRUCTURE.txt EXECUTIVE_SUMMARY.md INDEX.md LEIA-ME.md /Users/rodrigomiranda/useful-repos/cursor-vscode-utils/ && \
echo "✅ Arquivos copiados com sucesso!" && \
ls -la /Users/rodrigomiranda/useful-repos/cursor-vscode-utils/
```

---

## 📋 OU PASSO A PASSO:

### 1️⃣ Criar o diretório de destino
```bash
mkdir -p /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
```

### 2️⃣ Copiar todos os arquivos
```bash
cd /workspace
cp -r src .vscode media package.json tsconfig.json .eslintrc.json .gitignore .vscodeignore .editorconfig .npmrc *.md LICENSE *.txt /Users/rodrigomiranda/useful-repos/cursor-vscode-utils/
```

### 3️⃣ Verificar
```bash
ls -la /Users/rodrigomiranda/useful-repos/cursor-vscode-utils/
```

### 4️⃣ Ir para o diretório e configurar
```bash
cd /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
npm install
npm run compile
```

### 5️⃣ Abrir no VS Code
```bash
code .
```

### 6️⃣ Pressionar F5 para testar!

---

## 📦 O QUE SERÁ COPIADO

✅ **22 arquivos:**
- package.json
- tsconfig.json
- .eslintrc.json
- .gitignore, .vscodeignore, .editorconfig, .npmrc
- README.md e 11 outros arquivos de documentação
- LICENSE
- PROJECT_STRUCTURE.txt

✅ **3 diretórios:**
- `src/` (código TypeScript)
- `.vscode/` (configuração)
- `media/` (assets)

---

## ✅ CHECKLIST

Após copiar, verifique:

- [ ] Existe `package.json` no destino
- [ ] Existe pasta `src/` com `extension.ts`
- [ ] Existe pasta `.vscode/` com `launch.json`
- [ ] Existem arquivos `.md` (documentação)

---

## 🆘 SE DER PROBLEMA

### "Permission denied"
```bash
sudo chown -R rodrigomiranda /Users/rodrigomiranda/useful-repos/
```

### "Directory not found"
```bash
mkdir -p /Users/rodrigomiranda/useful-repos
mkdir -p /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
```

### "File not found"
Verifique se está executando no contexto correto. O `/workspace/` pode não estar acessível diretamente no seu Mac. Neste caso:

1. Baixe os arquivos do workspace remoto
2. Ou use o Cursor para copiar/colar manualmente

---

## 💡 ALTERNATIVA: USAR O CURSOR

Se você está no Cursor e tem acesso visual aos arquivos:

1. No Explorer do Cursor, navegue até `/workspace/`
2. Selecione todos os arquivos (Cmd+A)
3. Copie (Cmd+C)
4. Navegue até `/Users/rodrigomiranda/useful-repos/cursor-vscode-utils/`
5. Cole (Cmd+V)

---

## 🎉 DEPOIS DA TRANSFERÊNCIA

```bash
cd /Users/rodrigomiranda/useful-repos/cursor-vscode-utils
npm install
npm run watch
# Pressione F5 no VS Code
```

---

**🚀 Boa transferência!**
