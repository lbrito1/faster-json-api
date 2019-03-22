class CreateSweepstakes < ActiveRecord::Migration[5.2]
  def change
    create_table :sweepstakes do |t|
      t.integer :party_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
