class IncreateTraceColunmLimit < ActiveRecord::Migration
  def up
    # NOTE: PostgreSQL does not allow :limit for :text
    case ActiveRecord::Base.connection.adapter_name
    when 'PostgreSQL'
      change_column :builds, :trace, :text
    else
      change_column :builds, :trace, :text, :limit => 4294967295
    end
  end

  def down
  end
end
