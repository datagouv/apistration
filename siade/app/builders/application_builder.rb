class ApplicationBuilder
  def render
    renderer.result(binding)
  end

  protected

  def template_name
    fail NotImplementedError
  end

  private

  def renderer
    @renderer ||= ERB.new(File.read(template_path))
  end

  def template_path
    Rails.root.join("app/templates/#{template_name}")
  end
end
