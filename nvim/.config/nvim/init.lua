vim.g.mapleader = " "
vim.g.astro_typescript = "enable"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true

vim.filetype.add({ extension = { astro = "astro" } })
vim.diagnostic.config({ severity_sort = true, virtual_text = true })

local function project_root(buf)
  local file = vim.api.nvim_buf_get_name(buf)
  local marker = vim.fs.find({ "astro.config.mjs", "astro.config.js", "astro.config.ts", "package.json", ".git" }, {
    path = file,
    upward = true,
  })[1]
  return marker and vim.fs.dirname(marker) or vim.fn.getcwd()
end

local function on_attach(_, buf)
  local map = function(keys, action)
    vim.keymap.set("n", keys, action, { buffer = buf })
  end

  map("gd", vim.lsp.buf.definition)
  map("gr", vim.lsp.buf.references)
  map("K", vim.lsp.buf.hover)
  map("<leader>rn", vim.lsp.buf.rename)
  map("<leader>ca", vim.lsp.buf.code_action)
  map("<leader>f", function() vim.lsp.buf.format({ async = true }) end)
  map("gl", vim.diagnostic.open_float)
  vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { buffer = buf })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "astro",
  callback = function(args)
    vim.lsp.start({
      name = "astro",
      cmd = { "astro-ls", "--stdio" },
      root_dir = project_root(args.buf),
      init_options = {
        typescript = { tsdk = vim.fn.systemlist({ "npm", "root", "-g" })[1] .. "/typescript/lib" },
      },
      on_attach = on_attach,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function(args)
    vim.lsp.start({
      name = "typescript",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = project_root(args.buf),
      on_attach = on_attach,
    })
  end,
})
