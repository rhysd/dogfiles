vim.g.mapleader = ","


local api = vim.api
local fn = vim.fn
local keymap = vim.keymap.set
local cmd = vim.cmd
local opt = vim.opt
local telescope_builtin
local lazy_plugins = {
  telescope = {
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
  },
  treesitter = {
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  },
  operator_replace = {
    { src = "https://github.com/kana/vim-operator-user" },
    { src = "https://github.com/kana/vim-operator-replace" },
  },
  textobj_entire = {
    { src = "https://github.com/kana/vim-textobj-user" },
    { src = "https://github.com/kana/vim-textobj-entire" },
  },
  textobj_anyblock = {
    { src = "https://github.com/kana/vim-textobj-user" },
    { src = "https://github.com/rhysd/vim-textobj-anyblock" },
  },
  textobj_indent = {
    { src = "https://github.com/kana/vim-textobj-user" },
    { src = "https://github.com/kana/vim-textobj-indent" },
  },
}

local augroup = api.nvim_create_augroup("MyVimrc", { clear = true })
local lsp_format_augroup = api.nvim_create_augroup("MyLspFormat", { clear = true })
local lsp_document_highlight_augroup = api.nvim_create_augroup("MyLspDocumentHighlight", { clear = true })

local lsp_float_opts = {
  border = "single",
  focusable = true,
  silent = true,
}
local lsp_capabilities = {
  { method = "textDocument/definition", label = "definition" },
  { method = "textDocument/references", label = "references" },
  { method = "textDocument/rename", label = "rename" },
  { method = "textDocument/formatting", label = "format" },
  { method = "textDocument/inlayHint", label = "inlayHint" },
}

local function telescope_picker(name)
  return function()
    telescope_builtin()[name]()
  end
end

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  severity_sort = true,
  float = { border = "rounded" },
})

api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local map_opts = { buffer = event.buf }
    keymap("n", "gd", vim.lsp.buf.definition, map_opts)
    keymap("n", "K", function() vim.lsp.buf.hover(lsp_float_opts) end, map_opts)
    keymap("n", "<Leader>ls", vim.lsp.buf.signature_help, map_opts)
    keymap("n", "<Leader>lci", telescope_picker("lsp_incoming_calls"), map_opts)
    keymap("n", "<Leader>lco", telescope_picker("lsp_outgoing_calls"), map_opts)
    keymap("n", "gD", vim.lsp.buf.declaration, map_opts)
    keymap("n", "<Leader>li", telescope_picker("lsp_implementations"), map_opts)
    keymap("n", "<Leader>lr", telescope_picker("lsp_references"), map_opts)
    keymap("n", "<Leader>ln", vim.lsp.buf.rename, map_opts)
    keymap({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, map_opts)
    keymap("n", "<Leader>ld", vim.diagnostic.open_float, map_opts)
    keymap("n", "[d", vim.diagnostic.goto_prev, map_opts)
    keymap("n", "]d", vim.diagnostic.goto_next, map_opts)

    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

    if client and client:supports_method("textDocument/documentHighlight") then
      api.nvim_clear_autocmds({
        group = lsp_document_highlight_augroup,
        buffer = event.buf,
      })
      api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = lsp_document_highlight_augroup,
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
        group = lsp_document_highlight_augroup,
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client and client:supports_method("textDocument/formatting") then
      api.nvim_clear_autocmds({
        group = lsp_format_augroup,
        buffer = event.buf,
      })
      api.nvim_create_autocmd("BufWritePre", {
        group = lsp_format_augroup,
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = event.buf,
            timeout_ms = 1000,
          })
        end,
      })
    end
  end,
})

local enabled_lsps = {}

local function enable_lsp(name, config, executable)
  api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = config.filetypes,
    callback = function()
      if enabled_lsps[name] or fn.exepath(executable or name) == "" then
        return
      end
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
      enabled_lsps[name] = true
    end,
  })
end

enable_lsp("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    { "compile_commands.json", "compile_flags.txt" },
    ".clangd",
    ".git",
  },
})

enable_lsp("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = {
    "Cargo.toml",
    "rust-project.json",
    ".git",
  },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
    },
  },
}, "rust-analyzer")

