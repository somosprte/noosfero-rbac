class CreateOrganizationRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_ratings do |t|
      t.belongs_to :organization
      t.belongs_to :person
      t.belongs_to :comment
      t.integer :value

      t.timestamps
    end
  end
end
