class Test < ActiveRecord::Migration
  def up
    MatchDesc.all.each{|m|m.rename :shot_desc,:short_desc}
  end

  def down
  end
end