enable_lsp("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = {
    "go.work",
    "go.mod",
    ".git",
  },
})

enable_lsp("pylsp", {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
})

enable_lsp("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}, "typescript-language-server")

enable_lsp("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    { ".luarc.json", ".luarc.jsonc" },
    ".git",
  },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}, "lua-language-server")

api.nvim_create_user_command("Autocmd", function(opts)
  api.nvim_exec2("autocmd MyVimrc " .. opts.args, { output = false })
end, { nargs = "*" })

api.nvim_create_user_command("AutocmdFT", function(opts)
  api.nvim_exec2("autocmd MyVimrc FileType " .. opts.args, { output = false })
end, { nargs = "*" })

api.nvim_create_user_command("LspInfo", function()
  local bufnr = api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local lines = {
    "LSP clients for current buffer",
    "",
    "Buffer: " .. api.nvim_buf_get_name(bufnr),
    "Filetype: " .. vim.bo[bufnr].filetype,
    "",
  }

  if #clients == 0 then
    table.insert(lines, "No LSP clients attached.")
  else
    for i, client in ipairs(clients) do
      local cfg = client.config or {}
      local cmdline = cfg.cmd and table.concat(cfg.cmd, " ") or "(none)"
      local root = client.root_dir or cfg.root_dir or "(none)"
      local caps = {}

      for _, capability in ipairs(lsp_capabilities) do
        if client:supports_method(capability.method) then
          table.insert(caps, capability.label)
        end
      end

      table.insert(lines, ("[%d] %s (id=%d)"):format(i, client.name, client.id))
      table.insert(lines, "  root: " .. tostring(root))
      table.insert(lines, "  cmd: " .. cmdline)
      table.insert(lines, "  capabilities: " .. (#caps > 0 and table.concat(caps, ", ") or "(none)"))
      table.insert(lines, "")
    end
  end

  local info_buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(info_buf, 0, -1, false, lines)

  local bo = vim.bo[info_buf]
  bo.bufhidden = "wipe"
  bo.filetype = "lspinfo"
  bo.modifiable = false
  bo.buftype = "nofile"

  cmd("botright new")
  api.nvim_win_set_buf(0, info_buf)
end, {})

api.nvim_create_user_command("LspRename", function()
  vim.lsp.buf.rename()
end, {})
api.nvim_create_user_command("LspIncomingCalls", telescope_picker("lsp_incoming_calls"), {})
api.nvim_create_user_command("LspOutgoingCalls", telescope_picker("lsp_outgoing_calls"), {})
api.nvim_create_user_command("LspDiagnostics", function(opts)
  local diagnostics_opts = {}
  if opts.bang then
    diagnostics_opts.severity = { min = vim.diagnostic.severity.WARN }
  end
  telescope_builtin().diagnostics(diagnostics_opts)
end, { bang = true })

cmd("language message C")
cmd("language time C")

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.shiftround = true
opt.expandtab = true
opt.showmatch = true
opt.wildmode = { "longest:full", "full" }
opt.wildoptions = { "pum" }
opt.scrolloff = 5
opt.cindent = true
opt.ignorecase = true
opt.smartcase = true
opt.list = true
opt.formatoptions:remove({ "r", "o" })
opt.nrformats:remove({ "octal" })
opt.clipboard = "unnamed"
opt.virtualedit = "block"
opt.fileformats = { "unix", "dos", "mac" }
opt.showcmd = false
opt.showcmdloc = "statusline"
opt.completeopt = { "menuone", "menu" }
opt.langmenu = "none"
opt.cmdheight = 0
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.whichwrap:append("h,l")
opt.history = 100
opt.updatetime = 3000
opt.swapfile = false
opt.shortmess:append("I")

local undo_dir = fn.stdpath("state") .. "/undo"
if fn.isdirectory(undo_dir) == 0 then
  fn.mkdir(undo_dir, "p")
end
opt.undodir = undo_dir
opt.undofile = true
opt.cmdwinheight = 3
opt.spelllang = { "en", "cjk" }
opt.breakindent = true

api.nvim_create_autocmd({ "BufRead", "BufNew", "BufNewFile" }, {
  group = augroup,
  pattern = "gitconfig",
  callback = function()
    vim.bo.filetype = "gitconfig"
  end,
})

api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.foldenable = false
    vim.opt_local.spell = true
  end,
})

