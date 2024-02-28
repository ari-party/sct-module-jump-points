local Common = require( 'Module:Common' )

local StringUtil = {
    removeParentheses = Common.removeParentheses
}

--- Replace obnoxious characters
---@param str string Input string
---@return string
function StringUtil.clean( str )
    local apostrophe = mw.ustring.gsub( str, '’', '\'' )
    return apostrophe
end

--- Lower first character
---@param str string Input string
---@return string
function StringUtil.lowerFirst( str )
    return mw.ustring.lower( mw.ustring.sub( str, 1, 1 ) ) .. mw.ustring.sub( str, 2 )
end

return StringUtil
