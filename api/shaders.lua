local arrow_path = ArrowAPI.path..(ArrowAPI.custom_path or '')
SMODS.Shader({ key = 'arrow_stand_aura', custom_path = arrow_path, path = 'stand_aura.fs', prefix_config = false })
SMODS.Shader({ key = 'arrow_stand_mask', custom_path = arrow_path, path = 'stand_mask.fs', prefix_config = false })
SMODS.Shader({ key = 'arrow_stand_hue', custom_path = arrow_path, path = 'stand_hue.fs', prefix_config = false })
SMODS.Shader({key = 'arrow_ui_poly', custom_path = arrow_path, path = 'ui_poly.fs', prefix_config = false})
SMODS.Shader({key = 'arrow_rgb_slider', custom_path = arrow_path, path = 'rgb_slider.fs', prefix_config = false})
SMODS.Shader({key = 'arrow_button_grad', custom_path = arrow_path, path = 'button_grad.fs', prefix_config = false})
SMODS.Shader({key = 'arrow_palette_outline', custom_path = arrow_path, path = 'palette_outline.fs', prefix_config = false})
SMODS.Shader({key = 'arrow_vhs', custom_path = arrow_path, path = 'vhs.fs', prefix_config = false})
SMODS.Atlas({ key = 'arrow_stand_noise', custom_path = arrow_path, path = 'noise.png',  px = 128, py = 128, prefix_config = false})
SMODS.Atlas({ key = 'arrow_stand_gradient', custom_path = arrow_path, path = 'gradient.png', px = 64, py = 64, prefix_config = false})
SMODS.Atlas({ key = 'arrow_blackspine', custom_path = arrow_path, path = 'blackspine.png', px = 71, py = 95, prefix_config = false})
SMODS.Shader({ key = 'vhs', custom_path = arrow_path, path = 'vhs.fs', prefix_config = false })





---------------------------
--------------------------- Stand Shaders
---------------------------

