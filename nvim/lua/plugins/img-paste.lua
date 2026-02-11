return {
  'img-paste-devs/img-paste.vim',
  config = function()
    vim.api.nvim_exec([[
  autocmd FileType markdown nmap <buffer><silent> <leader>pp :call mdip#MarkdownClipboardImage()<CR>
]], false)

    -- Set default values for image directory and image name
    vim.g.mdip_imgdir = 'img'
    vim.g.mdip_imgname = 'image'
  end
}
