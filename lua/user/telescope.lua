local M={}

function M.grep_shit()

  require('telescope.builtin').live_grep {
    cwd = "~/",
    prompt = "~ MyShit ~",
    shorten = true,
    height = 10
  }
end
return M
