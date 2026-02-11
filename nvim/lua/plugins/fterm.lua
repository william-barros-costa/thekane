return {
  "numToStr/FTerm.nvim",
  config = function()
    vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>')
    vim.keymap.set('t', '<leader><C-t>', '<CMD>lua require("FTerm").toggle()<CR>')
  end
}
