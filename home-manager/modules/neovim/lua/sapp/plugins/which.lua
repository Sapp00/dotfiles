return {
  "which-key.nvim",
  event = "DeferredUIEnter",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
}
