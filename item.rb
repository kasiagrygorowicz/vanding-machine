class Item
  attr_accessor :name, :price, :supply
  def initialize(name, price, supply)
    @name=name
    @price=price
    @supply=supply
  end

  def ==(other)
    if other.nil? ||!other.instance_of?(Item)
      false
    else
      name==other.name&&price==other.price
    end
  end

  alias eql? ==
  def hash
    [name,price].hash
  end

end


 