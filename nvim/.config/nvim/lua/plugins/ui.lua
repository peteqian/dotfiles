return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
      },
    },
  },
  -- filename
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
  },

  -- file explorer
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        hidden = true, -- show dotfiles in explorer tree
        ignored = true, -- include ignored files/directories
      },
      picker = {
        hidden = true,
        ignored = true,
        sources = {
          files = {
            hidden = true,
            ignored = true,
            command = function()
              return {
                "--hidden",
                "--no-ignore",
                "--follow",
                "--color never",
                "--strip-cwd-prefix",
              }
            end,
          },
          explorer = {
            hidden = true, -- show dotfiles
            ignored = true, -- show ignored files/directories
          },
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },
  -- render markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },
  -- For `plugins/markview.lua` users.
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- For `nvim-treesitter` users.
    priority = 49,

    -- For blink.cmp's completion
    -- source
    dependencies = {
      "saghen/blink.cmp",
    },
  },
}
