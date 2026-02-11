local file_path = "/root/.config/nvim/lua/temp/clipboard.txt"
local image_path = "/root/.config/nvim/lua/temp/image.png"
local last_mtime = vim.fn.getftime(file_path)
local running = false
vim.fn.setreg("a", "")

local function download_and_save_image(url, name)
  local extension = url:match("^.+%.(.+)$")
  local filename = vim.fn.expand("%:t"):match("^(.-)%.%w+$"):gsub(" ", "_")
      .. "_"
      .. name:gsub(" ", "_")
      .. "."
      .. extension
  local folder = "./img/"
  vim.fn.mkdir(folder, "p")
  local handle = io.popen("curl -s -o '" .. folder .. filename .. "' " .. url)
  handle:close()
  return folder .. filename
end

local function save_image(name)
  local filename = vim.fn.expand("%:t"):match("^(.-)%.%w+$"):gsub(" ", "_") .. "_" .. name:gsub(" ", "_") .. ".png"
  local folder = "./img/"
  vim.fn.mkdir(folder, "p")
  local handle = io.popen("cp '" .. image_path .. "' '" .. folder .. filename .. "'")
  handle:close()
  return folder .. filename
end

local function encode_characters(html)
  local in_string = false
  local cleaned_html = ""

  for i = 1, #html do
    local char = html:sub(i, i)

    if char == '"' then
      in_string = not in_string -- toggle in_string flag when encountering double quotes
    end

    if not in_string then
      cleaned_html = cleaned_html .. char -- append character to cleaned_html
    else
      if char == "<" then
        char = "&lt;"                     -- replace '<' with HTML entity
      elseif char == ">" then
        char = "&gt;"                     -- replace '>' with HTML entity
      end
      cleaned_html = cleaned_html .. char -- append character to cleaned_html
    end
  end
  return cleaned_html
end

local function remove_html_tags(html)
  html = encode_characters(html)
  print(html)
  -- Remove all HTML tags except for <a> tags
  local cleaned_html = string.gsub(html, "<([^>]+)>", function(match)
    if string.match(match, "^img%s") then
      local url = string.gsub(match, ".*src=([\"'])(.-)%1.*", "%2")
      local name, count = string.gsub(match, "img[^>]*alt=[\"'](.-)[\"'][^>]*", "%1")
      if count == 0 then
        name = url:gsub("$/", "")
        name = name:match(".+/(.-)%.%w+$")
      end
      local filelocation = download_and_save_image(url, name)
      return "\n![" .. name .. "](" .. filelocation .. ")\n"
    elseif string.match(match, "^a%s") then
      -- Converts a href="url" into (url)[
      return string.gsub(match, "a%s+href=[\"'](.-)[\"'][^>]*", " (%1)[")
    elseif string.match(match, "^/a%s*") then
      -- Adds the ] after the content of a <a> tag
      return "] "
    elseif string.match(match, "/?code%s*") then
      return "`"
    elseif string.match(match, "^local%-image") then
      local name = vim.fn.input("What is the image name? ")
      local filelocation = save_image(name)
      return "\n![" .. name .. "](" .. filelocation .. ")\n"
    elseif string.match(match, "^h[1-6]%s*") then
      local header_level = string.match(match, "^h([1-6])%s*")
      return "\n" .. string.rep("#", tonumber(header_level) - 1) .. " "
    elseif string.match(match, "^/h[1-6]%s*") then
      return "\n\n"
    elseif string.match(match, "^/p%s*") then
      return "\n"
    else
      return "" -- Remove other tags
    end
  end)

  -- Decode HTML entities (optional)
  cleaned_html = cleaned_html:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&amp;", "&")

  -- Remove unnecessary spaces
  -- cleaned_html = cleaned_html:gsub("%s+", " ")
  return cleaned_html
end

local function switch_url_with_text(input)
  -- Converts (a)[b] to [b](a):
  local correct_format = string.gsub(input, "%((.-?)%)%s*%[(.-?)%]", "[%2](%1)")
  return correct_format
end

local function read_file()
  local file, err = io.open(file_path, "r")
  if err then
    print("Error opening file: " .. err)
    return ""
  end

  local file_conent = file:read("*a")
  file:close()
  return file_conent
end

local function paste_markdown_url()
  local filetype = vim.bo.filetype
  if
      vim.fn.getreg("a") == ""
      and (filetype == "markdown" or filetype == "mkd" or filetype == "md" or filetype == "vimwiki")
  then
    local clipboard_content = ""
    if vim.fn.executable("xclip") == 1 then
      clipboard_content = vim.fn.system("xclip -o -selection clipboard -t text/html")
    else
      clipboard_content = vim.fn.input("What is the string to paste?")
    end
    if clipboard_content ~= "" then
      vim.fn.setreg("a", switch_url_with_text(remove_html_tags(clipboard_content)))
    else
      print("Clipboard does not contain a valid URL")
    end
  end
  vim.cmd('normal! "aP')
  vim.fn.setreg("a", "")
end

vim.keymap.set("n", "<leader>mp", paste_markdown_url, { noremap = true, silent = false })

local function test()
  paste_markdown_url()
end

local function create_empty_file()
  io.open(file_path, "w"):close()
end

function CheckFileChage()
  if running then
    return
  end
  running = true
  if vim.fn.filereadable(file_path) == 1 then
    local current_mtime = vim.fn.getftime(file_path)

    if current_mtime ~= last_mtime then
      local clipboard_content = read_file()

      print(clipboard_content)

      if clipboard_content == "" then
        return
      end

      print(clipboard_content)
      vim.fn.setreg("a", switch_url_with_text(remove_html_tags(clipboard_content)))
      create_empty_file()
      last_mtime = vim.fn.getftime(file_path)
    end
  end
  running = false
end

local timer = vim.loop.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(CheckFileChage))
