local cmp = require'cmp'

vim.g.regex =
         --[=[\%(]=]
         [=[\v\\%(]=]
      .. [=[%(\a*cite|Cite)\a*\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*]=]
      .. [=[|%(\a*cites|Cites)%(\s*\([^)]*\)){0,2}]=]
      ..    [=[%(%(\s*\[[^]]*\]){0,2}\s*\{[^}]*\})*]=]
      ..    [=[%(\s*\[[^]]*\]){0,2}\s*\{[^}]*]=]
      .. [=[|bibentry\s*\{[^}]*]=]
      .. [=[|%(text|block)cquote\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*]=]
      .. [=[|%(for|hy)\w*cquote\*?\{[^}]*}%(\s*\[[^]]*\]){0,2}\s*\{[^}]*]=]
      .. [=[|defbibentryset\{[^}]*}\{[^}]*]=]
      .. [=[|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)]=]
      .. [=[|hyperref\s*\[[^]]*]=]
      .. [=[|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*]=]
      .. [=[|%(include%(only)?|input|subfile)\s*\{[^}]*]=]
      .. [=[|([cpdr]?(gls|Gls|GLS)|acr|Acr|ACR)\a*\s*\{[^}]*]=]
      .. [=[|(ac|Ac|AC)\s*\{[^}]*]=]
      .. [=[|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*]=]
      .. [=[|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*]=]
      .. [=[|%(usepackage|RequirePackage|PassOptionsToPackage)%(\s*\[[^]]*\])?\s*\{[^}]*]=]
      .. [=[|documentclass%(\s*\[[^]]*\])?\s*\{[^}]*]=]
      .. [=[|begin%(\s*\[[^]]*\])?\s*\{[^}]*]=]
      .. [=[|end%(\s*\[[^]]*\])?\s*\{[^}]*]=]
      .. [=[|\a*]=]
      .. [=[)]=]
      .. [=[\m]=]
      --.. [=[\m\)$]=]

cmp.setup.buffer {
    --formatting = {
    --  --format = function(entry, vim_item)
    --  --    vim_item.menu = ({
    --  --      omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
    --  --      --vimtex = "[V]",
    --  --      --buffer = "[Buffer]",
    --  --      })[entry.source.name]
    --  --    return vim_item
    --  --end,
    --},
    --formatting = {
    --  format = function(entry, vim_item)
    --    --if entry.source.name == "vimtex" then
    --    --  vim_item.kind = "Ѵ"
    --    --  return vim_item
    --    --end       

    --    return vim_item
    --  end,
    --},
    sources = {
        --{ name = 'nvim_lsp' },
        --{ name = 'omni', keyword_length = 0 },
        --{ name = 'omni', keyword_pattern = vim.g.regex },
        --{ name = 'omni', keyword_pattern = [[\v.]] },
        --{ name = 'omni', trigger_characters = { "{", } },
        --{ name = 'omni' },
        --{ name = 'buffer' },
        --{ name = 'buffer', keyword_pattern = vim.g.regex },
        --{ name = 'vimtex', trigger_characters = { "{", } },
        {
          name = 'vimtex',
          option = {
            --custom_kind = '(',
            info_in_menu = 1,
            info_in_window = 1,
            match_against_description = 1,
            symbols_in_menu = 1,
          },
        },
        { name = 'buffer',},
    },
}

function dump(o)
    if type(o) == 'table' then
        return print_table(o)
    else
        return tostring(o)
    end
end
function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    return output_str
end
