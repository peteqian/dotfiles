vim.filetype.add({
  extension = {
    html = function(_, bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then
        return nil
      end

      local root = vim.fs.root(name, { "angular.json" })
      if not root then
        return nil
      end

      return "htmlangular"
    end,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "htmlangular",
  callback = function(args)
    vim.bo[args.buf].indentexpr = vim.filetype.get_option("html", "indentexpr")
    vim.treesitter.start(args.buf, "angular")
  end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})
