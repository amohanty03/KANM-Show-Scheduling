# app/services/schedule_processor.rb
# This Class will handle the core business logic of our Scheduler
class ScheduleProcessor
  @unassigned_rjs = []  # Class variable to store unassigned RJs

  def self.process
    puts "Handling the core scheduler business logic here."
    self.process_returning_rj_retaining_their_slots
    self.sort_and_assign_timeslots_for_remaining_rjs
  end

  DAYS_AS_NUMS = {
    Monday: 0,
    Tuesday: 1,
    Wednesday: 2,
    Thursday: 3,
    Friday: 4,
    Saturday: 5,
    Sunday: 6
  }

  def self.unassigned_rjs
    @unassigned_rjs
  end

  def self.is_available_db(day, hour)
    entry = ScheduleEntry.find_by(day: day, hour: hour)
    if not entry.nil?
      entry.show_name.nil?
    else
      false
    end
  end

  def self.add_entry(day, hour, jockey)
    entry = ScheduleEntry.find_by(day: day, hour: hour)

    # Update the entry with new values if it exists
    if entry
      entry.update(
        show_name: jockey.show_name,
        last_name: jockey.last_name,
        jockey_id: jockey.id
      )
    end
  end


  # Step 1
  def self.process_returning_rj_retaining_their_slots
    returning_rjs = RadioJockey.where(member_type: "Returning DJ", retaining: "Yes").order(
      semesters_in_kanm: :desc, expected_grad: :asc, timestamp: :asc
    )

    returning_rjs.each do |jockey|
      # Apply the condition - update only if conditions are met (This condition must be set)
      # Find the existing ScheduleEntry for the given day and hour
      add_entry(jockey.best_day, jockey.best_hour, jockey)
    end
    puts "Processing returning RJ who've retaining their slots."
  end

  def self.add_in_range(key, values, range_values, min, max)
    in_range = values.select { |value| (value.to_i >= min && value.to_i <= max) }
      if range_values[key].nil? == false
        range_values[key].concat(in_range) unless in_range.empty?
      else
        range_values[key] = in_range unless in_range.empty?
      end
      range_values
    end

  def self.best_alt_time_ranges(best_time, range, range_step, alt_times)
    min_time = best_time - range
    min_check = min_time + range_step
    max_time = best_time + range
    max_check = max_time - range_step
    add_to_yesterday = false
    add_to_tomorrow = false
    adj_day_range = 0
    adj_check = 0

    if best_time < range
      add_to_yesterday = true
      adj_day_range = 0 - min_time
      if adj_day_range > range_step
        min_check = 0
        adj_check = adj_day_range + range_step
      else
        adj_check = 23
      end
      min_time = 0
    elsif best_time > (23 - range)
      add_to_tomorrow = true
      adj_day_range = max_time - 23
      if adj_day_range > range_step
        max_check = 23
        adj_check = adj_day_range - range_step
      else
        adj_check = 0
      end
      max_time = 23
    end
    range_values = {}
    alt_times.each do |key, values|
      in_range = values.select { |value| (value.to_i >= min_time && value.to_i <= min_check) || (value.to_i >= max_check && value.to_i <= max_time) }
      range_values = add_in_range(key, values, range_values, min_time, min_check)
      range_values = add_in_range(key, values, range_values, max_check, max_time)
      if add_to_yesterday
        range_values = add_in_range(key, values, range_values, adj_day_range, adj_check)
      elsif add_to_tomorrow
        range_values = add_in_range(key, values, range_values, adj_check, adj_day_range)
      end
    end
    range_values
  end

  def self.assemble_alt_times(rj)
    times = {}
    times[:Monday] = RadioJockey.process_alt_times(rj.alt_mon)
    times[:Tuesday] = RadioJockey.process_alt_times(rj.alt_tue)
    times[:Wednesday] = RadioJockey.process_alt_times(rj.alt_wed)
    times[:Thursday] = RadioJockey.process_alt_times(rj.alt_thu)
    times[:Friday] = RadioJockey.process_alt_times(rj.alt_fri)
    times[:Saturday] = RadioJockey.process_alt_times(rj.alt_sat)
    times[:Sunday] = RadioJockey.process_alt_times(rj.alt_sun)

    times
  end

  def self.print_final_schedule
    schedule = ScheduleEntry.all
    schedule.each do |day|
      puts day.attributes
    end
  end

  def self.day_from_num(num)
    if DAYS_AS_NUMS.value?(num)
      DAYS_AS_NUMS.key(num)
    else
      puts "Invalid num!"
    end
  end

  def self.num_from_day(name)
    stylized_name = name.downcase.capitalize.to_sym
    if DAYS_AS_NUMS.key?(stylized_name)
      DAYS_AS_NUMS[stylized_name]
    else
      puts "Invalid day!"
    end
  end

  def self.find_time_same_day(times_best_day, rj)
    if times_best_day != nil
      good_hour = times_best_day[times_best_day.length / 2]
      if is_available_db(rj.best_day, good_hour)
        add_entry(rj.best_day, good_hour, rj)
        return true
      end
    end
    false
  end

  def self.find_time_any_day(best_avail_times, rj)
    best_avail_times.each do |day, times|
      if day != nil
        num_times = times.length
        good_hour = times[num_times / 2]
        if is_available_db(day, good_hour)
          add_entry(day, good_hour, rj)
          return true
        end
      end
    end
    false
  end

  def self.generate_schedule(sorted_rjs)
    @unassigned_rjs = []  # Reset the unassigned RJs list before processing
    sorted_rjs.each do |rj|
      alt_times = assemble_alt_times(rj)
      assigned = false
      if is_available_db(rj.best_day, rj.best_hour)
        add_entry(rj.best_day, rj.best_hour, rj)
        assigned = true
      else
        # Find alternative
        i = 3
        range_step = 3
        while i <= 12
          best_avail_times = best_alt_time_ranges(rj.best_hour.to_i, i, range_step, alt_times)
          # Same day, similar hour
          if find_time_same_day(best_avail_times[num_from_day(rj.best_day)], rj) == true
            assigned = true
            break
          end
          # Different day, similar hour
          if find_time_any_day(best_avail_times, rj) == true
            assigned = true
            break
          end
          i += range_step
        end
      end
      # If no slot was assigned, add RJ to unassigned list
      unassigned_rjs << rj unless assigned
    end
  end

  # Step 2 and 3
  def self.sort_and_assign_timeslots_for_remaining_rjs
    puts "Processing all RJs who need to be assigned a new slot."

    # Read and Sort the RJs (Step 2)
    returning_rjs = RadioJockey.where(member_type: "Returning DJ", retaining: "No").order(
      semesters_in_kanm: :desc, expected_grad: :asc, timestamp: :asc
    )
    new_rjs = RadioJockey.where(member_type: "New DJ").order(
      semesters_in_kanm: :desc, expected_grad: :asc, timestamp: :asc
    )
    sorted_rjs = returning_rjs + new_rjs

    # (Step 3)
    # For each RJ, check first for their best slot being free in the schedule, populate if true, continue
    # If not, then get all the available slots, and find one which is free in the schedule, populate and continue
    # If this too failed, then add to the list of unassigned RJs, that we will display in the frontend
    sorted_rjs.each do |rj|
      puts format(
        "UIN: %-11s DJ Name: %-15s Member Type: %-15s Semesters in KANM: %-5s Expected Graduation: %-8s Timestamp: %-20s Show Name: %-20s",
        rj.uin, rj.dj_name, rj.member_type, rj.semesters_in_kanm, rj.expected_grad, rj.timestamp, rj.show_name
      )
    end

    generate_schedule(sorted_rjs)
    print_final_schedule
  end
end
