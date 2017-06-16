class AddAboutToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :about, :text
    add_column :users, :brief_about, :text
    add_reference :skills, :user, foreign_key: true
  end
end
