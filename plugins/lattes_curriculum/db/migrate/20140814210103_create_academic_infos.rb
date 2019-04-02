class CreateAcademicInfos < ActiveRecord::Migration[5.1]
  def self.up
    create_table :academic_infos do |t|
      t.references :person
      t.column :lattes_url, :string
    end
   end

  def self.down
    drop_table :academic_infos
  end
end
