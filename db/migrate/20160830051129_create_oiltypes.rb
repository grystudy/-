class CreateOiltypes < ActiveRecord::Migration[5.0]
  def change
    create_table :oiltypes do |t|
      t.string :name
      t.integer :code
    end
  end
end
