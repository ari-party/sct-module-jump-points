local StringUtil = {}

--- Remove parentheses and their content
---@param inputString string
---@return string
function StringUtil.removeParentheses( inputString )
    return string.match( string.gsub( inputString, '%b()', '' ), '^%s*(.*%S)' ) or ''
end

--- Replace obnoxious characters
---@param str string Input string
---@return string
function StringUtil.clean( str )
    local apostrophe = string.gsub( str, '’', '\'' )
    return apostrophe
end

return StringUtil
