return {
  "nixd",
  enabled = true,
  after = function(_)
    vim.api.nvim_create_user_command("StartNilLSP", function()
      vim.lsp.start(vim.lsp.config.nil_ls)
    end, { desc = 'Run nil-ls (when you really need docs for the builtins and nixd refuse)' })
  end,
  lsp = {
    filetypes = { 'nix' },
    settings = {
      nixd = {
        formatting = {
          command = { "nixfmt" }
        },
        diagnostic = {
          suppress = {
            "sema-escaping-with"
          }
        }
      }
    }
  }
}
