class SIADE::V2::Retrievers::GenericInformationRetriever
  attr_accessor :drivers

  def drivers
    @drivers ||= {}
  end

  def errors
    drivers.values.map(&:errors).flatten
  end

  def retrieve
    raise NotImplementedError
  end

  def http_code
    fail 'Must be implemented or fetched from driver if one and only one'
  end

  def success?
    [200, 206].include?(http_code)
  end

  def read_attribute_for_serialization(name)
    public_send(name)
  end

  def self.fetch_attributes_through_driver(driver_name, *attributes)
    attributes.each do |attribute|
      fetch_attribute_through_driver(driver_name, attribute)
    end
  end

  def self.register_driver(driver_name, options = {})
    driver_class = options[:class_name]
    driver_init_attr = options[:init_with]
    driver_init_opts = options[:init_options]

    define_method("driver_#{driver_name}") do
      driver_init_arg = { driver_init_attr => send(driver_init_attr) }
      driver_init_arg[driver_init_opts] = send(driver_init_opts) unless driver_init_opts.nil?
      drivers[driver_name] ||= driver_class.new(driver_init_arg)
    end
  end

  def self.fetch_attribute_through_driver(driver_name, attribute)
    define_method(attribute) do
      send("driver_#{driver_name}").public_send(attribute)
    end
  end
end
