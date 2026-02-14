return {
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    lazy = false,
    config = function()
      require "sapp.lsp"
    end
  },
  "hrsh7th/nvim-cmp",
  'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
  'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp,
  'L3MON4D3/LuaSnip', -- Snippets plugin
}
