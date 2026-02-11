local wk = require("which-key")
local dapui = require("dapui")
local dap = require("dap")

local function toggle_neotree()
	local open = false
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(buf, "filetype") == "neo-tree" then
			open = true
		end
	end

	local neotree_focused = vim.api.nvim_buf_get_option(0, "filetype") == "neo-tree"

	if open and neotree_focused then
		vim.api.nvim_command("Neotree close")
	else
		vim.api.nvim_command("Neotree focus")
	end
end

local function terminate_dap()
	dap.terminate()
	vim.wait(500, function()
		return false
	end, 500)
	dapui.close()
end

local function capitalizeFirstLetter(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end

function navigate(direction)
	local tmux_direction = ({
		["h"] = "left",
		["j"] = "bottom",
		["k"] = "top",
		["l"] = "right",
	})[direction]
	local has_nvim_window_on_direction = vim.fn.winnr(direction) ~= vim.fn.winnr()
	local has_tmux_pane_on_direction = string.find(
		vim.fn.system('tmux display-message -p "#{pane_at_' .. tmux_direction .. '}"'),
		"1"
	) == nil

	if has_nvim_window_on_direction then
		vim.cmd("wincmd " .. direction)
	elseif has_tmux_pane_on_direction then
		local navigation_direction = ({
			["h"] = "Left",
			["j"] = "Down",
			["k"] = "Up",
			["l"] = "Right",
		})[direction]
		vim.cmd("TmuxNavigate" .. navigation_direction)
	else
		vim.cmd(({
			["h"] = "vsplit",
			["j"] = "split",
			["k"] = "split",
			["l"] = "vsplit",
		})[direction])
		vim.cmd("wincmd " .. direction)
	end
end

wk.add({
	{ "<leader>c", group = "LSP" },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
	{ "<leader>cd", vim.lsp.buf.definition, desc = "Definition of Symbol" },
	{ "<leader>cf", vim.lsp.buf.format, desc = "Format" },
	{ "<leader>ci", vim.lsp.buf.hover, desc = "Inspect" },
	{ "<leader>cn", group = "(Diagnostic) Go To" },
	{ "<leader>cnn", vim.diagnostic.goto_next, desc = "(Diagnostic) Next" },
	{ "<leader>cnp", vim.diagnostic.goto_previous, desc = "(Diagnostic) Previous" },
	{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
	{ "<leader>cs", vim.lsp.buf.declaration, desc = "Declaration of symbol" },
	{ "<leader>d", group = "Debug" },
	{ "<leader>dc", dap.continue, desc = "Continue Execution" },
	{ "<leader>dd", dap.clear_breakpoints, desc = "Delete Breakpoints" },
	{ "<leader>dj", dap.down, desc = "Go down" },
	{ "<leader>dk", dap.up, desc = "Go up" },
	{ "<leader>dr", dap.repl.open, desc = "Open repl" },
	{ "<leader>ds", terminate_dap, desc = "Terminate Execution" },
	{ "<leader>dt", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
	{ "<leader>dn", dap.step_over, desc = "Step over" },
	{ "<leader>di", dap.step_into, desc = "Step into" },
	{ "<leader>do", dap.step_out, desc = "Step out" },
	{ "<leader>q", group = "Macros" },
	{ "<leader>qj", "@q<cr>", desc = "Repeats Macro stored on q register" },
	{ "<leader>n", toggle_neotree, desc = "Toggle File Explorer" },
	{
		"<C-h>",
		function()
			navigate("h")
		end,
		desc = "Navigate Left",
		noremap = true,
		silent = true,
	},
	{
		"<C-j>",
		function()
			navigate("j")
		end,
		desc = "Navigate Down",
		noremap = true,
		silent = true,
	},
	{
		"<C-k>",
		function()
			navigate("k")
		end,
		desc = "Navigate Up",
		noremap = true,
		silent = true,
	},
	{
		"<C-l>",
		function()
			navigate("l")
		end,
		desc = "Navigate Right",
		noremap = true,
		silent = true,
	},
})
