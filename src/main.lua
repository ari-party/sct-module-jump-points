local JumpPoints = {}

local config = mw.loadJsonData( 'Module:Jump points/config.json' )
local Starmap = require( 'Module:Starmap' )
local t = require( 'translate' )
local stringUtil = require( 'utils.string' )

---@param page string
---@return boolean
local function exists( page )
    return not not mw.smw.ask( { page } )
end

---@param frame table https://www.mediawiki.org/wiki/Extension:Scribunto/Lua_reference_manual#Frame_object
function JumpPoints.main( frame )
    local parent = frame:getParent()
    local args = parent.args

    local systemName = args[ 1 ] or mw.ustring.gsub( mw.title.getCurrentTitle().text, ' system$', '' )
    if not systemName then return t( 'error_invalid_args' ) end

    local children = Starmap.systemObjects( systemName )
    if not children then return t( 'error_no_data' ) end

    local missingPages = false
    local hasJumppoints = false

    local wikitable = '{| class="wikitable"\n' ..
        '!' .. t( 'lbl_jumpgate' ) .. '\n' ..
        '!' .. t( 'lbl_direction' ) .. '\n' ..
        '!' .. t( 'lbl_size' ) .. '\n' ..
        '!' .. t( 'lbl_destination' ) .. '\n'

    for _, object in ipairs( children ) do
        if object.type == 'JUMPPOINT' then
            hasJumppoints = true

            local exitObject = object.tunnel.exit
            -- Make sure the exit is not the current object
            if exitObject.code == object.code then exitObject = object.tunnel.entry end

            local exitLink = '[[' .. stringUtil.clean( stringUtil.removeParentheses( exitObject.designation ) ) .. ']]'

            if not missingPages then missingPages = not exists( exitLink ) end

            wikitable = wikitable .. '|-\n' ..
                -- From this system
                '|[[' .. stringUtil.clean( stringUtil.removeParentheses( object.designation ) ) .. ']]\n' ..
                -- Direction
                '|' .. t( 'val_direction_' .. mw.ustring.lower( object.tunnel.direction ) ) .. '\n' ..
                -- Size
                '|' .. t( 'val_size_' .. mw.ustring.lower( object.tunnel.size ) ) .. '\n' ..
                -- Path to target system's gate
                '|' .. exitLink .. ', ' ..
                stringUtil.lowerFirst(
                    stringUtil.clean(
                        Starmap.inSystem(
                            Starmap.findStructure( 'system',
                                Starmap.findStructure( 'object', exitObject.code ).star_system.code
                            )
                        )
                    )
                ) .. '\n'
        end
    end

    wikitable = wikitable .. '|}'

    if missingPages and config.missing_jumppoint_category then
        wikitable = wikitable .. '[[Category:' .. config.missing_jumppoint_category .. ']]'
    end

    if hasJumppoints then
        return wikitable
    else
        return mw.ustring.format( t( 'lbl_none' ), systemName )
    end
end

function JumpPoints.test( page )
    return JumpPoints.main( {
        getParent = function ()
            return {
                args = { page }
            }
        end
    } )
end

return JumpPoints
