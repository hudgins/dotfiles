local M = {}

local function has_locations(results)
  for _, response in pairs(results or {}) do
    local result = response and response.result
    if result then
      if vim.islist(result) then
        if #result > 0 then
          return true
        end
      else
        return true
      end
    end
  end

  return false
end

function M.goto_definition_or_grep()
  if vim.bo.filetype ~= "php" then
    return Snacks.picker.lsp_definitions()
  end

  if vim.fn.expand("<cword>") == "" then
    return Snacks.picker.lsp_definitions()
  end

  local params = vim.lsp.util.make_position_params(0)
  vim.lsp.buf_request_all(0, "textDocument/definition", params, function(results)
    vim.schedule(function()
      if has_locations(results) then
        Snacks.picker.lsp_definitions()
      else
        require("config.project_grep").grep_word_filtered()
      end
    end)
  end)
end

return M
