require_relative "result_builder"

class Customer
  attr_accessor :latitude, :longitude, :name, :distance, :file_path
  MAX_RECORDS = 100_000

  def initialize(name:, latitude:, longitude:, file_path:, distance: 100)
    self.name      = name
    self.latitude  = latitude
    self.longitude = longitude
    self.file_path = file_path
    self.distance  = distance
  end

  def self.default
    default_options = {
      latitude: 53.339428,
      longitude: -6.257664,
      name: 'Dublin office',
      file_path: 'data/customers.json'
    }
    self.new(**default_options)
  end

  def call
    response = ResultBuilder.new(self).call
    print_result(response)
  end

  private

  def print_result(response)
    if response.data.ids.length.zero?
      if response.errors.present?
        puts response.errors.messages
      else
        puts 'Empty file !'
      end
      return
    end

    if response.errors.present?
      puts "Errors summary: \n #{response.errors.messages.join('\n')}\n#{'---' * 20}"
    end

    puts "\nCustomers near #{name} within #{distance}km are #{response.data.count} \n#{'---' * 20}"
    response.data.ids.each do |user_id|
      puts "id: #{user_id}, name: #{response.data.records[user_id]}"
    end
    if (diff = (response.data.count - response.data.ids.length)) > 0
      puts "And #{diff} more customers !"
    end
  end

end
