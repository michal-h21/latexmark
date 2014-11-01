local latexmark = {}
local lunamark = require("lunamark")
local writer = lunamark.writer.latex.new()
local util = lunamark.util
writer.string = function(s) return s end
writer.definitionlist= function(items)
    local buffer = {}
    for _,item in ipairs(items) do
      local defs = {}
      buffer[#buffer + 1] = {"\\item[",item.term,"] ", util.intersperse(item.definitions,"\n")}
    end
    local contents = util.intersperse(buffer, "\n")
    return {"\\begin{description}\n",contents,"\n\\end{description}"}
 end
latexmark.init = function(extensions)
   local extensions = extensions or { smart = true, definition_lists=true}
   latexmark.parser = lunamark.reader.markdown.new(writer, extensions)
end


latexmark.end_env = "%s*\\end{latexmark}"
local buffer = {}
latexmark.callback = function(buf)
  if buf:match(latexmark.end_env) then
    --local ret =  latexmark.process() 
    --table.insert(ret, buf)
    return ret
  end
  buffer[#buffer+1] = buf
  return ''
end

latexmark.process = function()
  local result = latexmark.parser(table.concat(buffer,"\n"))
  buffer = {}
  local lines = string.explode(result,"\n")
  for _, line in ipairs(lines) do
    print(line)
    tex.print(line)
  end
  return lines
end

return latexmark
