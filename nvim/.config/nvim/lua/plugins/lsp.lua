-- LSP and tooling management
return {
  -- Ensure dev tools via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      local tools = {
        -- JS/TS/React
        "typescript-language-server",
        "prettierd",
        "tailwindcss-language-server",
        "css-lsp",
        "html-lsp",
        -- Angular
        "angular-language-server",
        -- Python
        "basedpyright",
        "ruff",
        "black",
        -- JS/TS debugging
        "js-debug-adapter",
        -- Containers / YAML / JSON
        "dockerfile-language-server",
        "docker-compose-language-service",
        "yaml-language-server",
        "json-lsp",
        -- Shell & docs
        "bash-language-server",
        "shellcheck",
        "shfmt",
        "marksman",
        "taplo",
      }
      vim.list_extend(opts.ensure_installed, tools)
      return opts
    end,
  },

  -- LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {},
        eslint = {},
        angularls = {},
        basedpyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
              },
            },
          },
        },
        dockerls = {},
        yamlls = {},
        jsonls = {},
      },
    },
  },
}
