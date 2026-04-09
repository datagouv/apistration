module PayloadsHelpers
  def payload_entries(operation_id)
    Dir[File.expand_path("payloads/#{operation_id}/*.y*ml", root_path)]
  end

  def root_path
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
end
