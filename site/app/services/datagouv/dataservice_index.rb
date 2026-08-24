module Datagouv
  class DataserviceIndex
    def initialize(client: DatagouvAPIClient.new)
      @dataservices = client.list_dataservices(organization: FichePayloadBuilder::ORGANIZATION_ID)
    end

    def find(endpoint)
      by_business_url[FichePayloadBuilder.new(endpoint).business_documentation_url]
    end

    delegate :size, to: :dataservices

    private

    attr_reader :dataservices

    def by_business_url
      @by_business_url ||= dataservices.index_by { |dataservice| dataservice['business_documentation_url'] }
    end
  end
end
