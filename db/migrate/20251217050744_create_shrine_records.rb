class CreateShrineRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :shrine_records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :shrine_name
      t.string :deity
      t.date :visited_on
      t.text :wish
      t.text :memo
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
