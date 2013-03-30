class ChangeScheduleInvertal < ActiveRecord::Migration
  def up
    # NOTE: PostgreSQL can not cast :string/:text to :integer implicity,
    #       So we need to do a workaround.
    case ActiveRecord::Base.connection.adapter_name
    when 'PostgreSQL'
      rename_column :projects, :polling_interval, :polling_interval_string
      add_column :projects, :polling_interval, :integer, null: true

      Project.reset_column_information
      Project.find_each { |c| c.update_attribute(:polling_interval, c.polling_interval_string) }
      remove_column :projects, :polling_interval_string
    else
      change_column :projects, :polling_interval, :integer, null: true
    end
  end

  def down
    change_column :projects, :polling_interval, :string, null: true
  end
end
