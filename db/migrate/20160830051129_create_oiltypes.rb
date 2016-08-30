class CreateOiltypes < ActiveRecord::Migration[5.0]
  def change
    create_table :oiltypes, :primary_key=>"code" do |t|
      t.string :name
    end
  end
end
