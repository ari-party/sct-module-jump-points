local TNT = require( 'Module:Translate' ):new()
local config = mw.loadJsonData( 'Module:Jump points/config.json' )

local lang
if config.module_lang then
    lang = mw.getLanguage( config.module_lang )
else
    lang = mw.getContentLanguage()
end
local langCode = lang:getCode()

--- Wrapper function for Module:Translate.translate
---@param key string The translation key
---@param addSuffix? boolean Adds a language suffix if config.smw_multilingual_text is true
---@return string value If the key was not found in the .tab page, the key is returned
return function ( key, addSuffix, ... )
    return TNT:translate( 'Module:Jump points/i18n.json', config, key, addSuffix, { ... } ) or key
end
