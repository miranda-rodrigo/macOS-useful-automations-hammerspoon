#!/bin/bash
###############################################################################
# COMANDO MÁGICO - COPIA TUDO AUTOMATICAMENTE
# Execute: bash COMANDO_MAGICO.sh
###############################################################################

TARGET="$HOME/useful-repos/cursor-vscode-utils"
SOURCE="/workspace"

# Se não estiver em /workspace, usa diretório atual
[ ! -d "$SOURCE" ] && SOURCE="$(pwd)"

echo "🔮 COMANDO MÁGICO - Copiando tudo automaticamente..."
echo ""
echo "📂 Origem: $SOURCE"
echo "📂 Destino: $TARGET"
echo ""

# Criar diretório
mkdir -p "$TARGET" 2>/dev/null || sudo mkdir -p "$TARGET"

# Copiar TUDO de uma vez
(cd "$SOURCE" && tar cf - src .vscode media *.json *.md *.txt *.sh LICENSE .eslintrc* .gitignore .vscodeignore .editorconfig .npmrc 2>/dev/null) | (cd "$TARGET" && tar xf -)

echo "✅ PRONTO! Todos os arquivos foram copiados!"
echo ""
echo "📊 Arquivos no destino:"
ls -1 "$TARGET" | head -20
echo ""
echo "🚀 Próximos passos:"
echo "   cd $TARGET"
echo "   npm install && npm run compile"
echo "   code ."
echo ""
echo "🎉 Divirta-se!"
