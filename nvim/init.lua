local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) 

local opts = {}

require("vim-options")
require("lazy").setup("plugins")

-- Adding Terraform config
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])
vim.keymap.set("n", "<leader>ti", ":!terraform init<CR>", opts)
vim.keymap.set("n", "<leader>tv", ":!terraform validate<CR>", opts)
vim.keymap.set("n", "<leader>tp", ":!terraform plan<CR>", opts)
vim.keymap.set("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", opts)
