class AddSecurityAndHostingToEditors < ActiveRecord::Migration[8.1]
  def change
    add_column :editors, :two_factor_status, :string
    add_column :editors, :two_factor_deadline, :date
    add_column :editors, :two_factor_methods, :string, array: true, default: [], null: false
    add_column :editors, :hosting_provider, :string
    add_column :editors, :hosting_country, :string
    add_column :editors, :security_accreditation, :boolean
    add_column :editors, :security_accreditation_begin_date, :date
    add_column :editors, :security_accreditation_end_date, :date
    add_column :editors, :mon_service_securise_url, :string
  end
end
