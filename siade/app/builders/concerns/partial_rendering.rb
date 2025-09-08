module PartialRendering
  extend ActiveSupport::Concern

  protected

  def render_partial(partial_name, locals = {})
    template(partial_name).result_with_hash(locals).strip
  end

  private

  def partial_path(partial_name)
    @partial_path ||= Rails.root.join("app/templates/#{partial_name}")
  end

  def template(partial_name)
    partial_path = Rails.root.join("app/templates/#{partial_name}")

    ERB.new(File.read(partial_path))
  end
end
