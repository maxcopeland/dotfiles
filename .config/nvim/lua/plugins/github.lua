-- GitHub operations from within nvim: PRs, issues, reviews, diffs
-- Requires the `gh` CLI installed and authenticated (`gh auth login`)
-- See `:help octo` and `:help diffview` to understand the configuration keys

return {
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Octo',
    opts = {
      use_local_fs = true, -- use local files for editing PR files instead of buffers from GitHub
      enable_builtin = true, -- shows a list of built-in pickers when calling Octo <object> <action>
      default_to_projects_v2 = false,
      picker = 'telescope',
    },
    keys = {
      { '<leader>gp', '<cmd>Octo pr list<CR>', desc = 'git [P]R list' },
      { '<leader>gi', '<cmd>Octo issue list<CR>', desc = 'git [I]ssue list' },
      { '<leader>gc', '<cmd>Octo pr create<CR>', desc = 'git [C]reate PR' },
      { '<leader>gr', '<cmd>Octo review start<CR>', desc = 'git [R]eview start' },
      { '<leader>gm', '<cmd>Octo pr merge<CR>', desc = 'git [M]erge PR' },
    },
  },

  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'git [D]iff view' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'git file [H]istory' },
    },
  },
}
