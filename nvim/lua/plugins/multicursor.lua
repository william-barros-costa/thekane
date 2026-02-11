return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({ "n", "x" }, "<leader>su", function()
      mc.lineAddCursor(-1)
    end)
    set({ "n", "x" }, "<leader>sj", function()
      mc.lineAddCursor(1)
    end)

    -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<leader>sn", function()
      mc.matchAddCursor(1)
    end)
    set({ "n", "x" }, "<leader>sp", function()
      mc.matchAddCursor(-1)
    end)

    -- Add and remove cursors with control + left click.
    set("n", "<c-leftmouse>", mc.handleMouse)
    set("n", "<c-leftdrag>", mc.handleMouseDrag)
    set("n", "<c-leftrelease>", mc.handleMouseRelease)

    -- Align cursors
    set("n", "<leader>sal", mc.alignCursors)

    -- Select all Matches
    set({ "n", "x" }, "<leader>sa", mc.matchAllAddCursors)

    set({ "n", "x" }, "<esc>", mc.clearCursors)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
