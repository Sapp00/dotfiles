return {
  {
    "cmake",
    for_cat = "C",
    lsp = {
      filetypes = { "cmake" },
    },
  },
  {
    "clangd",
    for_cat = "C",
    lsp = {
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      -- unneded thanks to clangd_extensions-nvim I think
      -- settings = {
      --   clangd_config = {
      --     init_options = {
      --       compilationDatabasePath="./build",
      --     },
      --   }
      -- }
    },
  },
}
