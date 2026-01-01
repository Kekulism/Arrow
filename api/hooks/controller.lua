--Each of these are calculated per frame to pass along to the corresponding nodes for input handling
Controller.r_clicked = {target = nil, handled = true, prev_target = nil} --The node that was clicked this frame

--Input values to be determined by this controller - the actual game objects should not have to see any of this
Controller.r_cursor_down = {T = {x=0, y=0}, target = nil, time = 0, handled = true}
Controller.r_cursor_up = {T = {x=0, y=0}, target = nil, time = 0.1, handled = true}

local ref_r_cursor = Controller.queue_R_cursor_press
function Controller:queue_R_cursor_press(x, y)
    local ret = ref_r_cursor(self, x, y)

    if self.locks.frame then return end
    self.R_cursor_queue = {x = x, y = y}
    return ret
end

function Controller:R_cursor_press(x, y)
    x = x or self.cursor_position.x
    y = y or self.cursor_position.y

    if ((self.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (self.locks.frame) then return end

    self.r_cursor_down.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    self.r_cursor_down.time = G.TIMERS.TOTAL
    self.r_cursor_down.handled = false
    self.r_cursor_down.target = nil
    self.is_r_cursor_down = true

    local press_node = (self.HID.touch and self.cursor_hover.target) or self.hovering.target or self.focused.target

    if press_node then
        self.r_cursor_down.target = press_node.states.click.can and press_node or nil
    end

    if self.r_cursor_down.target == nil then
        self.r_cursor_down.target = G.ROOM
    end
end

local ref_love_mousereleased = love.mousereleased
function love.mousereleased(x, y, button)
    local ret = ref_love_mousereleased(x, y, button)
    if button == 2 then G.CONTROLLER:R_cursor_release(x, y) end
    return ret
end

function Controller:R_cursor_release(x, y)
    x = x or self.cursor_position.x
    y = y or self.cursor_position.y

    if ((self.locked) and (not G.SETTINGS.paused or G.screenwipe)) or (self.locks.frame) then return end

    self.r_cursor_up.T = {x = x/(G.TILESCALE*G.TILESIZE), y = y/(G.TILESCALE*G.TILESIZE)}
    self.r_cursor_up.time = G.TIMERS.TOTAL
    self.r_cursor_up.handled = false
    self.r_cursor_up.target = nil
    self.is_r_cursor_down = false

    self.r_cursor_up.target = self.hovering.target or self.focused.target

    if self.r_cursor_up.target == nil then
        self.r_cursor_up.target = G.ROOM
    end
end

--Called every game logic update frame
local ref_controller_update = Controller.update
function Controller:update(dt)
    local ret = ref_controller_update(self, dt)

    if self.R_cursor_queue then
        self:R_cursor_press(self.R_cursor_queue.x, self.R_cursor_queue.y)
        self.R_cursor_queue = nil
    end

    self.r_clicked.prev_target = self.r_clicked.target

    --Cursor is currently down
    if not self.r_cursor_down.handled then
        self.r_cursor_down.handled = true
    end

    if not self.r_cursor_up.handled then
        --Now, handle the Cursor release
        --Was the Cursor release in the same location as the Cursor press and within Cursor timeout?
        if self.r_cursor_down.target then
            if (not self.r_cursor_down.target.click_timeout or self.r_cursor_down.target.click_timeout*G.SPEEDFACTOR > self.r_cursor_up.time - self.r_cursor_down.time) then
                if Vector_Dist(self.r_cursor_down.T, self.r_cursor_up.T) < G.MIN_CLICK_DIST then
                    if self.r_cursor_down.target.states.click.can then
                        self.r_clicked.target = self.r_cursor_down.target
                        self.r_clicked.handled = false
                    end
                end
            end
        end
        self.r_cursor_up.handled = true
    end

    --The clicked object
    if not self.r_clicked.handled then
        self.r_clicked.target:r_click()
        self.r_clicked.handled = true
    end

    return ret
end

