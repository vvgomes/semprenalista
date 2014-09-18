class RenameSubscriptionsNightclubIdColumnToClubId < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :nightclub_id, :club_id
  end
end
