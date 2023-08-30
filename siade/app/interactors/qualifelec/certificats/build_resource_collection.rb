class Qualifelec::Certificats::BuildResourceCollection < BuildResourceCollection
  DATE_FORMAT = '%Y-%m-%d'.freeze

  protected

  def items
    json_body
  end

  def resource_attributes(item)
    {
      document_url: item['url'],
      numero: item['num'],
      rge: item['rge'],
      date_debut: normalized_date(timestamp_to_time(item['start_date'])),
      date_fin: normalized_date(timestamp_to_time(item['end_date'])),
      qualification: {
        label: item['label'],
        date_debut: normalized_date(timestamp_to_time(item['qualification_start_date'])),
        date_fin: normalized_date(timestamp_to_time(item['qualification_end_date'])),
        indices: item['indexes'],
        mentions: item['mentions'],
        domaines: item['domains'],
        classification: {
          code: item['classification']['code'],
          label: item['classification']['label']
        }
      },
      assurance_decennale: {
        nom: item['decennial_insurance'],
        date_debut: normalized_date(timestamp_to_time(item['decennial_insurance_start_date'])),
        date_fin: normalized_date(timestamp_to_time(item['decennial_insurance_end_date']))
      },
      assurance_civile: {
        nom: item['liability_insurance'],
        date_debut: normalized_date(timestamp_to_time(item['liability_insurance_start_date'])),
        date_fin: normalized_date(timestamp_to_time(item['liability_insurance_end_date']))
      }
    }
  end

  private

  def timestamp_to_time(timestamp)
    Time.zone.at(timestamp) if timestamp
  end
end
