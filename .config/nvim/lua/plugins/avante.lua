return {
  {
    'yetone/avante.nvim',
    build = 'make',
    event = 'VeryLazy',
    version = false, -- track main; avante ships frequently and pins break new providers
    opts = {
      provider = 'claude',
      auto_suggestions_provider = 'claude',
      providers = {
        claude = {
          endpoint = 'https://api.anthropic.com',
          model = 'claude-sonnet-5',
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 8192,
          },
        },
        copilot = {
          model = 'gpt-5',
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
