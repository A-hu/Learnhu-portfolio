class CreateLikeJoins < ActiveRecord::Migration[5.1]
  def change
    create_table :like_joins do |t|
      t.integer :likable_id
      t.string :likable_type
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :like_joins, [:likable_id, :likable_type]
  end
end
