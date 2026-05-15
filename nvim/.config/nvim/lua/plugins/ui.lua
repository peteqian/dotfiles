-- UI plugins: statusline, bufferline, winbar, UX tweaks
return {
  -- Winbar filenames via incline
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("incline").setup({
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = { cursorline = true },
        render = function(props)
          local buf = props.buf
          local name = vim.api.nvim_buf_get_name(buf)
          local filename = vim.fn.fnamemodify(name, ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          if vim.bo[buf].modified then
            filename = "[+] " .. filename
          end
          local icon = require("nvim-web-devicons").get_icon(filename, nil, { default = true }) or ""
          return { { icon }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- Lualine: refine path display
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}
      local pretty = LazyVim.lualine.pretty_path({
        length = 0,
        relative = "cwd",
        modified_hl = "MatchParen",
        directory_hl = "",
        filename_hl = "Bold",
        modified_sign = "",
        readonly_icon = " 󰌾 ",
      })
      if #opts.sections.lualine_c >= 3 then
        opts.sections.lualine_c[4] = pretty
      else
        table.insert(opts.sections.lualine_c, pretty)
      end
      return opts
    end,
  },

  -- Bufferline with cycling keymaps
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = {
      "BufferLineCycleNext",
      "BufferLineCyclePrev",
      "BufferLinePick",
      "BufferLineCloseLeft",
      "BufferLineCloseRight",
      "BufferLineCloseOthers",
    },
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon = true,
      },
    },
  },

  -- Snacks: disable animated scrolling
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}
      -- Keep animated scrolling disabled
      opts.scroll = vim.tbl_deep_extend("force", opts.scroll or {}, { enabled = false })

      -- Explorer module setup
      opts.explorer = opts.explorer or {}

      -- Configure explorer picker to show hidden and gitignored files by default
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer or {}, {
        hidden = true, -- show dotfiles
        ignored = true, -- show files ignored by .gitignore
      })

      return opts
    end,
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
    },
  },
}
