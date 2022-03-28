require_relative 'item.rb'
require_relative 'coins.rb'
require_relative 'commander.rb'

class Machine
  def initialize
    @items_list={}
    @money_in_machine=Hash.new(0)
    @money_inserted =0
    @counter=1
  end

  def display_money_inserted_by_user
    puts "Sum in the machine #{Coins.currency(@money_inserted)}"
  end

  def remove_coin_from_the_machine(value)
    quantity = @money_in_machine[value]
    if quantity == 1
      @money_in_machine.delete(value)
    else
      @money_in_machine[value] = quantity - 1
    end
  end

  def add_item(name,price, supply)
    item =Item.new(name,price,supply)
    contains =@items_list.has_value?(item)
    if contains
      key =@items_list.key(item)
      key.supply=+supply
    else
      @items_list[@counter]=item
      @counter=@counter+1
    end
  end

  def add_money_to_the_machine(value, quantity)
    @money_in_machine[value] += quantity
  end

  def display_money_in_the_machine
    puts 'Coins in the machine:'
    @money_in_machine.each do |value, quantity|
      puts Coins.to_s(value, quantity)
    end
  end

  def display_items_in_the_machine
    @items_list.each do |symbol, item|
      puts "#{symbol} - #{item.supply} #{item.name} " +
        Coins.currency(item.price)
    end
  end

  def help
    puts 'Menu:'
    puts '  help - shows main menu'
    puts '  exit/quit/close/ - quits program'
    puts '  A - show snacks in the machine'
    puts '  B - shows what and how many coins are in the machine'
    puts '  C - shows how much money you already put in the machine '
    puts '  D - return all put in money'
    puts '  1c - puts in 1 cents'
    puts '  5c - puts in 5 cent'
    puts '  10c - puts in 10 cents'
    puts '  25c - puts in 25 cents'
    puts '  1$ - puts in 1 dollar'
    puts '  5$ - puts in 5 dollars'
    puts '  To buy a snack insert enough coins into the vending machine and enter number reprezenting chosen snack'
  end

    
  def insert_money(coin)
    intCoin=Coins.get_codes.key(coin)
    @money_in_machine[intCoin] += 1
    @money_inserted =intCoin+ @money_inserted
  end

  def cr
    change = make_change
    puts "Your change:"
    if change
      change.each do |value|
        puts Coins.code(value)
        remove_coin_from_the_machine(value)
      end
      @money_inserted = 0
    else
      puts "No coins to return"
    end
    change
  end

  def make_change(amount=@money_inserted,change=[])
    @money_in_machine.keys.sort.reverse.each do |value|
      if (value - amount).abs < 1e-7
        return change << value
      elsif value < amount
        remove_coin_from_the_machine(value)
        new_change = make_change(
          amount - value,change + [value])
        return new_change if new_change
      end
    end
    nil 
  end

    def purchase(selector)
    item = @items_list[selector]

    if item.supply > 0
      excess = @money_inserted - item.price
      if excess >= 0
        @money_inserted -= item.price
        if excess == 0 || cr
          puts "Bought snack: "+item.name
          item.supply -= 1
          @items_list.delete(selector) if item.supply == 0
          # puts selector
        else
          puts "Could not give vhnage. Not enough coins!"
        end
      else
        puts "insert additional #{Coins.currency(-excess)} to buy an item"
      end
    else
      puts 'Item soldout'
    end
  end
  def process_commands
    puts 'Enter command eg. "help".'
    loop do
      print '> '
      cmd = gets.chomp
      
      if ['exit', 'quit','close'].include?(cmd)
        break
      elsif cmd.is_number?
        index = cmd.to_i
        if @items_list[index]
            purchase index
        else
          puts "Not item with the number: \"#{cmd}\""
        end
      elsif cmd=='help'
        help
      elsif Coins.get_codes.has_value?(cmd)
        insert_money(cmd)
      elsif Commands.get_commands.key?(cmd)
        send Commands.get_commands[cmd].to_sym
      else
        puts "Entered command does not exist"
      end
    end
  end


end

class String
  def is_number?
    true if Integer(self) rescue false
  end
end

def create_and_fill_machine
  machine = Machine.new
  machine.add_item('Juicy Fruit', 0.65, 3)
  machine.add_item('Lays', 1.00, 2)
  machine.add_item('Pepsi', 1.50, 4)
  machine.add_money_to_the_machine(0.05, 5)
  machine.add_money_to_the_machine(0.10, 3)
  machine.add_money_to_the_machine(0.50, 4)
  machine.add_money_to_the_machine(1.00, 2)
  machine
end

if $PROGRAM_NAME == __FILE__
  machine = create_and_fill_machine
  machine.process_commands
end
