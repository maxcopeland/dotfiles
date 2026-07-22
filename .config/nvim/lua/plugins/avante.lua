return {
  {
    'yetone/avante.nvim',
    build = 'make',
    -- Load only on explicit invocation, not eagerly at startup: both
    -- configured providers are currently broken upstream (Claude's
    -- auth_type = "max" hits an unresolved 429 on token exchange; Copilot's
    -- auth check fails outright since copilot.lua now stores its token in
    -- an encrypted auth.db that avante's provider can't read, see
    -- github.com/yetone/avante.nvim/issues/3121). `setup()` validates the
    -- default provider's auth immediately, so loading this eagerly (e.g.
    -- via `event = "VeryLazy"`) throws an error on every single startup.
    -- Staying dormant until called avoids that; Claude Code CLI
    -- (<leader>tc) and copilot.vim's inline completions are the working
    -- path in the meantime.
    cmd = {
      'AvanteAsk',
      'AvanteChat',
      'AvanteChatNew',
      'AvanteToggle',
      'AvanteBuild',
      'AvanteEdit',
      'AvanteRefresh',
      'AvanteFocus',
      'AvanteSwitchProvider',
      'AvanteSwitchSelectorProvider',
      'AvanteSwitchInputProvider',
      'AvanteClear',
      'AvanteShowRepoMap',
      'AvanteModels',
      'AvanteACPModels',
      'AvanteACPModes',
      'AvanteHistory',
      'AvanteStop',
    },
    keys = {
      '<leader>aa',
      '<leader>an',
      '<leader>az',
      '<leader>ae',
      '<leader>ar',
      '<leader>af',
      '<leader>aS',
      '<leader>at',
      '<leader>ad',
      '<leader>aC',
      '<leader>as',
      '<leader>aR',
      '<leader>ac',
      '<leader>aB',
      '<leader>a?',
      '<leader>ah',
      '<leader>aM',
      '<leader>am',
    },
    version = false, -- track main; avante ships frequently and pins break new providers
    opts = {
      -- Copilot is the default: Claude's auth_type = "max" OAuth (below) hits
      -- an unresolved upstream 429 on token exchange for third-party tools
      -- (github.com/yetone/avante.nvim, github.com/anomalyco/opencode#18329).
      -- Claude work happens in the Claude Code CLI instead (<leader>tc).
      -- The claude provider is left configured so `:AvanteSwitchProvider
      -- claude` can be retried later if/when that upstream issue clears.
      provider = 'copilot',
      auto_suggestions_provider = 'copilot',
      providers = {
        claude = {
          endpoint = 'https://api.anthropic.com',
          model = 'claude-sonnet-5',
          auth_type = 'max',
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 8192,
          },
        },
        copilot = {
          -- No model override: available Copilot models depend on your plan
          -- and change over time. Use `<leader>a?` (:AvanteModels) to pick
          -- one interactively; browser device-flow auth is handled by
          -- copilot.lua's own `:Copilot auth`, same as Claude's auth_type = "max".
        },
      },
      behaviour = {
        -- Review each tool call before Avante edits files or runs shell
        -- commands, rather than letting it act unattended.
        auto_approve_tool_permissions = false,
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        -- Only used so Avante's `copilot` provider can authenticate;
        -- copilot.vim (see github_copilot.lua) still owns inline ghost-text
        -- completion, so this instance's own suggestion UI stays off to
        -- avoid duplicate completions.
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
        },
      },
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = { file_types = { 'markdown', 'Avante' } },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
