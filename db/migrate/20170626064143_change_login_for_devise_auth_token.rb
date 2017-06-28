class ChangeLoginForDeviseAuthToken < ActiveRecord::Migration[5.1]
  # https://github.com/lynndylanhurley/devise_token_auth/issues/181
  def up
    change_table :users do |t|
      t.text :tokens
    end

    change_column :users, :provider, :string, null: false, default: 'email'
    change_column :users, :uid, :string, null: false, default: ''

    User.reset_column_information

    User.find_each do |u|
      u.uid = u.email
      u.provider = 'email'   # is this necessary?
      u.save!
    end

    add_index :users, [:uid, :provider], unique: true
  end

  def down
    change_column :users, :provider, :string
    change_column :users, :uid, :string
    remove_columns :user, :provider, :uid, :tokens
    remove_index :user, name: :index_users_on_uid_and_provider
  end
end
