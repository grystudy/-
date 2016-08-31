class AddStandardRefToOiltypes < ActiveRecord::Migration[5.0]
  def change
    add_reference :oiltypes, :standard, foreign_key: true
  end
end
