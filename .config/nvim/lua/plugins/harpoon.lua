return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    depends = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon.setup()

      vim.keymap.set('n', '<leader>haa', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<leader>has', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      for i = 1, 4 do
        vim.keymap.set('n', '<leader>' .. i, function()
          harpoon:list():select(i)
        end, { desc = 'Harpoon to file ' .. i })
      end
    end,
  },
}
