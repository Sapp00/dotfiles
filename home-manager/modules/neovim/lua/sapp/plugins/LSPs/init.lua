-- vim.lsp.config('rust_analyzer', {
--   settings = {
--     ['rust-analyzer'] = {
--       diagnostics = {
--         enable = false;
--       }
--     }
--   }
-- })
--
-- vim.lsp.config('lua_ls', {
--   on_init = function(client)
--     if client.workspace_folders then
--       local path = client.workspace_folders[1].name
--       if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc')) then
--         return
--       end
--     end
--
--     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
--       runtime = {
--         version = 'LuaJIT'
--       },
--       -- Make the server aware of Neovim runtime files
--       workspace = {
--         checkThirdParty = false,
--         library = {
--           vim.env.VIMRUNTIME
--           -- Depending on the usage, you might want to add additional paths here.
--           -- "${3rd}/luv/library"
--           -- "${3rd}/busted/library",
--         }
--         -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
--         -- library = vim.api.nvim_get_runtime_file("", true)
--       }
--     })
--   end,
--   settings = {
--     Lua = {}
--   }
-- })

--vim.lsp.enable('lua_ls')
--vim.lsp.enable('rust_analyzer')
--vim.lsp.enable('nixd')

-- require("sapp.plugins.LSPs.rust")

return {
 {
    "nvim-lspconfig",
    for_cat = "general.core",
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config('*', {
        on_attach = require('sapp.plugins.LSPs.on_attach'),
      })
    end,
  },
  { import = "sapp.plugins.LSPs.c"},
  { import = "sapp.plugins.LSPs.lua", },
  { import = "sapp.plugins.LSPs.markdown", },
  { import = "sapp.plugins.LSPs.nix", },
  { import = "sapp.plugins.LSPs.python", },
  { import = "sapp.plugins.LSPs.web", },
  {
    "gopls",
    for_cat = "go",
    lsp = {
      filetypes = { "go", "gomod", "gowork", "gotmpl", "templ", },
    },
  },
  {
    "bashls",
    for_cat = "bash",
    lsp = {
      filetypes = { "bash", "sh" },
    },
  },
}
