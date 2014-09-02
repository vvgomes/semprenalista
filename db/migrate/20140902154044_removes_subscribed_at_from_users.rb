class RemovesSubscribedAtFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :subscribed_at
  end

  def down
    add_column :users, :subscribed_at, :datetime
  end
end
