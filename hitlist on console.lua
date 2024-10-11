---@diagnostic disable
    --#region: Setup
    local shots_counter = 0
    
    local e_damagegroup = {
        [0] = 'head',
        [1] = 'chest',
        [2] = 'stomach',
        [3] = 'arm',
        [4] = 'leg',
    }
    
    local misses_color = {
        ['death'] = '202020',
        ['player death'] = '505050',
        ['spread'] = 'f6ffa4',
        ['correction'] = 'ffa4a5',
        ['occlusion'] = 'f6ffa4',
        ['prediction error'] = 'a4caff',
        ['lagcomp failure'] = 'a4caff',
        ['unknown'] = 'ffa4a5',
        ['unregistered shot'] = 'ffa4a5',
        ['damage rejection'] = 'ffa4a5',
    }
    --#endregion
    --#region: Extensions
    local color_extension; do
        local color_mt = getmetatable(color());
    
        function color_mt:unpack()
            return self.r, self.g, self.b, self.a
        end
    
        function color_mt:to_hex()
            return string.format("%02x%02x%02x%02x", self:unpack())
        end
    end
    
    function string.rgba(hex)
        hex = hex:gsub("#", "");
    
        local r = tonumber(hex:sub(1, 2), 16);
        local g = tonumber(hex:sub(3, 4), 16);
        local b = tonumber(hex:sub(5, 6), 16);
        local a = tonumber(hex:sub(7, 8), 16) or 1;
    
        return r * 255, g * 255, b * 255, a * 255;
    end
    --#endregion
    --#region: Misc functions
    local function get_english_ordinal_suffix(number)
        local last_digit = number % 10
        local last_two_digits = number % 100
    
        if last_two_digits >= 11 and last_two_digits <= 13 then
            return "th"
        elseif last_digit == 1 then
            return "st"
        elseif last_digit == 2 then
            return "nd"
        elseif last_digit == 3 then
            return "rd"
        else
            return "th"
        end
    end
    
    local function interpolateColor(t)
        local redHue = 0
        local greenHue = 120
        local hue = (1 - t) * redHue + t * greenHue
        local saturation = 1
        local value = 1
    
        local chroma = value * saturation
        local hueSegment = hue / 60
        local x = chroma * (1 - math.abs(hueSegment % 2 - 1))
        local r, g, b
    
        if hueSegment >= 0 and hueSegment < 1 then
            r, g, b = chroma, x, 0
        elseif hueSegment >= 1 and hueSegment < 2 then
            r, g, b = x, chroma, 0
        elseif hueSegment >= 2 and hueSegment < 3 then
            r, g, b = 0, chroma, x
        elseif hueSegment >= 3 and hueSegment < 4 then
            r, g, b = 0, x, chroma
        elseif hueSegment >= 4 and hueSegment < 5 then
            r, g, b = x, 0, chroma
        else
            r, g, b = chroma, 0, x
        end
    
        local m = value - chroma
        r, g, b = r + m, g + m, b + m
    
        local red = math.floor(r * 255)
        local green = math.floor(g * 255)
        local blue = math.floor(b * 255)
    
        return color(red, green, blue)
    end
    --#endregion
    --#region: Renderer library
    local renderer = {}; do
        local fraction = 1 / 255;
    
        local concat = function(...)
            local args = { ... };
            for i in ipairs(args) do
                args[i] = tostring(args[i]);
            end
    
            return table.concat(args);
        end
    
        function renderer.measure_text(font, ...)
            local text = concat(...);
    
            return render.measure_text(font, text:gsub("\a(%x%x%x%x%x%x%x%x)", ""):gsub("\adefault", ""));
        end
    
        local function render_text(font, pos, clr, flags, text)
            local r, g, b, a = clr.r, clr.g, clr.b, clr.a;
    
            local position = vector(pos.x, pos.y);
    
            if text:find("\a") then
                for pattern in string.gmatch(text, "\a?[^\a]+") do
                    local default_text = pattern:match("^\adefault(.-)$")
    
                    if default_text ~= nil then
                        render.text(font, position, color(r, g, b, a), flags, default_text)
                        position.x = position.x + renderer.measure_text(font, default_text).x
                    else
                        local clr, text = pattern:match("^\a(%x%x%x%x%x%x%x%x)(.-)$")
    
                        if clr ~= nil then
    
                            local r, g, b, a = string.rgba(clr)
                            r = r * fraction
                            g = g * fraction
                            b = b * fraction
                            a = a * fraction
                            render.text(font, position, color(r, g, b, a), flags, text)
                            position.x = position.x + renderer.measure_text(font, text).x
                        else
                            render.text(font, position, color(r, g, b, a), flags, pattern)
                            position.x = position.x + renderer.measure_text(font, pattern).x
                        end
                    end
                end
    
                return
            end
    
            return render.text(font, position, clr, flags, text)
        end
    
        function renderer.text(font, position, clr, flags, ...)
            local text = concat(...);
    
            local position = vector(position.x, position.y);
    
            render_text(font, position, clr, flags, text);
        end
    end
    --#endregion
    --#region: Notify library
    local notify = { data = {}, font = render.load_font("Verdana", 13, ""), white = color() }; do
        function math.lerp(a, b, t)
            return a + t * (b - a);
        end
    
        notify.add = function(time, text)
            notify.data[#notify.data + 1] = {
                end_time = common.get_unix_time() + time,
                text = text,
                animation = 0,
            }
        end
    
        notify.handler = function()
            local offset = 0
            local unix_time = common.get_unix_time()
    
            for index = 1, #notify.data do
                local note = notify.data[index]
    
                local alive = unix_time <= note.end_time
                local alpha = note.animation * 255
                local text_size = render.measure_text(notify.font, note.text)
    
                local height_animation = math.floor(0.5 + 14 * note.animation)
                local width_animation = math.floor(0.5 + (note.animation - 1) * text_size.x)
    
                note.animation = math.lerp(note.animation, alive and 1 or 0, 0.1)
    
                renderer.text(notify.font, vector(5 + width_animation, 5 + offset, 0), notify.white:alpha_modulate(alpha), "d", note.text)
    
                offset = offset + height_animation
    
                if not alive and alpha < 5 then
                    table.remove(notify.data, index)
                end
                ::continue::
            end
    
            for index = 1, #notify.data do
                local note = notify.data[index]
                if not note then
                    goto continue
                end
    
                local alive = unix_time <= note.end_time
                local alpha = note.animation * 255
    
                if not alive and alpha < 5 then
                    table.remove(notify.data, index)
                end
    
                ::continue::
            end
    
        end
    
        client.add_callback("render", function()
            notify.handler()
        end)
    end
    --#endregion
    --#region: Callback
    -- amazing code here!!!! OMG!!!!! 😈🤘
