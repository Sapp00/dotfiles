return {
	-- tools
	{
    'williamboman/mason.nvim',
    dependencies = {
      {'williamboman/mason-lspconfig.nvim'},
      {'neovim/nvim-lspconfig'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/nvim-cmp'},
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
        local servers = {
          "bashls",
          --"clangd",
          "cssls",
          "dockerls",
          "docker_compose_language_service",
          "eslint",
          "html",
          "jsonls",
          "lua_ls",
          "ltex",
          "gopls",
          "markdown_oxide",
          "openscad_lsp",
          "pylsp",
          --"rust_analyzer",
				  "svelte",
				  "tailwindcss",
  				"terraformls",
          "tflint",
          "tsserver",
		  	  "yamlls",
        }

      require("mason").setup({
        ui = {
          icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
          }
        }
      })
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        handlers = {
          -- if no specific handler matches, use default settings
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                  },
                  diagnostics = {
                    "vim",
                    "require"
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  telemetry = {
                    eneable = false,
                  },
                }
              }
            })
          end,
          -- for rust, do nothing since we configure it in rust-tools/rustace
          ["rust_analyzer"] = function() end,
          ["clangd"] = function()
            require("lspconfig").clangd.setup({})
          end,
        }
      })
    end
	},
  -- Setup DAPs
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-lint",
      "mhartington/formatter.nvim"
    },
    config = function()
      local required = {
        -- DAPs
        'codelldb',
        'python',
        -- Linters
        'shellcheck',
        'shellharden',
        -- Formatters
        'black',
        'clang-format',
        'prettierd',
        'shfmt',
        'stylua'
      }

      require("mason-tool-installer").setup({
        ensure_installed = required,
      })

 --     require("formatter").setup({})

      vim.keymap.set("n", "Db", ":DapContinue<CR>")
      vim.keymap.set("n", "<F5>", ":DapStepOver<CR>")
      vim.keymap.set("n", "<F9>", ":DapNew<CR>")


      -- configure cmp
      require("sapp.lsp.cmp")
    end
  },
  -- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},
  {
      'mrcjkb/rustaceanvim',
      version = '^4',
      lazy = false,
      dependencies = {
        'mfussenegger/nvim-dap',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/nvim-cmp',
      },
      config = function()
        require("sapp.lsp.rustacean")
      end
  }
}
