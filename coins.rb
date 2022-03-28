class Coins
  attr_accessor :codes, :names
@@codes = {
  0.01=>'1gr',
  0.02=>'2gr',
  0.05=>'5gr',
  0.10=>'10gr',
  0.20=>'20gr',
  0.50=>'50gr',
  1.00=>'1zl',
  2.00=>'2zl'
}

  @@names = {
    0.01=>'1 grosz',
    0.02=>'2 grosze',
    0.05=>'5 groszy',
    0.10=>'10 groszy',
    0.20=>'20 groszy',
    0.50=>'50 groszy',
    1.00=>'1 zloty',
    2.00=>'2 zlote'
  }

  def self.get_codes; @@codes;end
  def self.get_names;@@names;end
  def self.code(value); @@codes[value]; end
  def self.currency(amount); "#{'%.2f zl' % amount}"; end
  def self.name(value); @@names[value]; end

  def self.to_s(value, quantity)
    s = "#{quantity} #{Coins.name(value)}"
  end
end
