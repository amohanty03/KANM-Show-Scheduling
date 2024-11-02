require 'rails_helper'
RSpec.describe ScheduleProcessor, type: :service do
    it "gets num from day" do
        num = [ -1, -1, -1, -1, -1, -1, -1 ]
        num[0] = ScheduleProcessor.num_from_day("monday")
        num[1] = ScheduleProcessor.num_from_day("tuesday")
        num[2] = ScheduleProcessor.num_from_day("wednesday")
        num[3] = ScheduleProcessor.num_from_day("thursday")
        num[4] = ScheduleProcessor.num_from_day("friday")
        num[5] = ScheduleProcessor.num_from_day("saturday")
        num[6] = ScheduleProcessor.num_from_day("sunday")
        expect(num == [ 0, 1, 2, 3, 4, 5, 6 ])
    end
    it "finds alternate times in range" do
        alt_times = {
            Monday: [ "1", "3", "7", "8" ],
            Tuesday: [ "1", "2", "3" ],
            Wednesday: [ "3", "5", "7", "8" ],
            Thursday: [ "5", "6", "10", "12" ],
            Friday: [ "5", "8", "10", "13" ],
            Saturday: [ "9", "10", "14", "20" ],
            Sunday: [ "12", "15", "16", "17" ]
        }
        expected_times = {
            Monday: [ "1", "3" ],
            Tuesday: [ "1", "2", "3" ],
            Wednesday: [ "3", "5" ],
            Thursday: [ "5", "6" ],
            Friday: [ "5" ],
            Saturday: [],
            Sunday: []
        }

        result = ScheduleProcessor.best_alt_time_ranges(3, 3, alt_times)
        expect(alt_times == expected_times)
    end
end
