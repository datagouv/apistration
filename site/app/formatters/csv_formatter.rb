require 'csv'

class CsvFormatter
  COL_SEP = ';'.freeze
  BOM = '﻿'.freeze

  def initialize(rows)
    @rows = rows
  end

  def to_csv
    BOM + CSV.generate(col_sep: COL_SEP) do |csv|
      csv << columns.keys.map { |key| I18n.t!("#{i18n_scope}.headers.#{key}") }
      @rows.each { |row| csv << columns.values.map { |extractor| extractor.call(row) } }
    end
  end

  def filename
    "#{filename_prefix}-#{Date.current.iso8601}.csv"
  end

  private

  def columns
    raise NotImplementedError
  end

  def i18n_scope
    "formatters.#{self.class.name.underscore.tr('/', '.').delete_suffix('_formatter')}"
  end

  def filename_prefix
    i18n_scope.delete_prefix('formatters.').tr('.', '-')
  end
end
