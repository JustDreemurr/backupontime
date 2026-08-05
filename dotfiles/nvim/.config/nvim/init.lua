-- Visual 模式下按 Ctrl+Shift+C 复制选中文本到系统剪贴板
vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true })
vim.opt.clipboard = "unnamedplus"
