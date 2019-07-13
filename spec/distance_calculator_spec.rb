require_relative "../lib/distance_calculator"
require 'pry'

RSpec.describe DistanceCalculator do

  describe '.get_distance' do
    it 'returns less then 50km distance' do
      location1 = {
        latitude: 53.339428,
        longitude: -6.257664
      }
      location2 = {
        latitude: 52.986375,
        longitude: -6.043701
      }
      distance = DistanceCalculator.get_distance(location1, location2)
      expect(distance).to be < 50
      expect(distance).to be > 20
    end

    it 'returns greater then 50km distance' do
      location1 = {
        latitude: 53.339428,
        longitude: -6.257664
      }
      location2 = {
        latitude: 54.0894797,
        longitude: -6.18671
      }

      distance = DistanceCalculator.get_distance(location1, location2)
      expect(distance).to be > 50
      expect(distance).to be < 100
    end
  end

  describe '.to_radians' do
    it 'returns radians from degrees' do
      lat, lng = [53.339428,-6.257664]

      expect(DistanceCalculator.to_radians(lat)).to eq(lat * (Math::PI / 180.0))
      expect(DistanceCalculator.to_radians(lng)).to eq(lng * (Math::PI / 180.0))
    end
  end

  describe '.valid_latitude?' do
    it 'returns true for valid latitude' do
      expect(DistanceCalculator.valid_latitude?(53.339428)).to eq true
    end
    it 'returns false for invalid latitude' do
      expect(DistanceCalculator.valid_latitude?(153.339428)).to eq false
    end
  end

  describe '.valid_longitude?' do
    it 'returns true for valid longitude' do
      expect(DistanceCalculator.valid_longitude?(-6.257664)).to eq true
    end
    it 'returns false for invalid longitude' do
      expect(DistanceCalculator.valid_longitude?(-226.257664)).to eq false
    end
  end

  describe '.validate_latitude_and_longitude' do
    it 'raises exception for invalid latitude or longitude' do
      expect { Object.new.foo }.to raise_error
      expect{DistanceCalculator.validate_latitude_and_longitude(153.339428, -6.257664)}.
        to raise_error('Invalid latitude')
      expect{DistanceCalculator.validate_latitude_and_longitude(53.339428, -226.257664)}.
        to raise_error('Invalid longitude')
    end

    it 'not raises exception for ivalid latitude and longitude' do
      expect { Object.new.foo }.to raise_error
      expect{DistanceCalculator.validate_latitude_and_longitude(53.339428,-6.257664)}.
        to_not raise_error(RuntimeError)
    end
  end
end
