class AddSecurityAndHostingToEditors < ActiveRecord::Migration[8.1]
  def change
    add_column :editors, :two_factor_status, :string
    add_column :editors, :two_factor_deadline, :date
    add_column :editors, :two_factor_methods, :string, array: true, default: [], null: false
    add_column :editors, :hosting_provider, :string
    add_column :editors, :hosting_country, :string
    add_column :editors, :security_accreditation, :boolean
    add_column :editors, :security_accreditation_date, :date
    add_column :editors, :uses_mon_service_securise, :boolean
    add_column :editors, :has_designated_rssi, :boolean
  end
end
