return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
  --  tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim"
    },
    config = function()
      local telescope = require('telescope')

        telescope.setup({})
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("projects")

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = 'Search file'})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {desc = 'Search git files'})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, {desc = 'Search for current word in files'})
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, {desc = ''})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, {desc = 'Search with grep'})
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = 'Search in NVim documentation' })
    end
  },
  --[[
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true
        }
      })
    end,
  }
  ]]--
}
