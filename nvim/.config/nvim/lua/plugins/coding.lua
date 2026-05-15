-- Coding-related plugins: completion, formatting, etc.
return {
  -- Formatters via conform.nvim
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts = opts or {}

      local prettier = { "prettierd", "prettier" }

      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        vue = prettier,
        svelte = prettier,
        css = prettier,
        scss = prettier,
        less = prettier,
        html = prettier,
        json = prettier,
        jsonc = prettier,
        markdown = prettier,
        ["markdown.mdx"] = prettier,
        yaml = prettier,
        python = { "black" },
      })

      return opts
    end,
  },
}
