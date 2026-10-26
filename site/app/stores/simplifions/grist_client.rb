module Simplifions
  class GristClient
    GRIST_BASE_URL = 'https://grist.numerique.gouv.fr/api/docs/ofSVjCSAnMb6/tables'.freeze
    TABLE_NAMES = {
      fournis: 'API_et_datasets_fournis',
      apis: 'APIs_et_datasets',
      cas_usages: 'Cas_d_usages',
      fournisseurs: 'Fournisseurs_de_services',
      usagers: 'Usagers'
    }.freeze

    def tables
      TABLE_NAMES.transform_values { |table_name| fetch_table(table_name) }
    end

    private

    def fetch_table(table_name)
      response = connection.get("#{GRIST_BASE_URL}/#{table_name}/records")

      JSON.parse(response.body).fetch('records')
    end

    def connection
      @connection ||= Connection.build
    end
  end
end
