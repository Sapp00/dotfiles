return {
  {
    "marksman",
    for_cat = "markdown",
    lsp = {
      filetypes = { "markdown", "markdown.mdx" },
    },
  },
  {
    "harper_ls",
    for_cat = "markdown",
    lsp = {
      filetypes = { "markdown", "norg" },
      settings = {
        ["harper-ls"] = {},
      },
    },
  },
}
