class Analyze < ActiveRecord::Migration
  def up
    execute 'ANALYZE'
  end

  def down
    execute 'ANALYZE'
  end
end
