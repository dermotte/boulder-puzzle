local easing = {}

--- Performs a linear interpolation with an ease-out quadratic effect.
--- @param a number - The starting value.
--- @param b number - The target value.
--- @param t number - The progress (0 to 1).
--- @return number - The interpolated value.
function easing.lerpEaseOut(a, b, t)
    t = math.max(0, math.min(1, t))
    local easedT = 1 - (1 - t) * (1 - t)
    return a + (b - a) * easedT
end

--- Performs a linear interpolation with an ease-in quadratic effect.
--- @param a number - The starting value.
--- @param b number - The target value.
--- @param t number - The progress (0 to 1).
--- @return number - The interpolated value.
function easing.lerpEaseIn(a, b, t)
    t = math.max(0, math.min(1, t))
    local easedT = t * t
    return a + (b - a) * easedT
end

--- Performs a linear interpolation with an ease-in-out quadratic effect.
--- @param a number - The starting value.
--- @param b number - The target value.
--- @param t number - The progress (0 to 1).
--- @return number - The interpolated value.
function easing.lerpEaseInOut(a, b, t)
    t = math.max(0, math.min(1, t))
    local easedT
    if t < 0.5 then
        easedT = 2 * t^2
    else
        easedT = 1 - (-2 * t + 2)^2 / 2
    end
    return a + (b - a) * easedT
end

--- Performs an interpolation between two values using the Ease-In-Out Back effect.
--- This causes the value to overshoot its start and end points slightly before settling.
--- @param a number - The starting value.
--- @param b number - The target value.
--- @param t number - The progress (0 to 1).
--- @return number - The interpolated value.
function easing.lerpEaseInOutBack(a, b, t)
    -- Clamp t between 0 and 1 to ensure stability
    t = math.max(0, math.min(1, t))

    local c1 = 1.70158
    local c2 = c1 * 1.525
    local easedT

    -- Calculate the eased progress (the "Back" curve)
    if t < 0.5 then
        easedT = ((2 * t)^2 * ((c2 + 1) * (2 * t) - c2)) / 2
    else
        easedT = (((2 * t - 2)^2 * ((c2 + 1) * (2 * t - 2) + c2)) + 2) / 2
    end

    -- Apply the eased progress to the range [a, b]
    return a + (b - a) * easedT
end

return easing
