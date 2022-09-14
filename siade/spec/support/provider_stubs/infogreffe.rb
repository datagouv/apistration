require_relative '../provider_stubs'
require 'erb'

module ProviderStubs::Infogreffe
  def infogreffe_payload(siren, kind)
    template = extract_infogreffe_payload_template_path(kind)
    ERB.new(template).result(binding)
  end

  private

  def extract_infogreffe_payload_template_path(kind)
    Rails.root.join(
        "spec/fixtures/payloads/infogreffe_#{kind}.xml.erb"
      ).read
  end
end
