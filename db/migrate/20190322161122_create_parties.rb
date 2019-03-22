class CreateParties < ActiveRecord::Migration[5.2]
  def change
    create_table :parties do |t|
      t.string :name
      t.string :description
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
