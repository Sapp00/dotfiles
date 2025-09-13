return {
  "lua_ls",
  enabled = true,
  lsp = {
    filetypes = { 'lua' },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        formatters = {
          ignoreComments = true,
        },
        signatureHelp = { enabled = true },
        diagnostics = {
          globals = { "nixCats", "vim", "make_test" },
          disable = { 'missing-fields' },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            -- '${3rd}/luv/library',
            -- unpack(vim.api.nvim_get_runtime_file('', true)),
          },
        },
        completion = {
          callSnippet = 'Replace',
        },
        telemetry = { enabled = false },
      },
    },
  },
}
