require "byebug"

module Adam
  def absolute_terror_field
    "Adam AT field"
  end

  def longinus
    super.upcase
  end
end

module Lilith
  def anti_absolute_terror_field
    "Lilith Anti AT field"
  end
end

class Eva
  include Adam
  extend Lilith

  attr_accessor :knife

  def initialize
    @knife = "Eva knife"
  end
end

class Angel
  extend Adam
  def self.longinus
    "Lance of Longinus for Angels"
  end
end

class EvaZero
  prepend Adam
  def longinus
    "Lance of Longinus"
  end

  def absolute_terror_field
    "EvaZero AT field"
  end
end

class EvaFirst
  include Lilith
end

class EvaSecond < Eva
  def initialize
    @knife = "EvaSecond knife"
  end

  def absolute_terror_field
    "EvaSecond AT field"
  end
end

def exec(m, code)
  puts m
  begin
    puts "#{code} result : #{yield}\n\n"
  rescue => e
    puts "#{code} is Failed : #{e.message}\n\n"
  end
end

puts "それぞれの実行メソッドと結果をコードを読みながら確認してください\n\n"

# コード変えたら行数も直す
puts "実行されるRubyコード\n#{`sed -n 3,60p /app/training/inheritance.rb`}\n\n"

exec("AdamをincludeしてるのでAdam#absolute_terror_fieldをインスタンスメソッドとして呼び出します", "Eva.new.absolute_terror_field") {
  Eva.new.absolute_terror_field
}

exec("LilithをextendしてるのでLilith#anti_absolute_terror_fieldをクラスメソッドとして呼び出します", "Eva.anti_absolute_terror_field") {
  Eva.anti_absolute_terror_field
}

exec("Adam#absolute_terror_fieldをクラスメソッドとして呼ぼうとしてるのでエラーになります", "Eva.absolute_terror_field") {
  Eva.absolute_terror_field
}

exec("Eva#initializeで初期化したknifeを呼び出します", "Eva.new.knife") {
  Eva.new.knife
}

exec("AdamをextendしてるのでAdam#absolute_terror_fieldをクラスメソッドとして呼び出します", "Angel.absolute_terror_field") {
  Angel.absolute_terror_field
}

exec("Adam#absolute_terror_fieldをインスタンスメソッドとして呼ぼうとしてるのでエラーになります", "Angel.new.absolute_terror_field") {
  Angel.new.absolute_terror_field
}

exec("longinusをオーバーライドしてるのでAngel#longinusが呼び出されます", "Angel.longinus") {
  Angel.longinus
}

exec("AdamをprependしてるのでAdam#absolute_terror_fieldを呼び出します", "EvaZero.new.absolute_terror_field") {
  EvaZero.new.absolute_terror_field
}

exec("AdamをprependしてるのでEvaZero#longinusがsuperで呼び出され全て大文字になります", "EvaZero.new.longinus") {
  EvaZero.new.longinus
}

exec("Lilithはabsolute_terror_fieldを定義していないのでエラーになります", "EvaFirst.new.absolute_terror_field") {
  EvaFirst.new.absolute_terror_field
}

exec("LilithをincludeしてるのでLilith#anti_absolute_terror_fieldをインスタンスメソッドとして呼び出します", "EvaFirst.new.anti_absolute_terror_field"){
  EvaFirst.new.anti_absolute_terror_field
}

exec("EvaFirstはknifeを定義していないのでエラーになります", "EvaFirst.new.knife") {
  EvaFirst.new.knife
}

exec("EvaSecondで定義したabsolute_terror_fieldを呼び出します", "EvaSecond.new.absolute_terror_field") {
  EvaSecond.new.absolute_terror_field
}

exec("Evaを継承してるのでLilith#anti_absolute_terror_fieldをクラスメソッドとして呼び出します", "EvaSecond.new.anti_absolute_terror_field"){
  EvaSecond.anti_absolute_terror_field
}

exec("EvaSecondで初期化したknifeを呼び出します", "EvaSecond.new.knife") {
  EvaSecond.new.knife
}
