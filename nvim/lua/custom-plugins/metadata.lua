local metadata = [[
# ---
# type: %s
# title: %s
# tags:
# ---

]]

buf_enter_triggered = false

local function get_yaml_type(callback)
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.sorters")
	local finders = require("telescope.finders")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	pickers
		.new({}, {
			prompt_title = "Question",
			finder = finders.new_table({
				results = { "ansible", "terraform", "docker" },
			}),
			sorter = sorters.get_generic_fuzzy_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				map("n", "<esc>", function()
					actions.close(prompt_bufnr)
					buf_enter_triggered = false
				end)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					callback(selection.value)
					buf_enter_triggered = false
				end)
				return true
			end,
		})
		:find()
end

local function get_filetype()
	local filetype = vim.bo.filetype
	if filetype == "vimwiki" then
		filetype = "md"
		return filetype
	end
end

local function needs_metadata()
	return vim.fn.getline(1) ~= "---"
end

local function strip(str)
	return str:gsub("%s+$", "")
end

local function get_title()
	return strip(vim.fn.getreg('"'))
end

local function write_metadata(str)
	vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(str, "\n"))
end

local function change_cursor_position(x, y)
	vim.api.nvim_win_set_cursor(0, { x, y })
end

local function enter_insert_mode()
	vim.cmd("startinsert")
end

local function set_tab_target()
	vim.keymap.set("i", "<Tab><Tab>", function()
		change_cursor_position(6, 1)
		vim.api.nvim_del_keymap("i", "<Tab><Tab>")
	end, { noremap = true, silent = true })
end

local function insert_metadata(metadata_string)
	write_metadata(metadata_string)
	local tag_line, tag_length = 4, ("tag:  "):len()
	change_cursor_position(tag_line, tag_length)
	enter_insert_mode()
	set_tab_target()
end

local function check_metadata()
	if buf_enter_triggered == true then
		return
	end
	buf_enter_triggered = true
	if needs_metadata() then
		local filetype = get_filetype()
		if filetype == "md" then
			insert_metadata(string.format(metadata, filetype, get_title()))
		else
			get_yaml_type(function(type)
				insert_metadata(string.format(metadata, type, get_title()))
			end)
		end
	else
		buf_enter_triggered = false
	end
end

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = { "*.md", "*.yml", "*.yaml" },
--   callback = check_metadata
-- })
