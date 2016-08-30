class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.references :region, foreign_key: true
      t.decimal :value, precision: 5, scale: 2
      t.references :user, foreign_key: true
      t.references :revision, foreign_key: true

      t.timestamps
    end

    add_column :records,:oiltype_id,:integer
		add_foreign_key :records, :oiltypes, column: :oiltype_id, primary_key: "code"
  end
end
