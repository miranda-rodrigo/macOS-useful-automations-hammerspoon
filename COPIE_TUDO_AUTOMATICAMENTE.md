# 🚀 COPIAR TUDO AUTOMATICAMENTE

## ⚡ MÉTODO AUTOMÁTICO (Recomendado)

### Opção 1: Execute o Script Automático

**Baixe e execute este único arquivo:**

```bash
bash AUTO_TRANSFER.sh
```

**Pronto!** O script vai:
- ✅ Criar o diretório de destino automaticamente
- ✅ Copiar TODOS os arquivos (código, config, docs)
- ✅ Verificar se tudo foi copiado
- ✅ Perguntar se quer instalar dependências
- ✅ Perguntar se quer compilar
- ✅ Abrir no VS Code

**Sem interação necessária!** Tudo é feito automaticamente.

---

## 📋 OU Use Este Comando Único

Copie e cole no terminal:

```bash
# Criar diretório + Copiar tudo
mkdir -p ~/useful-repos/cursor-vscode-utils && \
cd "$(dirname "$0")" && \
cp -r src .vscode media *.json *.md *.txt LICENSE .eslintrc* .gitignore .vscodeignore .editorconfig .npmrc *.sh ~/useful-repos/cursor-vscode-utils/ 2>/dev/null ; \
echo "✅ Arquivos copiados!" && \
ls -la ~/useful-repos/cursor-vscode-utils/
```

---

## 🎯 LOCALIZAÇÃO DOS ARQUIVOS

**Origem (workspace remoto):**
```
/workspace/
```

**Destino (seu Mac):**
```
/Users/rodrigomiranda/useful-repos/cursor-vscode-utils/
```

Ou simplesmente:
```
~/useful-repos/cursor-vscode-utils/
```

---

## 📦 O QUE SERÁ COPIADO

### Código Fonte (4 arquivos)
- ✅ `src/extension.ts` ⭐
- ✅ `src/test/runTest.ts`
- ✅ `src/test/suite/index.ts`
- ✅ `src/test/suite/extension.test.ts`

### Configuração (7 arquivos)
- ✅ `package.json` ⭐
- ✅ `tsconfig.json`
- ✅ `.eslintrc.json`
- ✅ `.gitignore`
- ✅ `.vscodeignore`
- ✅ `.editorconfig`
- ✅ `.npmrc`

### Documentação (15+ arquivos)
- ✅ `README.md` ⭐
- ✅ `QUICK_START.md`
- ✅ `DEVELOPMENT.md`
- ✅ E mais 12 guias...

### Diretórios
- ✅ `src/` (código TypeScript)
- ✅ `.vscode/` (configuração VS Code)
- ✅ `media/` (assets)

**Total:** 26+ arquivos copiados automaticamente!

---

## ✅ DEPOIS DE COPIAR

O script pergunta se você quer:
1. **Instalar dependências?** (npm install)
2. **Compilar TypeScript?** (npm run compile)
3. **Abrir no VS Code?** (code .)

Se responder "sim" para tudo, em 2 minutos está pronto para usar!

Ou faça manualmente:

```bash
cd ~/useful-repos/cursor-vscode-utils
npm install
npm run compile
code .
# Pressione F5 para testar!
```

---

## 🔧 SE O SCRIPT NÃO FUNCIONAR

### Método Manual Rápido:

```bash
# 1. Criar diretório
mkdir -p ~/useful-repos/cursor-vscode-utils

# 2. No Cursor, vá para /workspace/
# 3. Selecione TODOS os arquivos (Cmd+A)
# 4. Copie (Cmd+C)
# 5. Vá para ~/useful-repos/cursor-vscode-utils/
# 6. Cole (Cmd+V)
```

---

## 🎉 RESULTADO FINAL

Após executar o script ou copiar manualmente:

```
~/useful-repos/cursor-vscode-utils/
├── src/
│   ├── extension.ts          ⭐ Código principal
│   └── test/
├── .vscode/
├── media/
├── package.json              ⭐ Configuração
├── README.md                 ⭐ Documentação
└── ... (mais 20+ arquivos)
```

**Tudo pronto para desenvolver!** 🚀

---

## 💡 DICA PRO

Execute este comando de qualquer lugar:

```bash
bash <(curl -s https://raw.githubusercontent.com/seu-usuario/explorer-tools/main/AUTO_TRANSFER.sh)
```

(Após publicar no GitHub)

Ou simplesmente:

```bash
bash AUTO_TRANSFER.sh
```

---

## 📞 RESUMO ULTRA-RÁPIDO

1. **Baixe:** `AUTO_TRANSFER.sh`
2. **Execute:** `bash AUTO_TRANSFER.sh`
3. **Aguarde:** ~30 segundos
4. **Pronto!** Arquivos copiados

**Não precisa fazer NADA manualmente!** ⚡

---

**🎊 Aproveite sua extensão!**
