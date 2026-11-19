-- TESTS/sheets/features.lua -- the functionalities of open.nvim that start a process (directly or through lib.nvim),
-- read by testing.nvim (`testing perf`, `testing sheets report`). A feature sheet names its entry with
-- `feature = "<id>"`; an entry without a sheet says why with `perf`.
return {
  {
    id = "open.default",
    title = ":Open default hands the path or URL under the cursor to the system default application (like a double-click)",
    surface = { "command:Open default" },
    docs = "docs/FEATURES/HANDLERS.md",
  },
  {
    id = "open.browser",
    title = ":Open browser opens the URL under the cursor in the system default browser (a path as file://, text as a search)",
    surface = { "command:Open browser", "config:keymaps.open_browser", "config:default_browser" },
    docs = "docs/FEATURES/HANDLERS.md",
  },
  {
    id = "open.named-browser",
    title = ":Open chrome / firefox / edge / brave / opera / safari opens the URL in that browser",
    surface = {
      "command:Open chrome",
      "command:Open firefox",
      "command:Open edge",
      "command:Open safari",
    },
    docs = "docs/FEATURES/HANDLERS.md",
    perf = "manual:starts an installed browser by its absolute path (Windows) or app name (macOS); a stand-in cannot take its place and a real browser window must not open in a sheet",
  },
  {
    id = "open.filemanager",
    title = ":Open filemanager reveals the path under the cursor in the system file manager (raised to the front on Windows)",
    surface = {
      "command:Open filemanager",
      "config:keymaps.open_filemanager",
      "config:filemanager",
    },
    docs = "docs/FEATURES/HANDLERS.md",
  },
  {
    id = "open.notepad",
    title = ":Open notepad writes the text under the cursor to a temp file and opens it in the system GUI text editor",
    surface = { "command:Open notepad", "command:Open editor", "config:keymaps.open_notepad" },
    docs = "docs/FEATURES/HANDLERS.md",
  },
  {
    id = "open.image",
    title = ":Open image draws the image with images.nvim, without it hands the file to the system default application",
    surface = { "command:Open image", "config:keymaps.open_image" },
    docs = "docs/FEATURES/HANDLERS.md",
  },
  {
    id = "open.office-open",
    title = "Editing an Office document (:e report.docx, gf, a picker) hands it to the system application and wipes the placeholder buffer",
    surface = { "config:office_open" },
    docs = "docs/FEATURES/CORE.md",
  },
  {
    id = "open.keywords",
    title = ":Open <handler> <keyword> resolves a built-in keyword through its program (git config for gitmessage and gitignore_global, PowerShell for pwsh_profile)",
    surface = { "command:Open split gitmessage", "config:builtin_keywords", "config:keywords" },
    docs = "docs/keywords.md",
  },
  {
    id = "open.terminal",
    title = ":Open terminal opens a terminal split (the user's shell) in the directory of the target",
    surface = { "command:Open terminal", "config:keymaps.open_terminal" },
    docs = "docs/FEATURES/HANDLERS.md",
  },
}
