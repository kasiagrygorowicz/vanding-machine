class Commands
  @@commands={
    "A"=>"display_items_in_the_machine",
    "B"=>"display_money_in_the_machine",
    "C"=>"display_money_inserted_by_user",
    "D"=>"cr"
  }
  def self.get_commands;@@commands;end
end
