require 'singleton'

class AbstractErrorsNomenclature
  include Singleton

  class << self
    delegate :providers, :generic_subcodes, :platform_codes, :errors_for, to: :instance
  end

  attr_reader :backend

  def initialize
    load_backend
    super
  end

  def providers
    backend['providers']
  end

  def generic_subcodes
    backend['generic_subcodes']
  end

  def platform_codes
    backend['platform_codes']
  end

  def errors_for(operation_id)
    backend.dig('endpoints', operation_id, 'errors') || {}
  end

  def load_backend
    @backend = YAML.safe_load(local_path.read, aliases: true)
  end

  protected

  def local_path
    fail NotImplementedError
  end
end
