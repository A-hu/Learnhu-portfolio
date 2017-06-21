class CreateWatches < ActiveRecord::Migration[5.1]
  def change
    create_table :watches do |t|
      t.string :title
      t.integer :amount
      t.integer :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
