 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#131313',
    base01 = '#1f1f1f',
    base02 = '#2a2a2a',
    base03 = '#919191',
    base04 = '#c6c6c6',
    base05 = '#e2e2e2',
    base06 = '#e2e2e2',
    base07 = '#e2e2e2',
    base08 = '#ffb4ab',
    base09 = '#cec0e8',
    base0A = '#b7c9d9',
    base0B = '#89ceff',
    base0C = '#cec0e8',
    base0D = '#89ceff',
    base0E = '#b7c9d9',
    base0F = '#93000a',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e2e2e2',          bg = '#131313' })
  hi('TelescopeBorder',         { fg = '#919191',             bg = '#131313' })
  hi('TelescopePromptNormal',   { fg = '#e2e2e2',          bg = '#131313' })
  hi('TelescopePromptBorder',   { fg = '#919191',             bg = '#131313' })
  hi('TelescopePromptPrefix',   { fg = '#89ceff',             bg = '#131313' })
  hi('TelescopePromptCounter',  { fg = '#c6c6c6',  bg = '#131313' })
  hi('TelescopePromptTitle',    { fg = '#131313',             bg = '#89ceff' })
  hi('TelescopePreviewTitle',   { fg = '#131313',             bg = '#b7c9d9' })
  hi('TelescopeResultsTitle',   { fg = '#131313',             bg = '#cec0e8' })
  hi('TelescopeSelection',      { fg = '#e2e2e2',          bg = '#2a2a2a' })
  hi('TelescopeSelectionCaret', { fg = '#89ceff',             bg = '#2a2a2a' })
  hi('TelescopeMatching',       { fg = '#89ceff',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
