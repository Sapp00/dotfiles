return {
    {
    "echasnovski/mini.files",

    config = function()
      require("mini.files").setup {
        mappings = {
          synchronize = "w",
          go_in_plus="<CR>" },
      }

      local show_dotfiles = true

      local filter_show = function(fs_entry)
        return true
      end

      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local gio_open = function()
        local fs_entry = require("mini.files").get_fs_entry()
        vim.notify(vim.inspect(fs_entry))
        vim.fn.system(string.format("gio open '%s'", fs_entry.path))
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh { content = { filter = new_filter } }
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
          vim.keymap.set("n", "-", require("mini.files").close, { buffer = buf_id })
          vim.keymap.set("n", "o", gio_open, { buffer = buf_id })
        end,
      })
    end,

    lazy = false,
  },
}
