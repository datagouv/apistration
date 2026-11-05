require 'singleton'

class ThrottleStore
  include Singleton

  def self.for_operation_id(operation_id)
    instance.index[operation_id]
  end

  def self.period_for_throttle(throttle_name)
    instance.throttle_periods[throttle_name]
  end

  def self.throttle_names
    instance.throttle_periods.keys
  end

  def index
    load_index if Rails.env.development?
    @index
  end

  def throttle_periods
    load_index if Rails.env.development?
    @throttle_periods
  end

  private

  def initialize
    load_index
    super
  end

  def load_index
    shared = YAML.safe_load_file(Rails.root.join('config/throttle.yml'), aliases: true)['shared']

    load_operation_ids(shared)
    load_throttle_periods(shared)
  end

  def load_operation_ids(shared)
    @index = {}

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

  def load_throttle_periods(shared)
    @throttle_periods = {}

    shared.each do |group_name, group|
      throttle_names_of(group_name, group).each do |throttle_name|
        @throttle_periods[throttle_name] = group['period']
      end
    end
  end

  def throttle_names_of(group_name, group)
    if group['throttle_type'] == 'by_single_endpoint'
      group['endpoints'] || []
    else
      [group_name]
    end
  end
end
