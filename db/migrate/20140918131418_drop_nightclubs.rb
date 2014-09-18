class DropNightclubs < ActiveRecord::Migration
  def change
    drop_table :nightclubs
  end
end