api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({
      higroup = "CursorLine",
      timeout = 500,
    })
  end,
})

keymap("n", "<Leader>h", ":<C-u>help <C-l>", { silent = true })
keymap("n", "<Leader>cc", "gcc", { remap = true })
keymap("x", "<Leader>cc", "gc", { remap = true })

api.nvim_create_user_command("SetIndent", function(opts)
  local target = opts.bang and vim.opt or vim.opt_local
  local width = tonumber(opts.args)
  target.tabstop = width
  target.shiftwidth = width
  target.softtabstop = width
end, { bang = true, nargs = 1 })

keymap({ "n", "v", "o" }, ":", ";")
keymap({ "n", "v", "o" }, ";", ":")
keymap({ "n", "v", "o" }, "@;", "@:")
keymap({ "n", "v", "o" }, "@:", "@;")

keymap("i", "j", function()
  return fn.getline("."):sub(fn.col(".") - 1, fn.col(".") - 1) == "j" and "<BS><Esc>" or "j"
end, { expr = true })

keymap("c", "j", function()
  local pos = fn.getcmdpos() - 1
  return fn.getcmdline():sub(pos, pos) == "j" and "<BS><Esc>" or "j"
end, { expr = true })

keymap("i", "<C-c>", "<Esc>")
keymap("n", "Y", "y$")
keymap({ "n", "v", "o" }, "j", "gj")
keymap({ "n", "v", "o" }, "k", "gk")
keymap("n", "<C-j>", ":<C-u>keepjumps normal! }<CR>", { silent = true })
keymap("n", "<C-k>", ":<C-u>keepjumps normal! {<CR>", { silent = true })
keymap("v", "<C-j>", "}")
keymap("v", "<C-k>", "{")
keymap("n", "m", function()
  return "i" .. fn.nr2char(fn.getchar()) .. "<Esc>"
end, { expr = true, silent = true })
keymap({ "n", "v", "o" }, "gm", "m")
keymap("n", "<Esc><Esc>", ":<C-u>nohlsearch<CR>", { silent = true })
keymap("i", "<Tab>", function()
  return fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, silent = true })
keymap("n", "n", "nzvzz")
keymap("n", "N", "Nzvzz")
keymap("i", "<C-e>", "<End>")
keymap("c", "<C-e>", "<End>")
keymap("i", "<C-a>", "<Home>")
keymap("c", "<C-a>", "<Home>")
keymap("i", "<C-n>", function()
  return fn.pumvisible() == 1 and "<C-y><Down>" or "<Down>"
end, { expr = true, silent = true })
keymap("i", "<C-p>", function()
  return fn.pumvisible() == 1 and "<C-y><Up>" or "<Up>"
end, { expr = true, silent = true })
keymap("i", "<C-b>", function()
  return fn.pumvisible() == 1 and "<C-y><Left>" or "<Left>"
end, { expr = true, silent = true })
keymap("i", "<C-f>", function()
  return fn.pumvisible() == 1 and "<C-y><Right>" or "<Right>"
end, { expr = true, silent = true })
keymap("c", "<C-f>", "<Right>")
keymap("c", "<C-b>", "<Left>")
keymap("i", "<C-d>", "<Del>")
keymap("c", "<C-d>", function()
  return #fn.getcmdline() == fn.getcmdpos() - 1 and "<C-d>" or "<Del>"
end, { expr = true })
keymap("i", "<C-k>", function()
  return "<C-g>u" .. (fn.col(".") == fn.col("$") and "<C-o>gJ" or "<C-o>D")
end, { expr = true, silent = true })
keymap("c", "<C-k>", [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>]])
keymap("c", "<C-y>", "<C-r>+")
keymap("c", "<C-g>", "<C-u><BS>")
keymap("n", "<C-n>", ":<C-u>bnext<CR>", { silent = true })
keymap("n", "<C-p>", ":<C-u>bprevious<CR>", { silent = true })
keymap("n", "s", "<C-w>")
keymap("n", "<C-w>O", "<C-w>o")

