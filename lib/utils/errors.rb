Errors = Struct.new(:file, :invalid_json, :data_missing) do
  def blank?
    [file, invalid_json, data_missing].all? {|e| e.respond_to?(:empty?) ? !!e.empty? : !e }
  end

  def present?
    !blank?
  end

  def messages
    message_list = []
    message_list.push(file) if !file.nil? && !file.empty?
    message_list.push("#{invalid_json} invalid json rows") if invalid_json.to_i > 0
    message_list.push("#{data_missing} data missing rows") if data_missing.to_i > 0
    message_list
  end
end
