return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- CSS, SCSS, Less support via vscode-langservers-extracted
      cssls = {},
      -- Biome: linting + type-checking diagnostics (formatting handled by conform)
      biome = {},
    },
  },
}
