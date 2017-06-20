class AddBodyToTopic < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :body, :text
  end
end
