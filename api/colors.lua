local ffi = require("ffi")
SMODS.Gradient({key = 'arrow_spectrans', colours = {HEX('F98899'), HEX('5BA6DD')}, cycle = 3.5, prefix_config = false })

local function collect_image_data(set, atlases)
    local data_table = {}
    local pixel_map = {}

    local atlas
    local file_data
    local image_data

    local ref_pointer
    local color_width
    local width_per_unit
    local colors_per_unit
    local obj
    local positions

    local color_key

    for k, v in pairs(atlases) do
        pixel_map[k] = {}
        atlas = SMODS.Atlases[k]
        file_data = NFS.newFileData(atlas.full_path)
        image_data = love.image.newImageData(file_data)
        data_table[k] = image_data

        ref_pointer = ffi.cast("uint8_t*", image_data:getFFIPointer())
        color_width = image_data:getWidth() * 4
        width_per_unit = atlas.px * G.SETTINGS.GRAPHICS.texture_scaling * 4
        colors_per_unit = width_per_unit * atlas.py * G.SETTINGS.GRAPHICS.texture_scaling

        for _, item in ipairs(v) do
            obj = G['P_'..item.table][item.key]
            positions = {[item.key] = obj.pos, [item.key..'_soul'] = obj.soul_pos or nil }
            for key, pos in pairs(positions) do

                local item_table = {pos_x = pos.x, pos_y = pos.y}
                for _, color in ipairs(ArrowAPI.colors.palettes[set].default_palette) do
                    item_table[color.key] = {}
                end

                for j = 0, (colors_per_unit - 1), 4 do
                    local true_idx = ((atlas.py * G.SETTINGS.GRAPHICS.texture_scaling * pos.y) * color_width + pos.x * width_per_unit) + ((j % (width_per_unit)) + (math.floor(j/(width_per_unit)) * color_width))
                    if ref_pointer[true_idx + 3] > 0 then
                        color_key = tostring(ref_pointer[true_idx]..'-'..ref_pointer[true_idx + 1]..'-'..ref_pointer[true_idx + 2])
                        if item_table[color_key] then
                            item_table[color_key][#item_table[color_key]+1] = true_idx
                        end
                    end
                end

                for kk, vv in pairs(item_table) do
                    if type(vv) == 'table' and not next(vv) then
                        item_table[kk] = nil
                    end
                end

                pixel_map[k][key] = item_table
            end
        end
    end

    return data_table, pixel_map
end

local set_order = {
    Joker = 1,
    Tarot = 2,
    Planet = 3,
    Spectral = 4,
    Voucher = 5,
    Booster = 6,
    Back = 7,
    Seal = 8,
    Cards = 9,
}

local ignore_states = {
    [G.STATES.TAROT_PACK] = true,
    [G.STATES.SPECTRAL_PACK] = true,
    [G.STATES.STANDARD_PACK] = true,
    [G.STATES.BUFFOON_PACK] = true,
    [G.STATES.PLANET_PACK] = true,
    [G.STATES.SMODS_BOOSTER_OPENED] = true
}

local alpha = 0.960433870103
local beta = 0.397824734759

local function amax_bmin(a, b)
    local abs_a, abs_b = math.abs(a), math.abs(b)
    local max = math.max(abs_a, abs_b)
    local min = math.min(abs_a, abs_b)

    return alpha*max + beta*min
end

ArrowAPI.colors = {
    palettes = {
        Background = {},
        Spectral = {},
        Planet = {},
        Tarot = {},
        Hearts = {},
        Spades = {},
        Diamonds = {},
        Clubs = {},
    },

    --- Caches the default image_data for all given palette sets
    --- @param set_list table | nil List of set keys for card types, i.e. "Tarot", "Planet"
    setup_palettes = function(set_list)
        -- background palette handled differently
        local bkg_palette = ArrowAPI.colors.palettes.Background
        local saved_bkg_palettes = ArrowAPI.config.saved_palettes['Background']
        bkg_palette.default_palette = saved_bkg_palettes[1]
        bkg_palette.current_palette = copy_table(saved_bkg_palettes[saved_bkg_palettes.saved_index])

        set_list = set_list or {"Tarot", "Planet", "Spectral", "Hearts", "Spades", "Diamonds", "Clubs"}
        for i = 1, #set_list do
            local set = set_list[i]
            local palette = ArrowAPI.colors.palettes[set]
            local items = {}

            local atlases = {}
            for k, v in pairs(G.P_CENTERS) do
                if not v.no_collection and (v.set == set or v.palette_set == set) and (not v.original_mod or (v.original_mod.optional_features or {}).arrow_palettes) then
                    if not atlases[v.atlas] then
                        atlases[v.atlas] = {}
                    end

                    atlases[v.atlas][#atlases[v.atlas]+1] = {key = k, table = 'CENTERS'}
                    items[#items+1] = {key = k, table = 'CENTERS', set = (v.set or v.palette_set)}
                end
            end

            for k, v in pairs(G.P_CARDS) do
                if not v.no_collection and v.suit == set and (not v.original_mod or (v.original_mod.optional_features or {}).arrow_palettes) then
                    local atlas = "arrow_"..string.lower(set)
                    if not atlases[atlas] then
                        atlases[atlas] = {}
                    end

                    atlases[atlas][#atlases[atlas]+1] = {key = k, table = 'CARDS'}
                    items[#items+1] = {key = k, table = 'CARDS', set = 'Card'}
                end
            end

            for k, v in pairs(G.P_TAGS) do
                if not v.no_collection and (v.set == set or v.palette_set == set) and (not v.original_mod or (v.original_mod.optional_features or {}).arrow_palettes) then
                    if not atlases[v.atlas] then
                        atlases[v.atlas] = {}
                    end

                    atlases[v.atlas][#atlases[v.atlas]+1] = {key = k, table = 'TAGS', set = 'Tag'}
                end
            end

            for k, v in pairs(G.P_SEALS) do
                if not v.no_collection and (v.set == set or v.palette_set == set) and (not v.original_mod or (v.original_mod.optional_features or {}).arrow_palettes) then
                    if not atlases[v.atlas] then
                        atlases[v.atlas] = {}
                    end

                    atlases[v.atlas][#atlases[v.atlas]+1] = {key = k, table = 'SEALS'}
                    items[#items+1] = {key = k, table = 'SEALS', set = 'Seal'}
                end
            end

            table.sort(items, function(a, b)
                local a_order = set_order[a.set] or 0
                local b_order = set_order[b.set] or 0
                if a_order ~= b_order then
                    return a_order < b_order
                end

                local a_item = G['P_'..a.table][a.key]
                local b_item = G['P_'..b.table][b.key]

                if a.table == 'CARDS' and b.table == 'CARDS' then
                    local a_rank = SMODS.Ranks[a_item.value]
                    local a_suit = SMODS.Suits[a_item.suit]
                    local b_rank = SMODS.Ranks[b_item.value]
                    local b_suit = SMODS.Suits[b_item.suit]
                    local a_nominal = 10*(a_rank.nominal or 0) + (a_suit.suit_nominal or 0) + 10*(a_rank.face_nominal or 0)
                    local b_nominal = 10*(b_rank.nominal or 0) + (b_suit.suit_nominal or 0) + 10*(b_rank.face_nominal or 0)
                    return a_nominal < b_nominal
                end

                return (a_item.order or 0) < (a_item.order or 0)
            end)

            palette.items = items
            palette.default_palette = ArrowAPI.config.saved_palettes[set][1]

            local atlas_table, pixel_map = collect_image_data(set, atlases)
            palette.image_data = {atlases = atlas_table, pixel_map = pixel_map}

            palette.current_palette = copy_table(ArrowAPI.config.saved_palettes[set][ArrowAPI.config.saved_palettes[set].saved_index])
        end
    end,

    set_background_color = function(args)
        local color_c = args.special_colour or args.new_colour
        local color_l = args.new_colour
        local color_d = args.tertiary_colour or args.new_colour
        local bright_c = 0.9
        local bright_l = 1.3
        local bright_d = 0.7
        if args.special_colour and args.tertiary_colour then
            bright_c = 1
            bright_l = 1
            bright_d = 1
        end

        G.C.BACKGROUND.C[1] = color_c[1]*bright_c - G.C.BACKGROUND.C[1]
        G.C.BACKGROUND.C[2] = color_c[2]*bright_c - G.C.BACKGROUND.C[2]
        G.C.BACKGROUND.C[3] = color_c[3]*bright_c - G.C.BACKGROUND.C[3]

        G.C.BACKGROUND.L[1] = color_l[1]*bright_l - G.C.BACKGROUND.L[1]
        G.C.BACKGROUND.L[2] = color_l[2]*bright_l - G.C.BACKGROUND.L[2]
        G.C.BACKGROUND.L[3] = color_l[3]*bright_l - G.C.BACKGROUND.L[3]

        G.C.BACKGROUND.D[1] = color_d[1]*bright_d - G.C.BACKGROUND.D[1]
        G.C.BACKGROUND.D[2] = color_d[2]*bright_d - G.C.BACKGROUND.D[2]
        G.C.BACKGROUND.D[3] = color_d[3]*bright_d - G.C.BACKGROUND.D[3]

        G.C.BACKGROUND.contrast = args.contrast - G.C.BACKGROUND.contrast
    end,

    use_custom_palette = function(set, saved_index)
        local palette = ArrowAPI.colors.palettes[set]
        if set == 'Background' then
            if saved_index then
                -- loading from saved palette
                ArrowAPI.config.saved_palettes[set].saved_index = saved_index
                SMODS.save_mod_config(ArrowAPI)

                local saved = ArrowAPI.config.saved_palettes[set][saved_index]
                local new_palette = {name = saved.name}
                for i = 1, #palette.default_palette do
                    local default = palette.default_palette[i]
                    local palette_table = {key = default.key, default = true, default.grad_pos, grad_config = copy_table(default.grad_config)}
                    for k = 1, #default do
                        palette_table[k] = default[k]
                    end
                    new_palette[i] = palette_table
                end

                for i = 1, #saved do
                    local cust_color = saved[i]
                    local default_color = new_palette[i]
                    if cust_color.key == default_color.key then
                        local palette_table = {key = default_color.key, default = true, grad_pos = copy_table(cust_color.grad_pos), grad_config = copy_table(cust_color.grad_config)}
                        for k = 1, #cust_color do
                            palette_table[k] = cust_color[k]
                        end
                        new_palette[i] = palette_table
                    end
                end

                palette.current_palette = new_palette
            end

            -- update background
            for i = 1, #palette.current_palette do
                local color = palette.current_palette[i]
                for j = 1, 3 do
                    G.C.BLIND[color.key][j] = color[j] and color[j]/255 or 1
                end
            end

            -- updating
            if G.GAME then
                if G.GAME.won then
                    ArrowAPI.colors.set_background_color({new_colour = G.C.BLIND.won, contrast = 1})
                else
                    local current_blind = G.GAME.blind and G.GAME.blind.config.blind
                    if G.STAGE == G.STAGES.MAIN_MENU or (current_blind and current_blind.boss and current_blind.boss.showdown) then
                        ArrowAPI.colors.set_background_color({new_colour = G.C.BLIND.SHOWDOWN_COL_2, special_colour = G.C.BLIND.SHOWDOWN_COL_1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3})
                    elseif not ignore_states[G.STATE] then
                        ArrowAPI.colors.set_background_color({new_colour = G.C.BLIND.Small, contrast = 1})
                    end
                end
            end

            return
        end


        local custom_palette = {}
        if not saved_index then
            -- updating current palette
            local badge = palette.current_palette[#palette.current_palette]
            local badge_table = G.C.SECONDARY_SET[set] or G.C.SUITS[set]
            if badge_table then
                badge_table[1] = badge[1]/255
                badge_table[2] = badge[2]/255
                badge_table[3] = badge[3]/255
                badge_table[4] = 1
            end

            for i=1, #palette.current_palette-1 do
                local last = palette.last_palette[i]
                local current = palette.current_palette[i]
                local default = palette.default_palette[i]
                local changed = false

                local grad_pos = {}
                for j = 1, #current.grad_pos do
                    if last.grad_pos[j] ~= current.grad_pos[j] then changed = true end
                    grad_pos[j] = current.grad_pos[j]
                end

                local grad_config = {pos = copy_table(current.grad_config.pos), mode = current.grad_config.mode, val = current.grad_config.val }
                if grad_config.pos[1] ~= last.grad_config.pos[1] or grad_config.pos[2] ~= last.grad_config.pos[2]
                or grad_config.mode ~= last.grad_config.mode or grad_config.val ~= last.grad_config.val then
                    changed = true
                end

                local palette_table = {key = default.key}

                for j=1, #current do
                    if current[j] ~= last[j] then changed = true end
                    palette_table[j] = current[j]
                end

                if changed then
                    palette_table.grad_pos = grad_pos
                    palette_table.grad_config = grad_config
                    custom_palette[#custom_palette+1] = palette_table
                    palette.last_palette[i] = copy_table(palette_table)
                end
            end
        else
            -- loading from saved palette
            ArrowAPI.config.saved_palettes[set].saved_index = saved_index
            SMODS.save_mod_config(ArrowAPI)

            custom_palette = ArrowAPI.config.saved_palettes[set][saved_index]
            local new_palette = {name = custom_palette.name}

            for i = 1, #palette.default_palette do
                local default = palette.default_palette[i]
                local palette_table = {key = default.key, grad_pos = copy_table(default.grad_pos), grad_config = copy_table(default.grad_config)}
                for j = 1, #default do
                    palette_table[j] = default[j]
                end
                new_palette[i] = palette_table
            end

            for i = 1, #custom_palette do
                local cust_color = custom_palette[i]
                local default_color = new_palette[i]
                if cust_color.key == default_color.key then
                    local palette_table = {key = default_color.key, grad_pos = copy_table(cust_color.grad_pos), grad_config = copy_table(cust_color.grad_config)}
                    for k = 1, #cust_color do
                        palette_table[k] = cust_color[k]
                    end

                    new_palette[i] = palette_table
                end
            end

            -- TODO // fix with grad pos
            local badge_table = G.C.SECONDARY_SET[set] or G.C.SUITS[set]
            if badge_table then
                badge_table[1] = new_palette[#new_palette][1]/255
                badge_table[2] = new_palette[#new_palette][2]/255
                badge_table[3] = new_palette[#new_palette][3]/255
                badge_table[4] = 1
            end

            palette.current_palette = new_palette
            palette.last_palette = copy_table(new_palette)
        end

        local rot
        local rot_max
        local lerp_val
        local angle
        local grad_pos
        local replace_color = {1, 1, 1}
        local idx
        local palette_color
        local color_list

        local edit_pointer
        local pixel_map
        local back
        local next
        local dist
        local center
        local x
        local y

        local width_per_unit

        for k, v in pairs(palette.image_data.atlases) do
            local atlas = SMODS.Atlases[k]

            color_width = v:getWidth() * 4
            width_per_unit = atlas.px * G.SETTINGS.GRAPHICS.texture_scaling * 4
            height_per_unit = atlas.py * G.SETTINGS.GRAPHICS.texture_scaling

            edit_pointer = ffi.cast("uint8_t*", v:getFFIPointer())
            pixel_map = palette.image_data.pixel_map[k]

            for i = 1, #custom_palette do
                for item, colors in pairs(pixel_map) do
                    -- todo add item filtering
                    color_list = colors[custom_palette[i].key]
                    if color_list then
                        palette_color = custom_palette[i]
                        for j = 1, #color_list do
                            idx = color_list[j]
                            replace_color[1] = palette_color[1]
                            replace_color[2] = palette_color[2]
                            replace_color[3] = palette_color[3]

                            if #palette_color.grad_pos > 1 then
                                angle = palette_color.grad_config.val
                                grad_pos = palette_color.grad_pos

                                local row_start = colors.pos_x * width_per_unit
                                local prev_rows = colors.pos_y * height_per_unit

                                x = (idx % color_width - row_start) / width_per_unit
                                y = (math.floor(idx / color_width) - prev_rows) / height_per_unit

                                if palette_color.grad_config.mode == 'linear' then
                                    -- value between 0 and pi/2 for the coord's x rotation
                                    rot = x * math.cos(angle) + y * math.sin(angle)
                                    rot_max = math.abs(math.cos(angle)) + math.abs(math.sin(angle))
                                    lerp_val = 0.5 * (rot/rot_max + 1)
                                    rot = nil
                                    rot_max = nil
                                else
                                    center = palette_color.grad_config.pos

                                    -- depending on benchmark, might not need this approx
                                    -- local dist = math.sqrt((center[2] - color_list[j].y)^2 + (center[1] - color_list[j].x)^2)
                                    dist = amax_bmin(center[2] - y, center[1] - x)
                                    lerp_val =  1 - math.min(1, math.max(0, (dist / palette_color.grad_config.val)))
                                end

                                for grad = 1, #grad_pos - 1 do
                                    if lerp_val <= grad_pos[grad+1] then
                                        lerp_val = (lerp_val - grad_pos[grad]) / (grad_pos[grad+1] - grad_pos[grad])

                                        back = (grad - 1) * 3
                                        next = grad * 3

                                        replace_color[1] = palette_color[back + 1] + lerp_val * (palette_color[next + 1] - palette_color[back + 1])
                                        replace_color[2] = palette_color[back + 2] + lerp_val * (palette_color[next + 2] - palette_color[back + 2])
                                        replace_color[3] = palette_color[back + 3] + lerp_val * (palette_color[next + 3] - palette_color[back + 3])
                                        break
                                    end
                                end
                            end

                            edit_pointer[idx] = replace_color[1]
                            edit_pointer[idx + 1] = replace_color[2]
                            edit_pointer[idx + 2] = replace_color[3]
                        end
                    end
                end
            end

            SMODS.Atlases[k].image = love.graphics.newImage(v,
                { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        end
    end,
}

local ref_type_colour = get_type_colour
function get_type_colour(_c, card)
    local ret = ref_type_colour(_c, card)

    if _c.unlocked and not card.debuff and ArrowAPI.colors.palettes[_c.set] then
        ret = ArrowAPI.colors.palettes[_c.set][0] or ret
    end

    return ret
end