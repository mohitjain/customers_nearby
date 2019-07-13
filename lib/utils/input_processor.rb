require 'json'
require_relative '../distance_calculator'

class InputProcessor
  Response = Struct.new(:data, :valid, :error)

  attr_accessor :response
  attr_reader :line

  def initialize(line)
    @line = line
    @response = Response.new({}, true)
  end

  def call
    validate_and_set_attributes
    response
  end

  private

  attr_reader :parsed_hash

  def validate_and_set_attributes
    return unless parsed_hash = parse_json
    validate_and_set_id(parsed_hash['user_id'])
    validate_and_set_name(parsed_hash['name']) if response.valid
    validate_and_set_latitude_longitude(parsed_hash) if response.valid
  end

  def parse_json
    JSON.parse(line)
    rescue JSON::ParserError => e
      response.error = :invalid_json
      response.valid = false
      return false
  end

  def validate_and_set_id(id)
    if id.to_i == 0
      response.error = :data_missing
      response.valid = false
    end
    response.data['id'] = id.to_i
  end

  def validate_and_set_name(name)
    if name.to_s.empty?
      response.error = :data_missing
      response.valid = false
    end
    response.data['name'] = name
  end

  def validate_and_set_latitude_longitude(hash)
    latitude = Float(hash['latitude']) rescue nil
    longitude = Float(hash['longitude']) rescue nil
    if latitude.nil? || longitude.nil? ||
      !(DistanceCalculator.valid_latitude?(latitude) && DistanceCalculator.valid_longitude?(longitude))
      response.error = :data_missing
      response.valid = false
    end
    response.data['latitude'] = latitude
    response.data['longitude'] = longitude
  end

end
