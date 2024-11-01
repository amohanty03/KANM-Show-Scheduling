# frozen_string_literal: true

require 'open3'

def request(resource, params = {})
    if params.key? :stdin_data
        Open3.capture2(command, stdin_data: params[:stdin_data])
    else
        Open3.capture2(command)
    end
end

def capture_output
    old_output = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
ensure
    $stdout = old_output
end
