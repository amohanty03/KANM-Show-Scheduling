require 'rails_helper'

RSpec.describe ScheduleProcessor, type: :service do
    it "gets num from day" do
        num = ScheduleProcessor.num_from_day("monday")
        expect(num == 0)
    end
end
