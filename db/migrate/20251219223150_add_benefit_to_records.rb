class AddBenefitToRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :shrine_records, :benefit, :string
  end
end
