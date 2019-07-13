module DistanceCalculator
  module_function
  # Earth's radius in kms
  EARTH_RADIUS = 6371.00

  def get_distance(point1, point2)
    validate_latitude_and_longitude(point1[:latitude], point1[:longitude])
    validate_latitude_and_longitude(point2[:latitude], point2[:longitude])

    latitude1 = to_radians(point1[:latitude])
    longitude1 = to_radians(point1[:longitude])
    latitude2 = to_radians(point2[:latitude])
    longitude2 = to_radians(point2[:longitude])
    distance = Math.acos(Math.sin(latitude1) *
               Math.sin(latitude2) + Math.cos(latitude1) *
               Math.cos(latitude2) * Math.cos(longitude1 - longitude2))
    (distance * EARTH_RADIUS).round
  end

  def to_radians(degrees)
    degrees * (Math::PI / 180.0)
  end

  def valid_latitude?(latitude)
    (-90..90).cover? latitude
  end

  def valid_longitude?(longitude)
    (-180..180).cover? longitude
  end

  def validate_latitude_and_longitude(latitude, longitude)
    raise 'Invalid latitude' unless valid_latitude?(latitude)
    raise 'Invalid longitude' unless valid_longitude?(longitude)
  end
end
