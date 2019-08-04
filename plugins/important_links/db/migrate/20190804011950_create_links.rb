class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :important_links_plugin_links do |t|
      t.references :image
      t.references :block
      t.string :name
      t.string :description
      t.string :address
    end
  end
end
