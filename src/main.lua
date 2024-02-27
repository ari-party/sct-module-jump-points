local JumpPoints = {}

local Starmap = require( 'Module:Starmap' )
local t = require( 'translate' )
local stringUtil = require( 'utils.string' )

---@param frame table https://www.mediawiki.org/wiki/Extension:Scribunto/Lua_reference_manual#Frame_object
function JumpPoints.main( frame )
    local args = frame:getParent().args

    local systemName = args[ 1 ]
    if not systemName then return t( 'error_invalid_args' ) end

    local children = Starmap.systemObjects( systemName )
    if not children then return t( 'error_no_data' ) end

    local wikitable = '{| class="wikitable"\n' ..
        '!' .. t( 'lbl_jumpgate' ) .. '\n' ..
        '!' .. t( 'lbl_direction' ) .. '\n' ..
        '!' .. t( 'lbl_size' ) .. '\n' ..
        '!' .. t( 'lbl_destination' ) .. '\n'

    for _, object in ipairs( children ) do
        if object.type == 'JUMPPOINT' then
            local exitObject = object.tunnel.exit
            -- Make sure the exit is not the current object
            if exitObject.code == object.code then exitObject = object.tunnel.entry end

            wikitable = wikitable .. '|-\n' ..
                '|[[' .. stringUtil.clean( stringUtil.removeParentheses( object.designation ) ) .. ']]\n' ..
                '|' .. t( 'val_direction_' .. string.lower( object.tunnel.direction ) ) .. '\n' ..
                '|' .. t( 'val_size_' .. string.lower( object.tunnel.size ) ) .. '\n' ..
                '|[[' .. stringUtil.clean( stringUtil.removeParentheses( exitObject.designation ) ) .. ']]\n'
        end
    end

    return wikitable .. '|}'
end

return JumpPoints
