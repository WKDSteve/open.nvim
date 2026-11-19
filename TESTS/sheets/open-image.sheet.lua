-- The image key draws a picture with images.nvim; the sheet's child has no images.nvim, so it takes the fallback a
-- user without it meets: the file goes to the system default application through `lib.nvim.cross.open_default`
-- (`explorer.exe` / `open` / `xdg-open`). The openers are recording stand-ins (TESTS/sheets/fixtures/openers.lua).
return {
  id = "open.image",
  feature = "open.image",
  title = "open.nvim: <leader>oi on an image name without images.nvim hands the image to the system application",
  engine = "rpc",
  sizes = { { rows = 12, cols = 100 } },
  fakes = { "explorer", "notepad", "powershell", "xdg-open", "open" },
  steps = {
    {
      lua = [[_G.O = dofile(vim.fn.getcwd() .. "/TESTS/sheets/fixtures/openers.lua")
      _G.O.prepare()
      _G.O.write("diagram.png", "\137PNG\r\n\26\n")
      vim.g.mapleader = " "
      require("open").setup({ keymaps = { open_image = "<leader>oi" } })]],
      note = "the real setup with an image key in a folder with diagram.png",
    },
    { expect = [[not pcall(require, "images")]], note = "images.nvim is not installed here" },
    {
      lua = [[_G.O.cursor_on("The flow is drawn in diagram.png below.", "diagram.png")]],
      note = "a line naming the image, the cursor on it",
    },
    { keys = " oi", note = "<leader>oi" },
    { wait = "#_G.O.calls() == 1", note = "one opener was started" },
    {
      expect = [[_G.O.last_arg():match("diagram%.png$") ~= nil]],
      note = "the opener got the image under the cursor",
    },
    {
      expect = [[_G.O.said("images.nvim not installed")]],
      note = "the user is told why it opens outside the editor",
    },
  },
  judge = {},
  manual = {
    "Once in the real editor with images.nvim: <leader>oi on a PNG draws it in the window, no external viewer opens",
  },
}
