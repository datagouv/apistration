module Datagouv
  class DataserviceIndex
    MARKER_PATTERN = /<!-- apistration-endpoint-uid: (\S+) -->/

    def initialize(client: DatagouvAPIClient.new)
      @dataservices = client.list_dataservices(organization: FichePayloadBuilder::ORGANIZATION_ID)
    end

    def find(endpoint)
      by_marker[endpoint.uid] || by_title[FichePayloadBuilder.new(endpoint).title]
    end

    def marker_match(endpoint)
      by_marker[endpoint.uid]
    end

    private

    attr_reader :dataservices

    def by_marker
      @by_marker ||= dataservices.each_with_object({}) do |dataservice, marker_index|
        match = dataservice['description'].to_s.match(MARKER_PATTERN)
        marker_index[match[1]] = dataservice if match
      end
    end

    def by_title
      @by_title ||= dataservices.index_by { |dataservice| dataservice['title'] }
    end
  end
end
