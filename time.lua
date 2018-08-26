local obslua = obslua
local source_name
local format_string

local datetime = require'lib/datetime'
datetime.init(script_path())

local function update_text()
  local source = obslua.obs_get_source_by_name(source_name)

  if source ~= nil then
    local text = datetime.date(format_string)
    local settings = obslua.obs_data_create()
    obslua.obs_data_set_string(settings,"text",text)
    obslua.obs_source_update(source,settings)
    obslua.obs_data_release(settings)
    obslua.obs_source_release(source)
  end
end

script_tick = update_text


function script_description()
	return "Updates a text source with the current time."
end

function script_update(settings)
  source_name   = obslua.obs_data_get_string(settings, "source")
  format_string = obslua.obs_data_get_string(settings, "format_string")
end

function script_defaults(settings)
  obslua.obs_data_set_default_string(settings, "format_string", "%Y-%m-%d %H:%M:%S.%N")
end

function script_properties()
  local properties = obslua.obs_properties_create()
  local p = obslua.obs_properties_add_list(properties,"source","Text Source", obslua.OBS_COMBO_TYPE_EDITABLE, obslua.OBS_COMBO_FORMAT_STRING)
  local sources = obslua.obs_enum_sources()
  if sources then
    for _, source in ipairs(sources) do
      local s_id = obslua.obs_source_get_id(source)
      if s_id == "text_gdiplus" or s_id == "text_ft2_source" then
        local n = obslua.obs_source_get_name(source)
        obslua.obs_property_list_add_string(p,n,n)
      end
    end
    obslua.source_list_release(sources)
  end

  obslua.obs_properties_add_text(properties, "format_string", "Format String", obslua.OBS_TEXT_DEFAULT)

  return properties
end


