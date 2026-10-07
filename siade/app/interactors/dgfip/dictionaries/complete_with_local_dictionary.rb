class DGFIP::Dictionaries::CompleteWithLocalDictionary < ApplicationInteractor
  def call
    return unless File.exist?(local_file_path)

    context.bundled_data = BundledData.new(
      data: Resource.new(dictionnaire: completed_dictionary),
      context: context.bundled_data.context
    )
  end

  private

  def completed_dictionary
    remote_dictionary.map { |entry| complete_entry(entry, local_entries[entry['numero_imprime']]) } +
      local_dictionary.reject { |entry| remote_numeros_imprimes.include?(entry['numero_imprime']) }
  end

  def complete_entry(remote_entry, local_entry)
    return remote_entry if local_entry.nil?
    return local_entry if declarations(remote_entry).empty?

    remote_entry.merge(
      'millesimes' => remote_entry['millesimes'].merge(
        'declaration' => declarations(remote_entry) + missing_local_declarations(remote_entry, local_entry)
      )
    )
  end

  def missing_local_declarations(remote_entry, local_entry)
    remote_codes_nref = declarations(remote_entry).pluck('code_nref')

    declarations(local_entry).reject { |declaration| remote_codes_nref.include?(declaration['code_nref']) }
  end

  def declarations(entry)
    Array.wrap(entry['millesimes'].try(:[], 'declaration'))
  end

  def remote_dictionary
    context.bundled_data.data.dictionnaire
  end

  def remote_numeros_imprimes
    remote_dictionary.pluck('numero_imprime')
  end

  def local_entries
    @local_entries ||= local_dictionary.index_by { |entry| entry['numero_imprime'] }
  end

  def local_dictionary
    @local_dictionary ||= JSON.parse(File.read(local_file_path))['dictionnaire']
  end

  def local_file_path
    Rails.root.join('config', 'dgfip', 'dictionnaires', "#{context.params[:year]}.json")
  end
end
