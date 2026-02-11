return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
      vim.keymap.set('n', '<C-p>', builtin.git_files, {})
      vim.keymap.set('n', '<leader>co', '<cmd>Telescope lsp_document_symbols<CR>', {})
      vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
      end)
      vim.keymap.set('n', '<leader>pt', function()
        builtin.grep_string({
          search = 'tags: [^,]*' .. vim.fn.input("Grep > ") .. '[^,]*',
          --additional_args = function()
          --  return { '--multiline', '--multiline-dotall', '--glob', '*.{md,yaml,yml}' }
          --end
        })
      end)
      builtin.log_level = vim.log.levels.DEBUG
    end
  },
 -- {
 --   'nvim-telescope/telescope-ui-select.nvim',
 --   config = function()
 --     require("telescope").setup {
 --       extensions = {
 --         ["ui-select"] = {
 --           require("telescope.themes").get_dropdown {
 --           }
 --         }
 --       }
 --     }
 --     require("telescope").load_extension("ui-select")
 --   end
 -- }
}
