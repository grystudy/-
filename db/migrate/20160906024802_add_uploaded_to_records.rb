class AddUploadedToRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :uploaded, :boolean
  end
end
