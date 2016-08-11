local latexmark = {}
local lunamark = require("lunamark")
local writer = lunamark.writer.latex.new()
local util = lunamark.util
local cosmo = require "cosmo"

-- fixes for lua 5.1 functions used in cosmo
unpack = unpack or table.unpack
loadstring = loadstring or load

writer.string = function(s) return s end
latexmark.template = nil 

local escaped = {
     ["{"] = "\\{",
     ["}"] = "\\}",
     ["$"] = "\\$",
     ["%"] = "\\%",
     ["&"] = "\\&",
     ["_"] = "\\_",
     ["#"] = "\\#",
     ["^"] = "\\^{}",
     ["\\"] = "\\char92{}",
     ["~"] = "\\char126{}",
     ["|"] = "\\char124{}",
     ["<"] = "\\char60{}",
     [">"] = "\\char62{}",
     ["["] = "{[}", -- to avoid interpretation as optional argument
     ["]"] = "{]}",
   }

local tex_escape = function(s)
  local new = {}
  for x in s:gmatch(".") do
    print(escaped[x] or x)
    new[#new+1] = escaped[x] or x
  end
  return table.concat(new)
end

writer.code = function(s) return string.format("\\texttt{%s}", tex_escape(s)) end

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
   local extensions = extensions or {}
   local usedextensions = {}
   extensions = #extensions > 0  and extensions or { "smart", "definition_lists"}
   for _,k in pairs(extensions) do 
     usedextensions[k] = true
   end
   latexmark.parser = lunamark.reader.markdown.new(writer, usedextensions)
end

latexmark.save_template = function(tpl)
  if string.len(tpl) == 0 then 
    return false,"No template" 
  end
  local f = io.open(kpse.find_file(tpl),"r")
  if not f then 
    print("latexmark: cannot load template file: "..tpl)
  else
    latexmark.template = f:read("*all")
    f:close()
  end
end

latexmark.end_env = "%s*\\end{latexmark}"
local buffer = {}
latexmark.callback = function(buf,no_env)
  if buf:match(latexmark.end_env) and no_env==nil then
    --local ret =  latexmark.process() 
    --table.insert(ret, buf)
    return ret
  end
  buffer[#buffer+1] = buf
  return ''
end

latexmark.process = function()
  local body, metadata = latexmark.parser(table.concat(buffer,"\n"))
  local template = latexmark.template or "$body"
  -- erase current buffer
  buffer = {}
  metadata = metadata or {}
  --[[ for k,v in pairs(metadata) do
    print("meta",k,v)
    for i, j in pairs(v) do
      print(i,j)
    end
  end
  --]]
  metadata.body = body
  result = cosmo.fill(template, metadata)
  local lines = string.explode(result,"\n")
  for _, line in ipairs(lines) do
    print(line)
    -- tex.print(line)
  end
  tex.print(lines)
  return lines
end

return latexmark
