require 'singleton'

class ThrottleStore
  include Singleton

  def self.for_operation_id(operation_id)
    instance.index[operation_id]
  end

  def index
    load_index if Rails.env.development?
    @index
  end

  private

  def initialize
    load_index
    super
  end

  def load_index
    @index = {}

    config = YAML.safe_load_file(Rails.root.join('config/throttle.yml'), aliases: true)
    shared = config['shared']

    shared.each_value do |group|
      endpoints = group['endpoints'] || []

      endpoints.each do |operation_id|
        @index[operation_id] = {
          limit: group['limit'],
          period: group['period'],
          throttle_type: group['throttle_type']
        }
      end
    end
  end
end
