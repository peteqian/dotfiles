-- Editor-focused plugins: files, search, VCS helpers, etc.
return {
  -- Disable Neo-tree entirely; use Snacks Explorer instead
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- Telescope: include hidden files, respect .gitignore
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      opts.pickers = opts.pickers or {}

      opts.pickers.find_files = vim.tbl_extend("force", opts.pickers.find_files or {}, {
        hidden = true,
        no_ignore = false,
      })

      opts.pickers.live_grep = vim.tbl_extend("force", opts.pickers.live_grep or {}, {
        additional_args = function()
          return { "--hidden" }
        end,
      })

      return opts
    end,
  },

  -- Gitsigns: inline blame and toggle
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.current_line_blame = true
      opts.current_line_blame_opts = vim.tbl_deep_extend("force", opts.current_line_blame_opts or {}, {
        delay = 300,
        virt_text = true,
        virt_text_pos = "eol",
        ignore_whitespace = false,
      })
      opts.current_line_blame_formatter = opts.current_line_blame_formatter
        or "<author_time:%Y-%m-%d> • <author> • <summary>"
      return opts
    end,
    keys = {
      {
        "<leader>ub",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle Git Blame (inline)",
      },
    },
  },
}