local function delete_current_buf()
  local current = fn.bufnr("%")
  cmd.bnext()
  if current == fn.bufnr("%") then
    cmd.enew()
  end
  cmd("silent! bdelete! #")
end

keymap("n", "<C-w>d", delete_current_buf)
keymap("n", "x", '"_x')
keymap("n", "gp", function()
  return "`[" .. fn.strpart(fn.getregtype(), 0, 1) .. "`]"
end, { expr = true })
keymap("n", "P", '"0P')
keymap("n", "ge", ":<C-u>tabedit ")
keymap("n", "gn", ":<C-u>tabnew<CR>")
keymap("n", "gx", ":<C-u>tabclose<CR>", { silent = true })
keymap("n", "H", "g0")
keymap("n", "M", "g^")
keymap("n", "L", "g$")
keymap("v", "H", "g0")
keymap("v", "M", "g^")
keymap("v", "L", "g$")
keymap("n", "gM", "^")
keymap("n", "gH", "0")
keymap("n", "gL", "$")
keymap("v", "gM", "^")
keymap("v", "gH", "0")
keymap("v", "gL", "$")
keymap("n", "gh", "H")
keymap("n", "gl", "L")
keymap("n", "gm", "M")
keymap("v", "gh", "H")
keymap("v", "gl", "L")
keymap("v", "gm", "M")
keymap("n", "<Space>ss", ":<C-u>setl spell! spell?<CR>")

local function cmdline_window_settings()
  local map_opts = { buffer = true, silent = true }
  keymap("n", "q", ":<C-u>q<CR>", map_opts)
  keymap("n", "<Esc>", ":<C-u>q<CR>", map_opts)
  keymap("n", "<Esc><Esc>", ":<C-u>q<CR>", map_opts)
  keymap("i", "<C-g>", "<Esc>:q<CR>", map_opts)
  keymap("n", "<CR>", "A<CR>", map_opts)
end

api.nvim_create_autocmd("CmdwinEnter", {
  group = augroup,
  pattern = "*",
  callback = cmdline_window_settings,
})

keymap("n", "<Leader>cl", function()
  local cc = vim.wo.colorcolumn
  local width = (cc == "" or cc == "0") and (vim.v.count == 0 and fn.col(".") or vim.v.count) or 0
  cmd("set colorcolumn=" .. width)
end, { expr = false })

local function double_semi()
  if fn.getline("."):sub(fn.col(".") - 1, fn.col(".") - 1) == ";" then
    return "<BS>::"
  end
  return ";"
end

api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "cpp", "rust" },
  callback = function()
    keymap("i", ";", double_semi, { buffer = true, expr = true, silent = true })
  end,
})

keymap("t", "<Esc><Esc>", [[<C-\><C-n>]])

local function on_filetype_help_define_mappings()
  if vim.bo.readonly then
    local map_opts = { buffer = true }
    keymap("n", "J", "<C-]>", map_opts)
    keymap("n", "K", "<C-t>", map_opts)
    keymap("n", "u", "<C-u>", map_opts)
    keymap("n", "d", "<C-d>", map_opts)
    keymap("n", "q", ":<C-u>q<CR>", map_opts)
  end
end

api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "help",
  callback = on_filetype_help_define_mappings,
})

local function on_filetype_qf()
  local map_opts = { buffer = true, silent = true }
  keymap("n", "q", ":<C-u>cclose<CR>", map_opts)
  keymap("n", "j", ":<C-u>cnext<CR>:copen<CR>", map_opts)
  keymap("n", "k", ":<C-u>cprevious<CR>:copen<CR>", map_opts)
  keymap("n", "J", ":<C-u>cnfile<CR>:copen<CR>", map_opts)
  keymap("n", "K", ":<C-u>cpfile<CR>:copen<CR>", map_opts)
  keymap("n", "l", ":<C-u>clist<CR>", map_opts)
  keymap("n", "<CR>", "<CR>", { buffer = true })
end

api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "qf",
  callback = on_filetype_qf,
})

