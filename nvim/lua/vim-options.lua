vim.cmd("set expandtab") 
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set clipboard^=unnamed,unnamedplus")
vim.cmd("set number relativenumber")
vim.g.mapleader = " "
vim.g.tmux_navigator_no_mappings = 1

-- Saves when Leaving insert
vim.api.nvim_command([[autocmd InsertLeave * :silent! wa]])


-- Global configurations
vim.g.vimwiki_markdown_link_ext = 1

-- Helper functions
local function extract_tag(key)
  local tagName = key:match('<%s*(%a+)')
  if tagName then
    return '</' .. tagName .. '>'
  end
  return key
end

local function getEndKey(key)
  return ({
    ["["] = "]",
    ["{"] = "}",
    ["("] = ")",
  })[key] or extract_tag(key) 
end
 

function SurroundSelection()
  local key = vim.fn.input('Insert surround: ')
  local endKey = getEndKey(key)
  local command = "di" .. key .. "<Esc>pa" .. endKey .. "<Esc>"
  local clean_command = vim.api.nvim_replace_termcodes(command, true, true, true)
  vim.fn.feedkeys(clean_command)
end

-- Visual Mode
vim.keymap.set("v", "<leader>s", SurroundSelection, { noremap = true })
