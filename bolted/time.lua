local time = {
    on_year_changed_callbacks = {},
    on_month_changed_callbacks = {},
    on_weekly_reset_day_callbacks = {},
    on_day_changed_callbacks = {},
    on_hour_changed_callbacks = {},
    on_minute_changed_callbacks = {},

    year = 0,
    month = 0,
    day = 0,
    weekday = 0,
    hour = 0,
    minute = 0
}

function time:fill(year, month, day, weekday, hour, minute)
    self.year = year;
    self.month = month;
    self.day = day;
    self.weekday = weekday;
    self.hour = hour;
    self.minute = minute;
end

function time:tick(plugin)
    local year, month, day, hour, minute = plugin.bolt.datetime()
    local weekday = plugin.bolt.weekday()

    if year ~= self.year then
        for _, callback in pairs(self.on_year_changed_callbacks) do
            callback(plugin)
        end
    end

    if month ~= self.month then
        for _, callback in pairs(self.on_month_changed_callbacks) do
            callback(plugin)
        end
    end

    if weekday ~= self.weekday and weekday == 4 then -- If wednesday
        for _, callback in pairs(self.on_weekly_reset_day_callbacks) do
            callback(plugin)
        end
    end

    if day ~= self.day then
        for _, callback in pairs(self.on_day_changed_callbacks) do
            callback(plugin)
        end
    end

    if hour ~= self.hour then
        for _, callback in pairs(self.on_hour_changed_callbacks) do
            callback(plugin)
        end
    end

    if minute ~= self.minute then
        plugin.bolt.saveconfig('tick', 'tick')

        for _, callback in pairs(self.on_minute_changed_callbacks) do
            callback(plugin)
        end
    end

    self:fill(year, month, day, weekday, hour, minute)
end

function time:add_on_year_changed_callback(callback)
    table.insert(self.on_year_changed_callbacks, callback)
end

function time:add_on_month_changed_callback(callback)
    table.insert(self.on_year_changed_callbacks, callback)
end

function time:add_on_weekly_reset_day_callback(callback)
    table.insert(self.on_weekly_reset_day_callbacks, callback)
end

function time:add_on_day_changed_callback(callback)
    table.insert(self.on_day_changed_callbacks, callback)
end

function time:add_on_hour_changed_callback(callback)
    table.insert(self.on_hour_changed_callbacks, callback)
end

function time:add_on_minute_changed_callback(callback)
    table.insert(self.on_minute_changed_callbacks, callback)
end

return time
