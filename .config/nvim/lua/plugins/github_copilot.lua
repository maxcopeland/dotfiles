return {
  'github/copilot.vim',
  keys = {
    {
      '<leader>tC',
      function()
        -- :Copilot enable/disable just flips a flag copilot#Enabled() checks
        -- before offering a suggestion - the background language server
        -- keeps running either way, so this doesn't lose auth or restart
        -- anything (unlike :Copilot restart, which does).
        if vim.g.copilot_enabled == 0 then
          vim.cmd 'Copilot enable'
        else
          vim.cmd 'Copilot disable'
        end
      end,
      desc = 'Toggle [C]opilot suggestions',
    },
  },
}
