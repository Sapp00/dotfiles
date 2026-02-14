local maps = require("sapp.lsp.mapping")

vim.g.rustaceanvim = {
    tools = {
      autoSetHints = true,
      inlay_hints = {
        show_parameter_hints = true,
        parameter_hints_prefix = "in: ", -- "<- "
        other_hints_prefix = "out: " -- "=> "
      }
    },
    -- LSP configuration
    server = {
      on_attach = function(client, bufnr)
        print("hiiiii")
        maps.mappings(client, bufnr)

--       require("lsp-inlayhints").setup({
 --         inlay_hints = { type_hints = { prefix = "=> " } }
 --       })
--        require("lsp-inlayhints").on_attach(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true)
        end
        --require("illuminate").on_attach(client)

        local bufopts = {
          noremap = true,
          silent = true,
          buffer = bufnr
        }

        vim.keymap.set('n', '<leader><leader>rr',
          "<Cmd>RustLsp runnables<CR>", bufopts)
        vim.keymap.set("n", "K",
          "<Cmd>RustLsp hover actions<CR>", bufopts)
        -- other settings. -- 
        --vim.diagnostic.config({
        --  virtual_text = true,
        --  signs = true,
        --  update_in_insert = true
        --})
      end,
      default_settings = {
        ['rust-analyzer'] = {
          assist = {
            importEnforceGranularity = true,
            importPrefix = "create"
          },
          cargo = { allFeatures = true },
          checkOnSave = {
            -- default
            command = "clippy",
            allFeatures = true
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = true,
              useParameterNames = true
            },
            locationLinks = false
          },
          diagnostics = {
            enable = true,
            experimental = {
              enable = true
            }
          }
        }
      }
    }
}