local function git(cmdline)
  local dir = fn.expand("%:p:h")
  if dir == "" then
    dir = fn.getcwd()
  end

  cmd("terminal VIMRUNTIME= git -C " .. fn.fnameescape(dir) .. " " .. cmdline)
  local term_bufnr = fn.bufnr("%")
  local channel = vim.bo[term_bufnr].channel

  api.nvim_create_autocmd("TermClose", {
    group = augroup,
    buffer = term_bufnr,
    once = true,
    callback = function()
      if fn.jobwait({ channel }, 0)[1] == 0 then
        cmd(("silent %d bdelete!"):format(term_bufnr))
        vim.api.nvim_echo({ { ("Done: `git %s`"):format(cmdline) } }, false, {})
      end
    end,
  })
end

api.nvim_create_user_command("GitAdd", function(opts)
  git("add " .. fn.expand("%:p") .. " " .. opts.args)
end, { nargs = "*" })

api.nvim_create_user_command("GitCommit", function(opts)
  git("commit " .. opts.args)
end, { nargs = "*" })

keymap("n", "<Leader>ga", ":<C-u>GitAdd<CR>", { silent = true })
keymap("n", "<Leader>gc", ":<C-u>GitCommit<CR>", { silent = true })

keymap("n", "<Leader><Leader>", function()
  local name = api.nvim_buf_get_name(0)
  local dir = name == "" and fn.getcwd() or fn.fnamemodify(name, ":p:h")
  cmd("Dirvish " .. fn.fnameescape(dir))
end, { silent = true })

api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "dirvish",
  callback = function(event)
    local function dirvish_open()
      local path = fn.getline(".")
      if path == "" then
        return
      end

      if fn.isdirectory(path) == 1 then
        cmd("Dirvish " .. fn.fnameescape(path))
      else
        cmd("edit " .. fn.fnameescape(path))
      end
    end

    keymap("n", "h", ":<C-u>Dirvish %:p:h:h<CR>", { buffer = event.buf, silent = true })
    keymap("n", "l", dirvish_open, { buffer = event.buf, silent = true })
    keymap("n", "~", ":<C-u>Dirvish ~<CR>", { buffer = event.buf, silent = true })
  end,
})

