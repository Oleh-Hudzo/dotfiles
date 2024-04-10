return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"lua_ls",
					"hydra_lsp",
					"html",
					"tflint",
					"cssls",
					"tsserver",
					"jdtls",
					"pyright",
					"golangci_lint_ls",
					"jsonls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.bashls.setup({
				capabilies = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilies = capabilities,
			})
			lspconfig.hydra_lsp.setup({
				capabilies = capabilities,
			})
			lspconfig.html.setup({
				capabilies = capabilities,
			})
			lspconfig.tflint.setup({
				capabilies = capabilities,
			})
			lspconfig.cssls.setup({
				capabilies = capabilities,
			})
			lspconfig.tsserver.setup({
				capabilies = capabilities,
			})
			lspconfig.jdtls.setup({
				capabilies = capabilities,
			})
			lspconfig.pyright.setup({
				capabilies = capabilities,
			})
			lspconfig.golangci_lint_ls.setup({
				capabilies = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilies = capabilities,
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
