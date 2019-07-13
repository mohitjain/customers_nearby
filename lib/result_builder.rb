require 'pry'
require 'json'
require 'set'
require_relative 'distance_calculator'
require_relative 'utils/structs'
require_relative 'utils/input_processor'

class ResultBuilder

  attr_reader :config, :response

  def initialize(config)
    @config = config
    result_set = Records.new(SortedSet.new, {}, 0)
    @response = Response.new(result_set, Errors.new)
  end

  def call
    validate_and_set_file
    process_file if response.errors.blank?
    response
  end

  private

  attr_reader :source_file

  def validate_and_set_file
    if File.exists? config.file_path
      @source_file = File.open(config.file_path,'r')
    else
      response.errors.file ||= 'Source file does not exists!'
      return false
    end
  end

  def process_file
    source_file.each do |line|
      result = InputProcessor.new(line).call
      unless result.valid
        response.errors[result.error] ||= 0
        response.errors[result.error] += 1
        next
      end
      process_line_result(result.data)
    end
  end

  def process_line_result(attributes)
    distance = DistanceCalculator.get_distance(
      { latitude: config.latitude, longitude: config.longitude, },
      { latitude: attributes['latitude'], longitude: attributes['longitude'] }
    )
    if distance <= config.distance
      if response.data.count < Customer::MAX_RECORDS
        add_record(attributes)
      elsif attributes['id'] < (max = response.data.ids.max)
        response.data.ids.delete(max)
        response.data.records.delete(max)
        add_record(attributes)
      end
      response.data.count += 1
    end
  end

  def add_record(record)
    response.data.ids.add(record['id'])
    response.data.records[record['id']] = record['name']
  end
end
