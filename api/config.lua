ArrowAPI.config_tools = {
    use_credits = function(mod, extra_args)
        mod.ARROW_USE_CREDITS = true
        extra_args = extra_args or {}
        local credit_table = {
            matrix = ArrowAPI.DEFAULT_CREDIT_MATRIX,
        }

        local use_default_sections = true

        for _, arg in ipairs(extra_args) do
            if arg.key then

                local contrib_table = {}
                for _, v in ipairs(arg.contributors or {}) do
                    local contrib = {
                        name = v.name,
                        name_colour = v.name_colour or G.C.UI.TEXT_LIGHT,
                        name_scale = v.name_scale or 1,
                        no_tooltip = v.no_tooltip
                    }
                    contrib_table[#contrib_table+1] = contrib
                end

                    credit_table[#credit_table+1] = {
                        key = arg.key,
                        title_colour = arg.title_colour or SMODS.current_mod.badge_colour,
                        pos_start = arg.pos_start,
                        pos_end = arg.pos_end,
                        contributors = contrib_table
                    }

                    for i, sec in ipairs(ArrowAPI.DEFAULT_CREDIT_SECTIONS) do
                        if arg.key == sec.key then
                            -- stop using default sections if we've defined
                            -- a default section with unique dimensions
                            if arg.pos_start or arg.pos_end then use_default_sections = false end

                            -- default sections cant change their keys for ease
                            credit_table[#credit_table].key = sec.key
                            break
                        elseif i == #ArrowAPI.DEFAULT_CREDIT_SECTIONS then
                            -- or if a section is not a default section entirely
                            use_default_sections = false
                        end
                    end
            end
        end

        -- create default sections
        if use_default_sections then
            sendDefaultMessage('setting default credit sections')
            -- check for already used sections with provided info
            local used_sections = {}
            for i, v in ipairs(credit_table) do
                used_sections[v.key] = true
            end

            -- fill in any default sections without provided information
            for i = 1, #ArrowAPI.DEFAULT_CREDIT_SECTIONS do
                local key = ArrowAPI.DEFAULT_CREDIT_SECTIONS[i].key
                if not used_sections[key] then
                    credit_table[#credit_table+1] = {
                        key = key,
                        title_colour = ArrowAPI.DEFAULT_CREDIT_SECTIONS[i].title_colour,
                        contributors = {}
                    }
                end
            end
            credit_table.use_default_sections = true
        end

        ArrowAPI['credits'][mod.id] = credit_table
    end,


    use_default_config = function(mod, extra_args)
        mod.ARROW_USE_CONFIG = mod.ARROW_USE_CONFIG or {config_map = {}}

        local s1, default_config = pcall(function()
            return load(NFS.read(mod.path..(mod.config_file or 'config.lua')), ('=[SMODS %s "default_config"]'):format(mod.id))()
        end)

        default_config = s1 and default_config or {}
        local overwrite = false
        if extra_args then
            for _, v in ipairs(extra_args) do
                if default_config[v.key] then overwrite = true end
                default_config[v.key] = (v.default_value == nil and false) or v.default_value

                local insert_idx = #mod.ARROW_USE_CONFIG
                if overwrite then
                    for i = 1, #mod.ARROW_USE_CONFIG do
                        local config = mod.ARROW_USE_CONFIG[i]
                        if config.key == v.key then
                            insert_idx = i
                            break
                        end
                    end
                end

                mod.ARROW_USE_CONFIG[insert_idx] = {
                    key = v.key,
                    value = default_config[v.key],
                    exclude_from_ui = v.exclude_from_ui,
                    before_auto = v.before_auto,
                    after_auto = not v.before_auto,
                    order = v.order
                }
                mod.ARROW_USE_CONFIG.config_map[v.key] = insert_idx
            end
        end

        -- create an ordered config based on initial config state
        for k, v in pairs(default_config) do
            if not mod.ARROW_USE_CONFIG.config_map[k] then
                table.insert(mod.ARROW_USE_CONFIG, {key = k, value = v})
            end
        end

        ArrowAPI.config_tools.sort_config(mod)
        ArrowAPI.config_tools.write_default_config(mod, default_config)

        -- ideally this will load any missing config stuff from the new default?
        SMODS.load_mod_config(mod)
    end,

    write_default_config = function(mod, config_table)
        local success = pcall(function()
            assert(next(config_table))
            local current_config = 'return '..serialize(config_table)
            NFS.write(mod.path..(mod.config_file or 'config.lua'), current_config)
        end)

        return success
    end,

    add_default_palette = function(mod, palette_set, palette_table, set_to_default)
        local s1, default_config = pcall(function()
            return load(NFS.read(mod.path..(mod.config_file or 'config.lua')), ('=[SMODS %s "default_config"]'):format(mod.id))()
        end)

        if not s1 then
            ArrowAPI.logging.warn('Default config not specified')
            return
        end

        if not default_config.saved_palettes then
            ArrowAPI.logging.warn('Tried to add a palette preset when none are specified')
            return
        end

        palette_table.default = true
        local insert_index = nil
        local palettes = default_config.saved_palettes[palette_set]
        for i, v in ipairs(palettes) do
            if v.name == palette_table.name then
                palettes[i] = palette_table
                break
            end

            if not v.default then
                insert_index = i
                table.insert(palettes, i, palette_table)
                break
            elseif i == #palettes then
                insert_index = i
                table.insert(palettes, i+1, palette_table)
                break
            end
        end

        if set_to_default and insert_index then
            palettes.saved_index = insert_index
            ArrowAPI.config.saved_palettes[palette_set].saved_index = insert_index
        end

        ArrowAPI.config_tools.write_default_config(mod, default_config)

        for i = #palettes, 1, -1 do
            local default_palette = palettes[i]
            if default_palette.default then
                local saved_palette = mod.config.saved_palettes[palette_set][i]
                if not saved_palette or not saved_palette.default or saved_palette.name ~= default_palette.name then
                    table.insert(mod.config.saved_palettes[palette_set], i, copy_table(default_palette))
                    break
                elseif saved_palette.name == default_palette.name then
                    mod.config.saved_palettes[palette_set][i] = copy_table(default_palette)
                    break
                end
            end
        end

        SMODS.save_mod_config(mod)
    end,

    sort_config = function(mod)
        if not mod.ARROW_USE_CONFIG then return end
        table.sort(mod.ARROW_USE_CONFIG, function(a, b)
            if a.before_auto and not b.before_auto then return true
            elseif b.before_auto and not a.before_auto then return false

            elseif not a.after_auto and b.after_auto then return true
            elseif not b.after_auto and a.after_auto then return false
            elseif not a.exclude_from_ui and b.exclude_from_ui then return true
            elseif not b.exclude_from_ui and a.exclude_from_ui then return false
            elseif a.order and b.order then return a.order < b.order
            else return false end
        end)

        for i, v in ipairs(mod.ARROW_USE_CONFIG) do
            mod.ARROW_USE_CONFIG.config_map[v.key] = i
        end
    end,

    update_config = function(mod, key, value, order, exclude_from_ui)
        mod.config[key] = value ~= nil and value or mod.config[key]
        if mod.ARROW_USE_CONFIG then
            if not mod.ARROW_USE_CONFIG.config_map[key] then
                table.insert(mod.ARROW_USE_CONFIG, {
                    key = key, value = mod.config[key], exclude_from_ui = exclude_from_ui, order = order
                })
                mod.ARROW_USE_CONFIG.config_map[key] = #mod.ARROW_USE_CONFIG

                ArrowAPI.config_tools.sort_config(mod)
                return
            end

            local index = mod.ARROW_USE_CONFIG.config_map[key]
            mod.ARROW_USE_CONFIG[index].value = value ~= nil and value or mod.ARROW_USE_CONFIG[index].value
            mod.ARROW_USE_CONFIG[index].order = order ~= nil and order or mod.ARROW_USE_CONFIG[index].order
            if exclude_from_ui then
                mod.ARROW_USE_CONFIG[index].exclude_from_ui = exclude_from_ui ~= nil and exclude_from_ui or mod.ARROW_USE_CONFIG[index].exclude_from_ui
            end
        end
    end
}