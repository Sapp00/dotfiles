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
