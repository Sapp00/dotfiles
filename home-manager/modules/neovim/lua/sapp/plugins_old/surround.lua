return {
    {
        "kylechui/nvim-surround",
        dependencies = {
          "roobert/surround-ui.nvim",
          "folke/which-key.nvim"
        },
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                keymaps = {
                    insert = "<C-g>s",
                    insert_line = "<C-g>S",
                    normal = "ys",
                    normal_cur = "yss",
                    normal_line = "yS",
                    normal_cur_line = "ySS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "ds",
                    change = "cs",
                    change_line = "cS",
                },
            })

          require("surround-ui").setup({
            root_key = "$"
          })
        end
    }
}
