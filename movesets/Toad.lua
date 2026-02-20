function toad_before_phys_step(m)
    local hScale = 1.0
    local vScale = 1.0

    -- faster ground movement
    if (m.action & ACT_FLAG_MOVING) ~= 0 then
        hScale = hScale * 1.19
    end

    -- slower holding item
    if m.heldObj then
        m.vel.y = m.vel.y - 2.0
        hScale = hScale * 0.9
        if (m.action & ACT_FLAG_AIR) ~= 0 then
            hScale = hScale * 0.9
        end
    end

    m.vel.x = m.vel.x * hScale
    m.vel.y = m.vel.y * vScale
    m.vel.z = m.vel.z * hScale
end

function toad_on_set_action(m)
    local e = gCharacterStates[m.playerIndex].toad

    -- wall kick height based on how fast toad is going
    if m.action == ACT_WALL_KICK_AIR and m.prevAction ~= ACT_HOLDING_POLE and m.prevAction ~= ACT_CLIMBING_POLE then
        m.vel.y = m.vel.y * 0.5 + e.averageForwardVel * 0.7
        return
    end

    -- more distance on dive and long jump
    if m.action == ACT_DIVE or m.action == ACT_LONG_JUMP then
        m.forwardVel = m.forwardVel * 1.35
    end

    -- less height on jumps
    if m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP or m.action == ACT_SPECIAL_TRIPLE_JUMP or m.action == ACT_STEEP_JUMP or m.action == ACT_RIDING_SHELL_JUMP or m.action == ACT_BACKFLIP or m.action == ACT_WALL_KICK_AIR  or m.action == ACT_LONG_JUMP then
        m.vel.y = m.vel.y * 0.8

        -- prevent from getting stuck on platform
        if m.marioObj.platform then
            m.pos.y = m.pos.y + 10
        end
    elseif m.action == ACT_SIDE_FLIP then
        m.vel.y = m.vel.y * 0.86

        -- prevent from getting stuck on platform
        if m.marioObj.platform then
            m.pos.y = m.pos.y + 10
        end
    end
end

function toad_update(m)
    local e = gCharacterStates[m.playerIndex].toad

    -- track average forward velocity
    if e.averageForwardVel > m.forwardVel then
        e.averageForwardVel = e.averageForwardVel * 0.93 + m.forwardVel * 0.07
    else
        e.averageForwardVel = m.forwardVel
    end

    -- keep your momentum for a while
    if m.action == ACT_WALKING and m.forwardVel > 30 then
        mario_set_forward_vel(m, m.forwardVel + 0.8)
    end

    -- faster flip during ground pound
    if m.action == ACT_GROUND_POUND then
        if m.actionTimer < 10 then
            m.actionTimer = m.actionTimer + 1
        end
    end

    -- ground pound jump
    if m.action == ACT_GROUND_POUND_LAND and (m.input & INPUT_A_PRESSED) ~= 0 then
        set_mario_action(m, ACT_TRIPLE_JUMP, 0)
        m.vel.y = m.vel.y + 18
        m.forwardVel = m.forwardVel + 10
    end

end

return {
    { HOOK_MARIO_UPDATE, toad_update },
    { HOOK_BEFORE_PHYS_STEP, toad_before_phys_step },
    { HOOK_ON_SET_MARIO_ACTION, toad_on_set_action }
}