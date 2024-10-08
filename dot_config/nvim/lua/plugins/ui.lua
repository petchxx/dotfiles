return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	-- animations
	-- {
	-- 	"echasnovski/mini.animate",
	-- 	event = "VeryLazy",
	-- 	opts = function(_, opts)
	-- 		opts.scroll = {
	-- 			enable = false,
	-- 		}
	-- 	end,
	-- },

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = "#905aff", guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = colors.base04 }, { " " }, { filename } }
				end,
			})
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			local lazy_status = require("lazy.status") -- to configure lazy pending updates count
			local LazyVim = require("lazyvim.util")

			local colors = {
				primary = "#905aff",
				blue = "#65D1FF",
				green = "#3EFFDC",
				violet = "#FF61EF",
				yellow = "#FFDA7B",
				red = "#FF4A4A",
				fg = "#c3ccdc",
				bg = "#000000",
				inactive_bg = "#2c3043",
			}

			local my_lualine_theme = {
				normal = {
					a = { bg = colors.primary, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				insert = {
					a = { bg = colors.primary, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				visual = {
					a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				command = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
					-- b = { bg = colors.bg, fg = colors.fg },
					-- c = { bg = colors.bg, fg = colors.fg },
					c = { fg = colors.fg },
				},
				inactive = {
					a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
					-- b = { bg = colors.inactive_bg, fg = colors.semilightgray },
					-- c = { bg = colors.inactive_bg, fg = colors.semilightgray },
					c = { fg = colors.fg },
				},
			}

			-- configure lualine with modified theme
			lualine.setup({
				options = {
					theme = my_lualine_theme,
				},
				sections = {
					lualine_c = {
						LazyVim.lualine.pretty_path({
							length = 0,
							relative = "cwd",
							modified_hl = "MatchParen",
							directory_hl = "",
							filename_hl = "Bold",
							modified_sign = "",
							readonly_icon = " 󰌾 ",
							color = { fg = colors.fg },
						}),
					},
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						-- { "encoding" },
						-- { "fileformat" },

						{ "filetype" },
					},
				},
			})
		end,
	},
	-- {
	-- 	"nvim-lualine/lualine.nvim",
	-- 	opts = function(_, opts)
	-- 		local LazyVim = require("lazyvim.util")
	-- 		opts.sections.lualine_c[4] = {
	-- 			LazyVim.lualine.pretty_path({
	-- 				length = 0,
	-- 				relative = "cwd",
	-- 				modified_hl = "MatchParen",
	-- 				directory_hl = "",
	-- 				filename_hl = "Bold",
	-- 				modified_sign = "",
	-- 				readonly_icon = " 󰌾 ",
	-- 			}),
	-- 		}
	-- 	end,
	-- },

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},

	{
		"nvimdev/dashboard-nvim",
		-- enable = false,
		event = "VimEnter",
		opts = function(_, opts)
			vim.api.nvim_command("highlight DashboardHeader guifg=#905aff gui=bold")
			vim.api.nvim_command("highlight DashboardFooter guifg=#905aff gui=italic")
			local logo = [[
██████╗ ███████╗████████╗ ██████╗██╗  ██╗██╗  ██╗
██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║  ██║╚██╗██╔╝
██████╔╝█████╗     ██║   ██║     ███████║ ╚███╔╝ 
██╔═══╝ ██╔══╝     ██║   ██║     ██╔══██║ ██╔██╗ 
██║     ███████╗   ██║   ╚██████╗██║  ██║██╔╝ ██╗
╚═╝     ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝
		    ]]

			logo = string.rep("\n", 8) .. logo .. "\n\n"
			opts.config.header = vim.split(logo, "\n")
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{
				"<leader>gg",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},

		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{ "neo-tree.nvim", enabled = false },

	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

					-- custom mappings
					vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
					vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
				end,
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					-- width = 30,
					adaptive_size = true,
					relativenumber = true,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
					custom = {
						"node_modules/.*",
					},
				},
				log = {
					enable = true,
					truncate = true,
					types = {
						diagnostics = true,
						git = true,
						profile = true,
						watcher = true,
					},
				},
			})

			-- if vim.fn.argc(-1) == 0 then
			-- 	vim.cmd("NvimTreeFocus")
			-- end
		end,
	},
}
