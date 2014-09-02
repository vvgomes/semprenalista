class CreateNightclubs < ActiveRecord::Migration
  def change
    create_table :nightclubs do |t|
      t.string :name
    end
  end
end
