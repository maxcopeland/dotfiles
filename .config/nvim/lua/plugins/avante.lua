return {
  {
    'yetone/avante.nvim',
    build = 'make',
    -- Load only on explicit invocation, not eagerly at startup. The default
    -- provider (copilot-cli, below) is ACP-based and safe to load eagerly
    -- (setup() skips auth validation entirely for ACP providers), but the
    -- REST-based `claude` provider (auth_type = "max") still hits an
    -- unresolved 429 on token exchange if ever selected via
    -- :AvanteSwitchProvider, so staying cmd/keys-lazy avoids any surprise at
    -- startup regardless of which provider is active.
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
      -- copilot-cli is the default: avante's REST-based `copilot` provider
      -- (below) reads its OAuth token from copilot.lua's legacy
      -- hosts.json/apps.json files, but copilot.lua now stores auth in an
      -- encrypted auth.db instead (github.com/yetone/avante.nvim/issues/3121,
      -- unresolved). The GitHub Copilot CLI (`copilot`, installed via
      -- `npm i -g @github/copilot`) natively supports `--acp` (Agent Client
      -- Protocol), so avante can drive it as a subprocess instead of reading
      -- its token directly -- same trick avante's own default config already
      -- uses for the `claude-code` ACP entry. This sidesteps the auth.db
      -- issue entirely and reuses whatever session `copilot` is already
      -- logged into (`<leader>tg` then `/login` if needed).
      --
      -- Claude's auth_type = "max" OAuth hits a separate unresolved upstream
      -- 429 on token exchange for third-party tools (avante's own issue
      -- tracker, github.com/anomalyco/opencode#18329); Claude work happens in
      -- the Claude Code CLI instead (<leader>tc). Both the claude and
      -- REST-based copilot providers are left configured so either path can
      -- be retried via `:AvanteSwitchProvider` if/when those upstream issues
      -- clear.
      provider = 'copilot-cli',
      acp_providers = {
        ['copilot-cli'] = {
          command = 'copilot',
          args = { '--acp' },
        },
      },
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
