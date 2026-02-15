return {
	{ -- Highlight TODO, HACK, WARN, FIX, NOTE etc. in comments and provide ]t/[t navigation
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
