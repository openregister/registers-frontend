class CreateRegisterGovOrgId < ActiveRecord::Migration[5.2]
  def change
    add_column :registers, :government_organisation_id, :string
    end
  end
