module ActivateStrictVcrRequestMatchingForV3
  def add_strict_matching_on_vcr_requests_for_v3(example)
    return example unless v3_spec_file?(example.file_path) || swagger_request_spec?(example)

    example.metadata[:vcr][:match_requests_on] = strict_match_vcr_requests_on_attributes if vcr_config?(example) && vcr_match_requests_on_blank?(example)

    example
  end

  def strict_match_vcr_requests_on_attributes
    %i[
      method
      uri
      body
      headers_sanitized
    ].freeze
  end

  private

  def v3_spec_file?(file_path)
    v3_spec_folders.any? do |v3_spec_folder|
      file_path.starts_with?("./spec/#{v3_spec_folder}")
    end
  end

  def swagger_request_spec?(example)
    example.metadata[:type].include?(:swagger)
  rescue NoMethodError
    false
  end

  def vcr_match_requests_on_blank?(example)
    example.metadata[:vcr][:match_requests_on].blank?
  end

  def vcr_config?(example)
    example.metadata[:vcr].present?
  end

  def v3_spec_folders
    %w[
      organizers
      interactors
      controllers/v3_and_more/
    ]
  end
end
