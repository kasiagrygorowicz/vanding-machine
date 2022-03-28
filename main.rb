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
    puts "Pieniądze w maszynie #{Coins.currency(@money_inserted)}"
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
    puts 'Maszyna przechowuje monety:'
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
    puts '  pomoc - pokazuje menu programu'
    puts '  exit/quit/close/zakoncz - konczy dzialanie programu'
    puts '  A - pokazuje liste produktow w maszynie'
    puts '  B - pokazuje stan monet znajdujacych sie w maszynie'
    puts '  C - pokazuje ile pieniedzy juz wrzucono'
    puts '  D - zwraca wrzucone pieniadze'
    puts '  1gr - wrzuc 1 grosz'
    puts '  2gr - wrzuc 2 grosze'
    puts '  5gr - wrzuc 5 groszy'
    puts '  10gr - wrzuc 10 groszy'
    puts '  20gr - wrzuc 20 groszy'
    puts '  50gr - wrzuc 50 groszy'
    puts '  1zl - wrzuc 1 zloty'
    puts '  2zl - wrzuc 2 zlote'
    puts '  Aby kupic dany produkt wrzuc wystarczajaca liczbe pieniedzy i wybierz numer z listy odpowidajacy danemu produktowi'
  end

    
  def insert_money(coin)
    intCoin=Coins.get_codes.key(coin)
    @money_in_machine[intCoin] += 1
    @money_inserted =intCoin+ @money_inserted
  end

  def cr
    change = make_change
    puts "Zwrocone pieniadze:"
    if change
      change.each do |value|
        puts Coins.code(value)
        remove_coin_from_the_machine(value)
      end
      @money_inserted = 0
    else
      puts "Nie mozna zwrocic pieniedzy poniewaz wczesniej zadnych nie dodano"
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
          puts "Kupiony produkt: "+item.name
          item.supply -= 1
          @items_list.delete(selector) if item.supply == 0
          # puts selector
        else
          puts "Nie mozna bylo wydac reszty, brak wystarczajacej liczby monet w automacie"
        end
      else
        puts "Wrzuc dodatkowe #{Coins.currency(-excess)} aby dokonac zakupu"
      end
    else
      puts 'Produkt wyprzedany'
    end
  end
  def process_commands
    puts 'Podaj komende np. "pomoc".'
    loop do
      print '> '
      cmd = gets.chomp
      
      if ['exit', 'quit','zakoncz','close'].include?(cmd)
        break
      elsif cmd.is_number?
        index = cmd.to_i
        if @items_list[index]
            purchase index
        else
          puts "Nie ma produktu o numerze: \"#{cmd}\""
        end
      elsif cmd=='pomoc'
        help
      elsif Coins.get_codes.has_value?(cmd)
        insert_money(cmd)
      elsif Commands.get_commands.key?(cmd)
        send Commands.get_commands[cmd].to_sym
      else
        puts "Podana komenda nie istnieje"
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
  machine.add_money_to_the_machine(0.20, 4)
  machine.add_money_to_the_machine(1.00, 2)
  machine
end

if $PROGRAM_NAME == __FILE__
  machine = create_and_fill_machine
  machine.process_commands
end