vim.pack.add({
  { src = "https://github.com/rhysd/vim-color-spring-night" },
  { src = "https://github.com/rhysd/clever-f.vim" },
  { src = "https://github.com/haya14busa/vim-asterisk" },
  { src = "https://github.com/justinmk/vim-dirvish" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

-- cmd.colorscheme("spring-night")

local loaded_plugins = {}
local function pack_load(name)
  if loaded_plugins[name] then
    return
  end
  cmd("packadd " .. name)
  loaded_plugins[name] = true
end

local function pack_add_once(key)
  if loaded_plugins[key] then
    return false
  end
  vim.pack.add(lazy_plugins[key], { load = true })
  loaded_plugins[key] = true
  return true
end

pack_load("clever-f.vim")
pack_load("vim-asterisk")
pack_load("vim-dirvish")
pack_load("gitsigns.nvim")
pack_load("lualine.nvim")

keymap({ "n", "x" }, "*", "<Plug>(asterisk-z*)", { remap = true })
keymap({ "n", "x" }, "#", "<Plug>(asterisk-z#)", { remap = true })
keymap({ "n", "x" }, "g*", "<Plug>(asterisk-gz*)", { remap = true })
keymap({ "n", "x" }, "g#", "<Plug>(asterisk-gz#)", { remap = true })

local function operator_replace_mapping()
  pack_add_once("operator_replace")
  return "<Plug>(operator-replace)"
end

keymap("n", "<Leader>r", function()
  return operator_replace_mapping()
end, { expr = true, remap = true })
keymap("x", "<Leader>r", function()
  return operator_replace_mapping()
end, { expr = true, remap = true })

local function textobj_mapping(group_name, plug_name)
  return function()
    pack_add_once(group_name)
    return plug_name
  end
end

keymap({ "x", "o" }, "ae", textobj_mapping("textobj_entire", "<Plug>(textobj-entire-a)"), { expr = true, remap = true })
keymap({ "x", "o" }, "ie", textobj_mapping("textobj_entire", "<Plug>(textobj-entire-i)"), { expr = true, remap = true })
keymap({ "x", "o" }, "ab", textobj_mapping("textobj_anyblock", "<Plug>(textobj-anyblock-a)"), { expr = true, remap = true })
keymap({ "x", "o" }, "ib", textobj_mapping("textobj_anyblock", "<Plug>(textobj-anyblock-i)"), { expr = true, remap = true })
keymap({ "x", "o" }, "ai", textobj_mapping("textobj_indent", "<Plug>(textobj-indent-a)"), { expr = true, remap = true })
keymap({ "x", "o" }, "ii", textobj_mapping("textobj_indent", "<Plug>(textobj-indent-i)"), { expr = true, remap = true })
keymap({ "x", "o" }, "aI", textobj_mapping("textobj_indent", "<Plug>(textobj-indent-same-a)"), { expr = true, remap = true })
keymap({ "x", "o" }, "iI", textobj_mapping("textobj_indent", "<Plug>(textobj-indent-same-i)"), { expr = true, remap = true })

local function ensure_treesitter()
  if pack_add_once("treesitter") then
    require("nvim-treesitter").setup()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
    })
  end
end

keymap({ "x", "o" }, "af", function()
  ensure_treesitter()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
keymap({ "x", "o" }, "if", function()
  ensure_treesitter()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
keymap({ "x", "o" }, "ac", function()
  ensure_treesitter()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
keymap({ "x", "o" }, "ic", function()
  ensure_treesitter()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
keymap({ "x", "o" }, "aa", function()
  ensure_treesitter()
  require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
end)
keymap({ "x", "o" }, "ia", function()
  ensure_treesitter()
  require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
end)

api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "c",
    "cpp",
    "go",
    "javascript",
    "javascriptreact",
    "lua",
    "markdown",
    "query",
    "rust",
    "typescript",
    "typescriptreact",
    "vim",
    "help",
  },
  callback = function(args)
    ensure_treesitter()
    pcall(vim.treesitter.start, args.buf)
  end,
})

telescope_builtin = function()
  if pack_add_once("telescope") then
    local telescope_actions = require("telescope.actions")
    local plenary_path = require("plenary.path")
    require("telescope").setup({
      defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        sorting_strategy = "ascending",
        border = true,
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<Esc>"] = telescope_actions.close,
            ["<C-g>"] = telescope_actions.close,
          },
          n = {
            ["<Esc>"] = telescope_actions.close,
            ["<C-g>"] = telescope_actions.close,
          },
        },
      },
    })
  end
  return require("telescope.builtin")
end

keymap("n", "<Space>m", function()
  telescope_builtin().oldfiles()
end, { silent = true })

keymap("n", "<Space>g", function()
  telescope_builtin().live_grep()
end, { silent = true })

keymap("n", "<Space>f", function()
  telescope_builtin().find_files()
end, { silent = true })

keymap("n", "<Space>b", function()
  telescope_builtin().buffers()
end, { silent = true })

keymap("n", "<Space>/", function()
  telescope_builtin().current_buffer_fuzzy_find()
end, { silent = true })

keymap("n", "<Space>o", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 then
    telescope_builtin().lsp_document_symbols()
  else
    telescope_builtin().treesitter()
  end
end, { silent = true })

keymap("n", "<Space>s", function()
  telescope_builtin().lsp_workspace_symbols()
end, { silent = true })

keymap("n", "<Space>d", function()
  telescope_builtin().diagnostics()
end, { silent = true })

keymap("n", "<Space><Space>", function()
  telescope_builtin().builtin()
end, { silent = true })

local function macro_recording_status()
  local reg = fn.reg_recording()
  return reg == "" and "" or ("●REC @" .. reg)
end

require("lualine").setup({
  options = {
    icons_enabled = false,
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
    theme = "auto",
  },
  sections = {
    lualine_a = { "mode", macro_recording_status },
    lualine_b = { "branch", "diff" },
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = {
      {
        "diagnostics",
        symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
      },
      "filetype",
      "encoding",
      "fileformat",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

require("gitsigns").setup()
