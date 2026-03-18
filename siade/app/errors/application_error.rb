class ApplicationError
  def code
    raise 'It should be override in inherited classes'
  end

  def title
    lookup_error_attribute('title')
  end

  def detail
    lookup_error_attribute('detail')
  end

  def source
    error_entry['source']
  end

  def meta
    nil
  end

  def inspect
    {
      code:   code,
      title:  title,
      detail: detail,
      source: source,
      meta:   meta,
    }
  end

  protected

  def error_entry
    errors_backend.get(code) || {}
  end

  def errors_backend
    @errors_backend ||= ErrorsBackend.instance
  end

  def lookup_error_attribute(attribute)
    error_entry[attribute] ||
      (raise "Attribute '#{attribute}' should be specified in errors config file")
  end
end
