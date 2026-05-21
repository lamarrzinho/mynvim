vim.o.number = true 
vim.o.tabstop = 2 
vim.o.shiftwidth = 2 
vim.o.smartcase = true 
vim.o.ignorecase = true 
vim.o.wrap = false 
vim.o.hlsearch = false 
vim.o.signcolumn = 'yes' 

vim.g.mapleader = vim.keycode('<Space>') 

local function bootstrap_pckr() 
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim" 

  if not (vim.uv or vim.loop).fs_stat(pckr_path) then 
    vim.fn.system({ 
      'git', 
      'clone', 
      "--filter=blob:none", 
      'https://github.com/lewis6991/pckr.nvim', 
      pckr_path 
    }) 
  end 

  vim.opt.rtp:prepend(pckr_path) 
end 

bootstrap_pckr() 

require('pckr').add{ 
  'neovim/nvim-lspconfig'; 
  'nvim-mini/mini.nvim'; 
  'vague-theme/vague.nvim'; 

  -- Dependências do Neo-tree 
  'nvim-lua/plenary.nvim'; 
  'nvim-tree/nvim-web-devicons'; 
  'MunifTanjim/nui.nvim'; 
  -- O próprio Neo-tree 
  'nvim-neo-tree/neo-tree.nvim'; 

  -- Adiciona 'end' automaticamente (perfeito para Ruby e Lua) 
  'tpope/vim-endwise'; 

  -- Plugins para suporte ao Svelte e realce de sintaxe 
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }; 
  'evanleck/vim-svelte'; 
} 

require("vague").setup({}) 

vim.cmd.colorscheme('vague') 

require('mini.snippets').setup({}) 
require('mini.completion').setup({}) 
require('mini.pairs').setup({}) 

-- Substituindo o mini.files pelo neo-tree 
require('neo-tree').setup({ 
  close_if_last_window = true, -- Fecha o Neovim se o neo-tree for a última janela aberta 
}) 
-- Mapeamento atualizado para o Neotree 
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', {desc = 'File explorer'}) 

require('mini.pick').setup({}) 
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'}) 
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'}) 
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', {desc = 'Search help tags'}) 

-- Configuração do Treesitter protegida por pcall
local ts_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if ts_ok then
  treesitter.setup({ 
    -- Lista alinhada com os LSPs habilitados abaixo
    ensure_installed = { "svelte", "javascript", "php", "ruby", "css", "html", "lua" }, 
    highlight = { 
      enable = true, 
    }, 
  })
end

-- LSPs habilitados: Ruby, PHP e Svelte 
vim.lsp.enable({'ruby_lsp', 'intelephense', 'svelte'})
