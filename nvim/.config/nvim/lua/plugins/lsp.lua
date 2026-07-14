return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Keep TypeScript on one server. Multiple TS LSP clients can race and make
      -- definition requests look broken or inconsistent.
      opts.servers.tsgo = opts.servers.tsgo or {}
      opts.servers.tsgo.enabled = true

      for _, server in ipairs({ "vtsls", "ts_ls", "tsserver" }) do
        opts.servers[server] = opts.servers[server] or {}
        opts.servers[server].enabled = false
      end
    end,
  },
}
