module HandleErrorsNomenclature
  extend ActiveSupport::Concern

  CACHE_DURATION = 1.hour

  class_methods do
    def nomenclature
      @nomenclature ||= YAML.load_file(Rails.root.join("config/errors_#{api}.yml"), aliases: true).freeze
    end
  end

  def index
    return render_unknown_operation if unknown_operation?

    expires_in CACHE_DURATION, public: true

    render json: filtered_nomenclature, status: :ok
  end

  private

  def filtered_nomenclature
    return nomenclature if requested_operation_id.blank?

    nomenclature.merge('endpoints' => nomenclature['endpoints'].slice(requested_operation_id))
  end

  def unknown_operation?
    requested_operation_id.present? && nomenclature['endpoints'].exclude?(requested_operation_id)
  end

  def render_unknown_operation
    render json: ErrorsSerializer.new([UnknownOperationError.new(requested_operation_id)]).as_json,
      status: :not_found
  end

  def requested_operation_id
    params[:operation_id]
  end

  def nomenclature
    self.class.nomenclature
  end
end
