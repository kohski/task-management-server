class RenameColumnAssiginedUserInStep < ActiveRecord::Migration[5.2]
  def change
    rename_column :steps, :assgined_user, :assigned_user
  end
end
