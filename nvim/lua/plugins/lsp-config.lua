return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-null-ls.nvim",
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local default_tools = {
        --"lua_ls",
        "marksman",
        "lua-language-server",
        "stylua",
        "bash-language-server",
        "marksman",
        "pyright",
        "stylua",
      }
      local env_tools = vim.split(os.getenv("MASON_TOOLS") or "", ",", { trimempty = true })

      local combined_tools = vim.tbl_extend("force", default_tools, env_tools)

      require("mason-tool-installer").setup({
        ensure_installed = combined_tools,
        --        ensure_installed = {
        --          "golangci-lint",
        --          "gopls",
        --          "delve",
        --          "gofumpt",
        --          "gotests",
        --          "gotestsum",
        --          "impl",
        --          "delve",
        --          "goimports-reviser",
        --          "yaml-language-server",
        --        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("lua_ls", { capabilities = capabilities })
      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.config("marksman", { capabilities = capabilities })
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = { gopls = { completeUnimported = true, usePlaceholders = true } },
      })

      local function goto_definition(split_cmd)
        local util = vim.lsp.util
        local log = require("vim.lsp.log")
        local api = vim.api

        -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
        local handler = function(_, result, ctx)
          if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
          end

          if split_cmd then
            vim.cmd(split_cmd)
          end

          if vim.tbl_islist(result) then
            util.jump_to_location(result[1])

            if #result > 1 then
              -- util.set_qflist(util.locations_to_items(result))
              vim.fn.setqflist(util.locations_to_items(result))
              api.nvim_command("copen")
              api.nvim_command("wincmd p")
            end
          else
            util.jump_to_location(result)
          end
        end

        return handler
      end

      vim.lsp.handlers["textDocument/definition"] = goto_definition("split")
    end,
  },
}
