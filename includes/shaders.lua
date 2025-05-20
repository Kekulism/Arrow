SMODS.Shader({ key = 'stand_aura', path = 'stand_aura.fs' })
SMODS.Atlas({ key = 'stand_blank', path = 'blank.png', px = 93, py = 179})
SMODS.Atlas({ key = 'stand_blank_evolved', path = 'blank_evolved.png', px = 93, py = 179})
SMODS.Atlas({ key = 'stand_noise', path = 'noise.png',  px = 128, py = 128})
SMODS.Atlas({ key = 'stand_gradient', path = 'gradient.png', px = 64, py = 64})
SMODS.Shader({key = 'stand_stand_mask', path = 'stand_mask.fs'})

local default_aura_target = 0.3

SMODS.DrawStep {
    key = 'stand_aura',
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

            --self.no_shadow = true

            -- aura flare in gameplay
            local flare_ease = 0
            if self.ability.aura_flare_direction > 0 then
                flare_ease = csau_ease_in_cubic(self.ability.aura_flare_lerp/(self.ability.aura_flare_target or default_aura_target))
            else
                flare_ease = csau_ease_out_quint(self.ability.aura_flare_lerp/(self.ability.aura_flare_target or default_aura_target))
            end


            local aura_spread = (flare_ease * 0.04) + self.ability.aura_spread

            -- colors
            local outline_color = HEX(self.ability.aura_colors[1])
            outline_color[4] = outline_color[4] * flare_ease
            local base_color = HEX(self.ability.aura_colors[2])
            base_color[4] = base_color[4] * flare_ease

            -- default tilt behavior
            local cursor_pos = {}
            cursor_pos[1] = self.tilt_var and self.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
            cursor_pos[2] = self.tilt_var and self.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
            local screen_scale = G.TILESCALE*G.TILESIZE*(self.children.center.mouse_damping or 1)*G.CANV_SCALE
            local hovering = (self.hover_tilt or 0)
            local seed = hashString(self.config.center.key..'_'..self.ID)

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
        if self.config.center.soul_pos and self.ability.set ~= 'arrow_Stand' and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

            if type(self.config.center.soul_pos.draw) == 'function' then
                self.config.center.soul_pos.draw(self, scale_mod, rotate_mod)
            elseif self.ability.name == 'Hologram' then
                self.hover_tilt = self.hover_tilt*1.5
                self.children.floating_sprite:draw_shader('hologram', nil, self.ARGS.send_to_shader, nil, self.children.center, 2*scale_mod, 2*rotate_mod)
                self.hover_tilt = self.hover_tilt/1.5
            else
                self.children.floating_sprite:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
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

SMODS.DrawStep {
    key = 'stand_mask',
    order = 39,
    func = function(self, layer)
        if self.config.center.soul_pos and self.ability.set == 'arrow_stand_Stand' and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2


            if self.ability.stand_mask then
                local stand_scale_mod = 0
                G.SHADERS['arrow_stand_mask']:send("scale_mod",scale_mod)
                G.SHADERS['arrow_stand_mask']:send("rotate_mod",rotate_mod)
                G.SHADERS['arrow_stand_mask']:send("output_scale",1+stand_scale_mod)

                self.children.floating_sprite:draw_shader('arrow_stand_mask', nil, nil, nil, self.children.center, -stand_scale_mod)
            else
                self.children.floating_sprite:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
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
    conditions = { vortex = false, facing = 'front' },
}

SMODS.DrawStep:take_ownership('stickers', {
    func = function(self, layer)
        if not G.arrow_shared_stand_stickers then
            G.arrow_shared_stand_stickers = {
                white = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 0,y = 0}),
                red = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 1,y = 0}),
                green = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 2,y = 0}),
                black = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 3,y = 0}),
                blue = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 4,y = 0}),
                purple = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 5,y = 0}),
                orange = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 6,y = 0}),
                gold = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["arrow_stickers"], {x = 7,y = 0})
            }
        end
        if self.sticker and G.shared_stickers[self.sticker] then
            if self.ability.set == "arrow_Stand" then
                G.arrow_shared_stand_stickers[self.sticker].role.draw_major = self
                G.arrow_shared_stand_stickers[self.sticker]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                G.arrow_shared_stand_stickers[self.sticker]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            else
                G.shared_stickers[self.sticker].role.draw_major = self
                G.shared_stickers[self.sticker]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                G.shared_stickers[self.sticker]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end

        elseif (self.sticker_run and G.shared_stickers[self.sticker_run]) and G.SETTINGS.run_stake_stickers then
            if self.ability.set == "arrow_Stand" then
                G.arrow_shared_stand_stickers[self.sticker_run].role.draw_major = self
                G.arrow_shared_stand_stickers[self.sticker_run]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                G.arrow_shared_stand_stickers[self.sticker_run]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            else
                G.shared_stickers[self.sticker_run].role.draw_major = self
                G.shared_stickers[self.sticker_run]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                G.shared_stickers[self.sticker_run]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
        end

        for k, v in pairs(SMODS.Stickers) do
            if self.ability[v.key] then
                if v and v.draw and type(v.draw) == 'function' then
                    v:draw(self, layer)
                else
                    if self.ability.set == "arrow_Stand" then
                        G.arrow_shared_stand_stickers[v.key].role.draw_major = self
                        G.arrow_shared_stand_stickers[v.key]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                        G.arrow_shared_stand_stickers[v.key]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
                    else
                        G.shared_stickers[v.key].role.draw_major = self
                        G.shared_stickers[v.key]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                        G.shared_stickers[v.key]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
                    end
                end
            end
        end
    end,
}, true)