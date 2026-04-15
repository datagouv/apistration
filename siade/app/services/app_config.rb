class AppConfig
  @cache = {}
  @mutex = Mutex.new

  class << self
    def fetch(key)
      return @cache[key] if @cache.key?(key)

      @mutex.synchronize do
        @cache[key] ||= yield
      end
    end

    def config_for(key)
      fetch(key) { Rails.application.config_for(key) }
    end

    def yaml_file(path, **)
      fetch(path.to_s) { YAML.load_file(path, **).freeze }
    end

    def reset!
      @mutex.synchronize { @cache.clear }
    end

    def reset(key)
      @mutex.synchronize { @cache.delete(key) }
    end
  end
end
