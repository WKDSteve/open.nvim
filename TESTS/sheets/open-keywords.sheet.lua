-- A built-in keyword whose path lives in the git config: `:Open split gitmessage` runs `git config --global
-- commit.template` (real git, synchronous and memoised) and opens what it names in a split. `GIT_CONFIG_GLOBAL` points
-- git at a fixture config in a temp folder, never the user's own.
return {
  id = "open.keywords",
  feature = "open.keywords",
  task = "open.nvim/abnahme-system-oeffner-von-hand-fenster-gehen-wirklich-auf",
  title = "open.nvim: :Open split gitmessage opens the commit template the git config names",
  engine = "rpc",
  sizes = { { rows = 16, cols = 100 } },
  steps = {
    {
      lua = [[vim.opt.shortmess:append("I")
      vim.o.swapfile = false
      local dir = vim.fs.normalize(vim.fn.tempname())
      vim.fn.mkdir(dir, "p")
      _G.template = dir .. "/commit-template.txt"
      vim.fn.writefile({ "feat: <what changed>" }, _G.template)
      vim.fn.writefile({ "[commit]", "\ttemplate = " .. _G.template }, dir .. "/gitconfig")
      vim.env.GIT_CONFIG_GLOBAL = dir .. "/gitconfig"
      require("open").setup({})]],
      note = "the real setup, a global git config that names a commit template",
    },
    { keys = ":Open split gitmessage<CR>", note = ":Open split gitmessage" },
    { expect = [[#vim.api.nvim_list_wins() == 2]], note = "a split opened" },
    {
      expect = [[vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0)) == vim.uv.fs_realpath(_G.template)]],
      note = "it shows the template the git config names",
    },
    {
      expect = [[vim.api.nvim_get_current_line() == "feat: <what changed>"]],
      note = "with its text",
    },
  },
  judge = {},
  manual = {},
}
