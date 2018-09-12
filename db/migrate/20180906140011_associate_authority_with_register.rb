class AssociateAuthorityWithRegister < ActiveRecord::Migration[5.2]
  def change
    Register.find_each do |r|
      r.authority_id = Authority.find_by(government_organisation_key: r[:authority]).id
      r.save
    end
    remove_column :registers, :authority
  end
end
