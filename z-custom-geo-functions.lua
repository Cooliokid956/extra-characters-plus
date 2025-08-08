-- Custom Geo Functions --

-- Sonic Spin/Ball Acts --

local sSonicSpinBallActs = {
    [ACT_SPIN_JUMP]        = true,
    [ACT_SPIN_DASH]        = true,
    [ACT_AIR_SPIN]         = true,
    [ACT_HOMING_ATTACK]    = true,
}

local sSonicSpinDashActs = {
    [ACT_SPIN_DASH_CHARGE] = true,
}

--- @param n GraphNode | FnGraphNode
--- Switches between the spin and ball models during a spin/ball actions
function geo_ball_switch(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
    if sSonicSpinBallActs[m.action] then
        switch.selectedCase = ((m.actionTimer - 1) % 4 // 2 + 1)
    elseif sSonicSpinDashActs[m.action] then
        switch.selectedCase = 3
    else
        switch.selectedCase = 0
    end
end

-- Mouth Switch --

--- @param n GraphNode | FnGraphNode
--- Switches the mouth state
function geo_switch_mario_mouth(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
end

-- Mouth Side Switch --

--- @param n GraphNode | FnGraphNode
--- Switches the side that the mouth is being displayed on
function geo_switch_mario_mouth_side(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
end

-- Wapeach Axe Acts --

local sWapeachAxeActs = {
    [ACT_AXE_CHOP]      = true,
    [ACT_AXE_SPIN]      = true,
    [ACT_AXE_SPIN_AIR]   = true,
    [ACT_AXE_SPIN_DIZZY] = true,
}

--- @param n GraphNode | FnGraphNode
--- Switches between normal hands and axe hands during axe actions
function geo_custom_hand_switch(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
    if sWapeachAxeActs[m.action] then
        switch.selectedCase = 1
    else
        switch.selectedCase = 0
    end
end

-- Donkey Kong Angry Acts --

local sDonkeyKongAngryActs = {}

--- @param n GraphNode | FnGraphNode
--- Switches between normal head and angry head during angry actions
function geo_custom_dk_head_switch(n)
    local switch = cast_graph_node(n)
    local m = geo_get_mario_state()
    if sDonkeyKongAngryActs[m.action] then
        switch.selectedCase = 1
    else
        switch.selectedCase = 0
    end
end
