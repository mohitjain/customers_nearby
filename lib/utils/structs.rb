require_relative "errors"

Response = Struct.new(:data, :errors)
Records  = Struct.new(:ids, :records, :count)
