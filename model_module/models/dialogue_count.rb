class DialogueCount < ActiveRecord::Base
  attr_accessible :count, :dialogue_id
  def self.check_table_name(table_name = nil)
    table_name = Time.now.strftime("dialogue_count_%Y%m") if table_name.nil?
    unless self.table_name == table_name
      self.table_name = table_name
      unless self.table_exists?
        self.connection.execute("create table #{table_name} like dialogue_counts;")
        self.table_name = table_name
        self.reset_column_information
      end
    end
  end

  def self.count(id)
    check_table_name
    flag = DialogueCount.find_by_dialogue_id(id)
    if flag.nil?
      dialogue = DialogueCount.new
      dialogue.dialogue_id = id
      dialogue.count = 1
      dialogue.save
    else
      flag.count = flag.count + 1
      flag.save
    end
  end
end