local default_aura_target = 0.3
SMODS.DrawStep {
    key = 'arrow_stand_aura',
    prefix_config = {key = {mod = false}},
    order = -110,
    func = function(self)
        if self.children.stand_aura and (self.config.center.discovered or self.bypass_discovery_center) then
            if self.ability.aura_flare_queued then
                self.ability.aura_flare_queued = false

                if not self.ability.stand_activated then
                    self.ability.aura_flare_lerp = 0.0
                end

                self.ability.stand_activated = true
                self.ability.aura_flare_direction = 1
                self.ability.flare_rise = self.ability.aura_flare_target or default_aura_target
            end

            if self.ability.stand_activated then
                -- lerping the values
                if self.ability.aura_flare_direction > 0 and self.ability.aura_flare_lerp < (self.ability.aura_flare_target or default_aura_target) then
                    self.ability.aura_flare_lerp = self.ability.aura_flare_lerp + G.real_dt
                    self.ability.flare_rise = self.ability.flare_rise - G.real_dt
                    if self.ability.aura_flare_lerp >= (self.ability.aura_flare_target or default_aura_target) then
                        if self.ability.aura_flare_target then
                            self.ability.aura_flare_direction = -1
                        else
                            self.ability.aura_flare_lerp = default_aura_target
                        end
                    end
                end

                if self.ability.aura_flare_target and self.ability.aura_flare_direction < 0 then
                    -- hang longer on max if it took less time to reach max
                    if self.ability.flare_rise > 0 then
                        self.ability.flare_rise = self.ability.flare_rise - G.real_dt
                        if self.ability.flare_rise < 0 then
                            self.ability.flare_rise = 0
                        end
                    elseif self.ability.aura_flare_lerp > 0 then
                        self.ability.aura_flare_lerp = self.ability.aura_flare_lerp - G.real_dt
                        if self.ability.aura_flare_lerp <= 0 then
                            self.ability.aura_flare_lerp = nil
                            self.ability.aura_flare_direction = nil
                        end
                    end

                    if self.ability.aura_flare_lerp == nil then
                        self.ability.stand_activated = nil
                    end
                end
            end

            if not self.ability.stand_activated then
                self.no_shadow = false
                return
            end

            self.no_shadow = true

            -- aura flare in gameplay
            local flare_ease = 0
            if self.ability.aura_flare_direction > 0 then
                flare_ease = ArrowAPI.math.ease_funcs.in_cubic(self.ability.aura_flare_lerp/(self.ability.aura_flare_target or default_aura_target))
            else
                flare_ease = ArrowAPI.math.ease_funcs.out_quint(self.ability.aura_flare_lerp/(self.ability.aura_flare_target or default_aura_target))
            end


            local aura_spread = (flare_ease * 0.04) + self.ability.aura_spread

            -- colors
            local outline_color = {
                self.ability.aura_colors[1][1],
                self.ability.aura_colors[1][2],
                self.ability.aura_colors[1][3],
                self.ability.aura_colors[1][4] * flare_ease,
            }

            local base_color = {
                self.ability.aura_colors[2][1],
                self.ability.aura_colors[2][2],
                self.ability.aura_colors[2][3],
                self.ability.aura_colors[2][4] * flare_ease,
            }

            -- default tilt behavior
            local cursor_pos = {}
            cursor_pos[1] = self.tilt_var and self.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
            cursor_pos[2] = self.tilt_var and self.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
            local screen_scale = G.TILESCALE*G.TILESIZE*(self.children.center.mouse_damping or 1)*G.CANV_SCALE
            local hovering = (self.hover_tilt or 0)
            local seed = ArrowAPI.math.hash_string(self.config.center.key..'_'..self.ID)

            G.SHADERS['arrow_stand_aura']:send('step_size', {0.021, 0.021})
            G.SHADERS['arrow_stand_aura']:send('time', G.TIMERS.REAL)
            G.SHADERS['arrow_stand_aura']:send('aura_rate', 1)
            G.SHADERS['arrow_stand_aura']:send('noise_tex', G.ASSET_ATLAS['arrow_stand_noise'].image)
            G.SHADERS['arrow_stand_aura']:send('gradient_tex', G.ASSET_ATLAS['arrow_stand_gradient'].image)
            G.SHADERS['arrow_stand_aura']:send('outline_color', outline_color)
            G.SHADERS['arrow_stand_aura']:send('base_color', base_color)
            G.SHADERS['arrow_stand_aura']:send('mouse_screen_pos', cursor_pos)
            G.SHADERS['arrow_stand_aura']:send('screen_scale', screen_scale)
            G.SHADERS['arrow_stand_aura']:send('hovering', hovering)
            G.SHADERS['arrow_stand_aura']:send('spread', aura_spread)
            G.SHADERS['arrow_stand_aura']:send('seed', seed)
            love.graphics.setShader(G.SHADERS['arrow_stand_aura'], G.SHADERS['arrow_stand_aura'])
            self.children.stand_aura:draw_self()
            love.graphics.setShader()
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.DrawStep:take_ownership('floating_sprite', {
    func = function(self, layer)
        if self.config.center.soul_pos and self.ability.set ~= 'Stand' and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

            if type(self.config.center.soul_pos.draw) == 'function' then
                self.config.center.soul_pos.draw(self, scale_mod, rotate_mod)
            elseif self.ability.name == 'Hologram' then
                self.hover_tilt = self.hover_tilt*1.5
                self.children.floating_sprite:draw_shader('hologram', nil, self.ARGS.send_to_shader, nil, self.children.center, 2*scale_mod, 2*rotate_mod)
                self.hover_tilt = self.hover_tilt/1.5
            else
                if not self.config.center.no_soul_shadow then
                    self.children.floating_sprite:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
                end
                self.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
            end

            if self.edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if v.apply_to_float then
                        if self.edition[v.key:sub(3)] then
                            self.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                        end
                    end
                end
            end
        end
    end,
}, true)

local function unique_lerp(hash_string)
    local hash = 5381  -- Seed value
    for i = 1, #hash_string do
        local char = string.byte(hash_string, i)
        hash = ((hash * 32) + hash + char) % 2^15  -- Wrap to 16-bit integer
    end

    return hash / (2^15)
end

SMODS.DrawStep {
    key = 'arrow_stand_mask',
    prefix_config = {key = {mod = false}},
    order = 39,
    func = function(self, layer)
        if self.config.center.soul_pos and self.ability.set == 'Stand' and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod = (self.config.center.stand_scale_mod or 1)*0.07 + (self.config.center.stand_scale_mod or 1)*0.02*math.sin(1.8*G.TIMERS.REAL)
            local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

            local hue_mod = G.GAME.stand_hue_mod or 0
            if hue_mod ~= 0 then
                hue_mod = (G.GAME.stand_hue_mod + (unique_lerp(self.config.center.key) * 360) + 50) % 360
            end


            if self.ability.stand_mask then
                local stand_scale_mod = 0
                G.SHADERS['arrow_stand_mask']:send("scale_mod",scale_mod)
                G.SHADERS['arrow_stand_mask']:send("rotate_mod",rotate_mod)
                G.SHADERS['arrow_stand_mask']:send("vertex_scale_mod", self.config.center.config.vertex_scale_mod or 1.0)
                G.SHADERS['arrow_stand_mask']:send("shadow_strength", self.config.center.config.stand_shadow or 0.33)


                G.SHADERS['arrow_stand_mask']:send('hue_mod', hue_mod)
                self.children.floating_sprite:draw_shader('arrow_stand_mask', nil, nil, nil, self.children.center, -stand_scale_mod)
            else
                G.SHADERS['arrow_stand_hue']:send('hue_mod', hue_mod)
                self.children.floating_sprite:draw_shader('arrow_stand_hue', 0, nil, nil, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
                self.children.floating_sprite:draw_shader('arrow_stand_hue', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
            end

            if self.edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if v.apply_to_float then
                        if self.edition[v.key:sub(3)] then
                            self.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                        end
                    end
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

function scale_sticker(sticker, card)
    if not sticker or not card then
        return nil, nil
    end

    if sticker.atlas.px ~= card.children.center.atlas.px and sticker.atlas.py ~= card.children.center.atlas.px then
        local x_scale = sticker.atlas.px / card.children.center.atlas.px
        local y_scale = sticker.atlas.py / card.children.center.atlas.py
        local t = {w = card.T.w, h = card.T.h}
        local vt = {w = card.VT.w, h = card.VT.h}
        card.T.w  = sticker.T.w * x_scale
        card.VT.w = sticker.T.w * x_scale
        card.T.h = sticker.T.h * y_scale
        card.VT.h = sticker.T.h * y_scale
        return t, vt
    end
    return nil, nil
end

function reset_sticker_scale(card, t, vt)
    if not t and not vt then return end
    card.T.w = t and t.w or G.CARD_W
    card.VT.w = vt and vt.w or G.CARD_W
    card.T.h = t and t.h or G.CARD_H
    card.VT.h = vt and vt.h or G.CARD_H
end

local old_sticker_func = SMODS.DrawSteps.stickers.func
SMODS.DrawStep:take_ownership('stickers', {
    func = function(self, layer)
        if self.ability.set ~= 'Stand' then
            return old_sticker_func(self, layer)
        end

        if self.sticker and G.sticker_map['arrow_Stand_'..self.sticker] then
            local key = 'arrow_Stand_'..self.sticker
            local t, vt = scale_sticker(G.shared_stickers[key], self)
            G.shared_stickers[key].role.draw_major = self
            G.shared_stickers[key]:draw_shader('dissolve', nil, nil, nil, self.children.center)
            G.shared_stickers[key]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            reset_sticker_scale(self, t, vt)
        elseif G.SETTINGS.run_stake_stickers and self.sticker_run and G.shared_stickers[self.sticker_run] then
            local key = G.shared_stickers['arrow_Stand_'..self.sticker_run] and 'arrow_Stand_'..self.sticker_run or self.sticker_run
            local t, vt = scale_sticker(G.shared_stickers[key], self)
            G.shared_stickers[key].role.draw_major = self
            G.shared_stickers[key]:draw_shader('dissolve', nil, nil, nil, self.children.center)
            G.shared_stickers[key]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            reset_sticker_scale(self, t, vt)
        end

        for _, v in pairs(SMODS.Stickers) do
            if self.ability[v.key] then
                if v and v.draw and type(v.draw) == 'function' then
                    v:draw(self, layer)
                else
                    local mod_key = G.shared_stickers['arrow_Stand_'..v.key] and 'arrow_Stand_'..v.key or v.key
                    local t, vt = scale_sticker(G.shared_stickers[mod_key], self)
                    G.shared_stickers[mod_key].role.draw_major = self
                    G.shared_stickers[mod_key]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                    G.shared_stickers[mod_key]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
                    reset_sticker_scale(self, t, vt)
                end
            end
        end
    end,
}, true)




---------------------------
--------------------------- VHS slide shader
---------------------------

local slide_mod = 12
local slide_out_delay = 0.05
local width_factor = 0.1

local old_center_ds = SMODS.DrawSteps.center.func
SMODS.DrawStep:take_ownership('center', {
    func = function(self, layer)
        if self.ability.set == 'Stand' then
            if not self.config.center.discovered and not self.config.center.demo and not self.bypass_discovery_center then
                return old_center_ds(self, layer)
            end

            --Draw the main part of the card
            if (self.edition and self.edition.negative and (not self.delay_edition or self.delay_edition.negative)) then
                self.children.center:draw_shader('negative', nil, self.ARGS.send_to_shader)
            elseif not self:should_draw_base_shader() then
                -- Don't render base dissolve shader.
            elseif not self.greyed then
                local hue_mod = G.GAME.stand_hue_mod or 0
                if hue_mod ~= 0 then
                    hue_mod = (G.GAME.stand_hue_mod + unique_lerp(self.config.center.key) * 360) % 360
                end
                G.SHADERS['arrow_stand_hue']:send('hue_mod', hue_mod)
                self.children.center:draw_shader('arrow_stand_hue')
            end

            local center = self.config.center
            if center.draw and type(center.draw) == 'function' then
                center:draw(self, layer)
            end

        elseif self.ability.set ~= 'VHS' then
            return old_center_ds(self, layer)
        end
    end
})

SMODS.DrawStep {
    key = 'vhs_slide',
    order = -1,
    func = function(self, layer)
        if self.ability.set ~= 'VHS' or (self.area and self.area.config.collection and not self.config.center.discovered) then
            --If the card is not yet discovered
            if not self.config.center.discovered and self.ability.set == 'VHS' then

                local shared_sprite = G.shared_undiscovered_tarot
                local scale_mod = -0.05 + 0.05*math.sin(1.8*G.TIMERS.REAL)
                local rotate_mod = 0.03*math.sin(1.219*G.TIMERS.REAL)

                self.children.center:draw_shader('dissolve', self.shadow_height)
	            self.children.center:draw_shader('dissolve')
                shared_sprite.role.draw_major = self
                if (self.config.center.undiscovered and not self.config.center.undiscovered.no_overlay) or not( SMODS.UndiscoveredSprites[self.ability.set] and SMODS.UndiscoveredSprites[self.ability.set].no_overlay) then
                    shared_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                else
                    if SMODS.UndiscoveredSprites[self.ability.set] and SMODS.UndiscoveredSprites[self.ability.set].overlay_sprite then
                        SMODS.UndiscoveredSprites[self.ability.set].overlay_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                    end
                end
            end

            return
        end

        if not self.ability.slide_move or not self.ability.slide_out_delay then
            self.ability.slide_move = 0
            self.ability.slide_out_delay = 0
        end

        if self.ability.activated and self.ability.slide_move < 1 then
            if self.ability.slide_out_delay < slide_out_delay then
                self.ability.slide_out_delay = self.ability.slide_out_delay + (slide_mod * G.real_dt)
            else
                self.ability.slide_move = self.ability.slide_move + (slide_mod * G.real_dt)
                if self.ability.slide_move > 1 then
                    self.ability.slide_move = 1
                end
            end
        elseif not self.ability.activated and self.ability.slide_move > 0 then
            self.ability.slide_out_delay = 0
            self.ability.slide_move = self.ability.slide_move - (slide_mod * G.real_dt)

            if self.ability.slide_move < 0 then
                self.ability.slide_move = 0
                self.children.center.VT.w = self.T.w
            end

        end

        if self.ability.slide_move <= 0 then
            self.shadow_height = self.states.drag.is and 0.35 or 0.1
            self.children.center:draw_shader('dissolve', self.shadow_height)
	        self.children.center:draw_shader('dissolve')
            return
        end

        -- adjusting the width to match the shader change
        if not self.children.center.pinch.x then
            self.children.center.VT.x = self.T.x - width_factor * self.ability.slide_move * 2
            self.children.center.VT.w = (self.T.w * width_factor * self.ability.slide_move) + self.T.w
        end

        -- default tilt behavior
        G.SHADERS['arrow_vhs']:send('spine', G.ASSET_ATLAS['arrow_blackspine'].image)
        G.SHADERS['arrow_vhs']:send('lerp', self.ability.slide_move)

        self.shadow_height = self.states.drag.is and 0.35 or 0.1
        self.children.center:draw_shader('arrow_vhs', self.shadow_height)
	    self.children.center:draw_shader('arrow_vhs', nil)

        local center = self.config.center
        if center.draw and type(center.draw) == 'function' then
            center:draw(self, layer)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}


--- for palette override backgrounds
SMODS.DrawStep ({
    key = 'arrow_palette_override',
    prefix_config = {key = {mod = false}},
    order = 91,
    func = function(self, layer)
        if self.arrow_palette_outline then
            local cursor_pos = {}
            cursor_pos[1] = self.tilt_var and self.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
            cursor_pos[2] = self.tilt_var and self.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
            local screen_scale = G.TILESCALE*G.TILESIZE*(self.children.center.mouse_damping or 1)*G.CANV_SCALE
            local hovering = (self.hover_tilt or 0)

            G.SHADERS['arrow_palette_outline']:send('step_size', {3, 3})
            G.SHADERS['arrow_palette_outline']:send('time', G.TIMERS.REAL)
            G.SHADERS['arrow_palette_outline']:send("texture_details", self.children.center:get_pos_pixel())
            G.SHADERS['arrow_palette_outline']:send("image_details", self.children.center:get_image_dims())
            G.SHADERS['arrow_palette_outline']:send('outline_color', {0.7, 0.36, 1, 1})
            G.SHADERS['arrow_palette_outline']:send('mouse_screen_pos', cursor_pos)
            G.SHADERS['arrow_palette_outline']:send('screen_scale', screen_scale)
            G.SHADERS['arrow_palette_outline']:send('hovering', hovering)
            love.graphics.setShader(G.SHADERS['arrow_palette_outline'], G.SHADERS['arrow_palette_outline'])
            self.children.center:draw_self()
            love.graphics.setShader()
        end
    end,
    conditions = { vortex = false, facing = 'front' },
})