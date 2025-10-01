# Explorer Tools - Extensão para VS Code

> **Nota**: Este é um resumo em português. Documentação completa em inglês está disponível em [README.md](README.md).

## 🎯 O que faz?

Adiciona 3 comandos poderosos no menu de contexto do Explorer do VS Code:

1. **Open in File Manager** - Abre o gerenciador de arquivos do sistema
   - macOS: Abre no Finder
   - Windows: Abre no Explorer
   - Linux: Abre no gerenciador de arquivos padrão

2. **Open Dedicated Terminal Here** - Cria novo terminal na pasta
   - Terminal dedicado (não reutiliza existentes)
   - Nome: `Dedicated: <nome-da-pasta>`
   - Abre no diretório correto

3. **Open New VS Code Window Here** - Abre nova janela do VS Code
   - Sempre abre em nova janela (não aba)
   - Focado no diretório selecionado

## 🚀 Instalação Rápida

```bash
# 1. Instalar dependências
npm install

# 2. Compilar
npm run compile

# 3. Testar (pressione F5 no VS Code)
# ou
npm run watch  # depois pressione F5
```

## 📦 Gerar Pacote VSIX

```bash
npm run package
# Cria: explorer-tools-0.0.1.vsix
```

## 🧪 Testar

```bash
# Executar testes
npm test

# Verificar código
npm run lint
```

## 📁 Estrutura do Projeto

```
explorer-tools/
├── src/
│   ├── extension.ts           # Código principal
│   └── test/                  # Testes
├── package.json               # Configuração da extensão
├── tsconfig.json              # Configuração TypeScript
├── README.md                  # Documentação completa (inglês)
├── LEIA-ME.md                 # Este arquivo (português)
└── ...
```

## 🔧 Comandos Úteis

| Comando | Descrição |
|---------|-----------|
| `npm install` | Instala dependências |
| `npm run compile` | Compila TypeScript |
| `npm run watch` | Compila automaticamente |
| `npm run lint` | Verifica código |
| `npm test` | Executa testes |
| `npm run package` | Cria pacote VSIX |
| `F5` no VS Code | Abre em modo debug |

## 💡 Como Usar

1. Instale e abra o VS Code
2. Abra uma pasta qualquer
3. No Explorer (barra lateral), clique com botão direito em qualquer arquivo/pasta
4. Veja as 3 novas opções no menu de contexto!

## 🐛 Problemas Comuns

### Linux: "xdg-open não encontrado"

```bash
sudo apt-get install xdg-utils  # Ubuntu/Debian
```

### Comandos não aparecem no menu

1. Recarregue a janela: `Ctrl+Shift+P` → "Reload Window"
2. Verifique se a extensão está ativada

### Erros de compilação

```bash
rm -rf node_modules package-lock.json
npm install
npm run compile
```

## 📚 Documentação Completa

- **[README.md](README.md)** - Documentação completa em inglês
- **[QUICK_START.md](QUICK_START.md)** - Guia rápido
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Guia de desenvolvimento
- **[INSTALL.md](INSTALL.md)** - Guia de instalação detalhado
- **[PROJECT_STRUCTURE.txt](PROJECT_STRUCTURE.txt)** - Estrutura do projeto

## ✅ Checklist de Funcionalidades

- [x] Menu de contexto no Explorer
- [x] Funciona com arquivos e pastas
- [x] Suporte macOS, Windows, Linux
- [x] Caminhos com espaços funcionam
- [x] Links simbólicos funcionam
- [x] Multi-root workspaces
- [x] Mensagens de erro amigáveis
- [x] Testes automatizados
- [x] Documentação completa

## 🎯 Próximos Passos

1. Leia [README.md](README.md) para documentação completa
2. Execute `npm install && npm run watch`
3. Pressione `F5` para testar
4. Execute `npm run package` para criar VSIX

## 📄 Licença

MIT License - Veja [LICENSE](LICENSE)

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit: `git commit -m 'Adiciona nova funcionalidade'`
4. Push: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

---

**Divirta-se desenvolvendo!** 🚀

_Código e documentação principal em inglês conforme solicitado._
