return {
  'vimwiki/vimwiki',
  config = function()
--    vim.api.nvim_set_keymap('i', '<Tab>', '<Nop>', { noremap = true })
  end
}

-- To change it so links are [test](<./test.md>) we have to do two things:
-- add vim.g.vimwiki_markdown_link_ext = 1 to our vim-options.lua or init.lua file
-- Change /root/.local/share/nvim/lazy/vimwiki/autoload/vimwiki/base.vim: 
-- Change function vimwiki#base#normalize_link_helper by:
-- - Adding `let url = '<./' . url` before "safesubstitutes"
-- - Changing "let file_extension = ....)" to "let file_extensions = ....) . '>'"
-- Change function 
-- - Changing "let link = (..., visual_selection, ...)" to "let link = (..., '<./' . visual_selection, ...)" 
-- - Changing "let file_extension = ....)" to "let file_extensions = ....) . '>'"