-- Function to normalize an angle to the range [-180, 180]
local function normalize_angle(angle)
    angle = angle % 360
    if angle > 180 then
        angle = angle - 360
    end
    return angle
end

-- Function to calculate the delta between two angles (yaw, pitch, and roll)
    local function calculate_delta(client_angle, server_angle)
    local yaw_delta = normalize_angle(client_angle.yaw - server_angle.yaw)
    local pitch_delta = normalize_angle(client_angle.pitch - server_angle.pitch)
    local roll_delta = normalize_angle(client_angle.roll - server_angle.roll)
    
    -- Calculate the absolute difference (delta) between angles
    return math.abs(yaw_delta), math.abs(pitch_delta), math.abs(roll_delta)
end

-- Function to safely get a value from a table
local function safe_get(tbl, key)
    if tbl and type(tbl) == "table" then
        return tbl[key]
    end
    return nil
end

-- Function to normalize an angle to the range [-180, 180]
local function normalize_angle(angle)
    angle = angle % 360
    if angle > 180 then
        angle = angle - 360
    end
    return angle
end

-- Function to calculate the delta between two angles (yaw, pitch, and roll)
local function calculate_delta(client_angle, server_angle)
    local yaw_delta = normalize_angle(client_angle.yaw - server_angle.yaw)
    local pitch_delta = normalize_angle(client_angle.pitch - server_angle.pitch)
    local roll_delta = normalize_angle(client_angle.roll - server_angle.roll)
    
    -- Calculate the absolute difference (delta) between angles
    return math.abs(yaw_delta), math.abs(pitch_delta), math.abs(roll_delta)
end

-- Function to safely get a value from a table
local function safe_get(tbl, key)
    if tbl and type(tbl) == "table" then
        return tbl[key]
    end
    return nil
end

