return {
  "neogen",
  event = "DeferredUIEnter",
  keys = {
    {
      "<leader>cc",
      function()
        require("neogen").generate({})
      end,
      desc = "Neogen Comment",
    },
  },
  after = function()
    require("neogen").setup({
      snippet_engine = "luasnip"
    })
  end,
}
