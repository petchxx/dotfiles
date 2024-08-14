return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- tag = "v0.9.1",
		opts = {
			autotag = { enable = true },
			ensure_installed = {
				"javascript",
				"typescript",
				"css",
				"gitignore",
				"graphql",
				"http",
				"json",
				"scss",
				"sql",
				"vim",
				"lua",
				"tsx",
				"html",
			},
			-- ignore_install = { "xml", "printf" },
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
		},
	},
}