client.add_callback("aim_ack", function(ack)
    shots_counter = shots_counter + 1
    
    local damage = ack.damage
    local missed = damage == 0
    local msg = ""
    local hitchance_color = interpolateColor(ack.hitchance):to_hex()
    local hitchance = math.floor(0.5 + ack.hitchance * 100)
    local backtrack = ack.backtrack == 0 and "none" or ack.backtrack .. "t"
    
    -- Correctly retrieve the player's name
    local name = "Unknown"
    if ack.record and ack.record.player then
        name = ack.record.player:get_name() or "Unknown"
    end
    
    local wanted_damage = ack.wanted_damage
    local wanted_hitgroup = e_damagegroup[ack.wanted_damagegroup]
    local hitgroup = e_damagegroup[ack.damagegroup]
    local suffix = get_english_ordinal_suffix(shots_counter)
    local miss_reason = tostring(ack.miss_reason)
    local group_missmatch = wanted_hitgroup ~= hitgroup and string.format("( %s ) ", wanted_hitgroup) or ""
    local dmg_missmatch = wanted_damage ~= damage and string.format("( %s )", wanted_damage) or ""
    local blc = safe_get(ack, "record") and safe_get(ack.record, "breaking_lag_compensation") or false
    local blc_color = interpolateColor(blc and 0 or 1):to_hex()
    
    -- Calculate delta between client and server angles (yaw, pitch, and roll)
    local yaw_delta, pitch_delta, roll_delta = calculate_delta(ack.client_angle, ack.angle)
    
    -- Check for lag compensation issues
    local choked_ticks = safe_get(ack, "record") and safe_get(ack.record, "choked_ticks") or 0
    local shifting_tickbase = safe_get(ack, "record") and safe_get(ack.record, "shifting_tickbase") or false
    local is_lagging = choked_ticks > 0 or blc or shifting_tickbase
    
    -- Log player's angles (yaw, pitch, and roll)
    local client_yaw = ack.client_angle.yaw
    local client_pitch = ack.client_angle.pitch
    local client_roll = ack.client_angle.roll
    local server_yaw = ack.angle.yaw
    local server_pitch = ack.angle.pitch
    local server_roll = ack.angle.roll
    
    -- Log message
    if missed then
        msg = string.format(
            "Missed %s%s shot in %s's %s due to %s (dmg: %s | hc: %s%% | history: %s | lc: %s | Δ%.2f° yaw, %.2f° pitch, %.2f° roll | Choked Ticks: %d | Shifting Tickbase: %s) | Client: yaw: %.2f°, pitch: %.2f°, roll: %.2f° | Server: yaw: %.2f°, pitch: %.2f°, roll: %.2f°",
            shots_counter, suffix, name, wanted_hitgroup, miss_reason, wanted_damage, hitchance, backtrack, blc, yaw_delta, pitch_delta, roll_delta, choked_ticks, tostring(shifting_tickbase), client_yaw, client_pitch, client_roll, server_yaw, server_pitch, server_roll
        )
        
        -- Trigger the warning sound for all miss reasons
        utils.console_exec('play ui/beepclear.wav')
        
    else
        msg = string.format(
            "Registered %s%s shot in %s's %s %sfor %s%s damage (hc: %s%% | history: %s | lc: %s | Δ%.2f° yaw, %.2f° pitch, %.2f° roll | Choked Ticks: %d | Shifting Tickbase: %s) | Client: yaw: %.2f°, pitch: %.2f°, roll: %.2f° | Server: yaw: %.2f°, pitch: %.2f°, roll: %.2f°",
            shots_counter, suffix, name, hitgroup, group_missmatch, damage, dmg_missmatch, hitchance, backtrack, blc, yaw_delta, pitch_delta, roll_delta, choked_ticks, tostring(shifting_tickbase), client_yaw, client_pitch, client_roll, server_yaw, server_pitch, server_roll
        )
    end
    
    -- Print log to in-game console
    print(msg)
    
    -- Additional log and sound: if breaking lag compensation, choked ticks are high, or shifting tickbase
    if is_lagging then
        -- Print warning about lag abuse
        print(string.format("[WARNING] Player %s may be abusing lag (Breaking LC: %s | Choked Ticks: %d | Shifting Tickbase: %s)", name, tostring(blc), choked_ticks, tostring(shifting_tickbase)))
    end

    -- Detect abnormal roll angles (e.g., if roll exceeds normal gameplay ranges)
    if math.abs(client_roll) > 45 or math.abs(server_roll) > 45 then
        print(string.format("[WARNING] Player %s may be abusing roll angles (Client Roll: %.2f° | Server Roll: %.2f°)", name, client_roll, server_roll))
        -- Optional: Trigger a warning sound when abnormal roll angles are detected
        utils.console_exec('play ui/beepclear.wav')
    end
end)

