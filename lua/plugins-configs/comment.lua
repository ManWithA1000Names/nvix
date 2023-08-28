local comment = require("Comment")

comment.setup({
  sticky = true,
  pre_hook = function(...)
    local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
    if loaded and ts_comment then
      return ts_comment.create_pre_hook()(...)
    end
  end,
  mappings = {
    basic = true,
    extra = true,
  },
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  opleader = {
    line = "gc",
    block = "gb",
  },
  padding = true,
  ignore = "^$",
})
