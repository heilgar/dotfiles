#!/bin/zsh

echo "🔍 Validating language servers..."

for bin in \
    lua-language-server \
    terraform-ls \
    clangd \
    ruff \
    pyright-langserver \
    docker-langserver \
    yaml-language-server \
    typescript-language-server \
    tsc \
    tsserver; do

    if command -v $bin &>/dev/null; then
        echo "✅ $bin found: $(command -v $bin)"
    else
        echo "❌ $bin NOT FOUND in PATH"
    fi
done

