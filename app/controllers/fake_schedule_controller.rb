class ScheduleController < ApplicationController

    @rj_list
    @final_schedule
    @first_range
    # monday -> [0..23] each entry is RJ, etc.

    def set_rj_list(list)
        @rj_list = list

    # rj.best_day
    # rj.best_hour
    # rj.alt_times -> [[hours list]....[hours list]]
    #                    Monday(0)        Sunday(6)

    def available (time_date)
        return final_schedule[time_date].empty?
    end

    def best_alt_time_ranges(best_time, range, alt_times)
        min_range = best_time - range
        max_range = best_time + range
        if best_time < range
            min_range = 0
        elsif best_time > (23 - range)
            max_range = 23
        end
        
        range_values = {}
        alt_times.each do |key, values|
            in_range = values.select{|value| value >= min_range && values <= max_range}
            range_values[key] = in_range unless in_range.empty?
        end
        return range_values
    end

    def generate_schedule
        rj_list.each do |rj|
            best_day = final_schedule[rj.best_day]
            if available best_day[rj.best_hour]
                final_schedule[rj.best_day][rj.best_hour] = rj
            else
                i = 3
                while i <= 12
                    best_avail = best_alt_time_ranges(rj.best_hour, i, rj.alt_times)
                    if not best_avail[rj.best_day].empty?
                        num_times = best_avail[rj.best_day].length
                        good_hour = best_avail[rj.best_day][num_times / 2]
                        if available[rj.best_day][good_hour]
                            final_schedule[rj.best_day][good_hour] = rj
                            break
                        end
                    else
                        best_avail.each do |day|
                            if not day.empty?
                                num_times = best_avail[day].length
                                good_hour = best_avail[day][num_times / 2]
                                if available[day][good_hour]
                                    final_schedule[day][good_hour] = rj
                                    break
                                end
                            end
                        end
                    end
                    i += 3
                end
            end
        end
    end
end