return {
  -- Create annotations with one keybind, and jump your cursor in the inserted annotation
	{
		"danymat/neogen",
    dependencies = {
      "L3MON4D3/LuaSnip"
    },
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	}
}
