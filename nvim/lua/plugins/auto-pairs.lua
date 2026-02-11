return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = function ()
    require("nvim-autopairs").setup({
      enable_check_bracket_line = true, -- Don't add pairs if a closing pair exists,
      enable_moveright = true, -- Allows us to move after parenthesis when closing bracket
      enable_afterquote = true -- Add bracket after quotes " or '
    })

    -- Adds '('  after auto complete
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end
}
