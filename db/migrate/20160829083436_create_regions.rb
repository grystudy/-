class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.integer :code
      t.text :name
    end
  end
end
