class Mongidtest < ActiveRecord::Migration
  def up
    MatchDesc.all.each{|m|m.rename :short_desc,:shot_desc}

  end

  def down
  end
end
