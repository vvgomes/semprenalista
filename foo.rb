module Parent
  def thing
    puts url
    @count = @count ? @count+1 : 0
    @count
  end

  def url
    'the url'
  end
end

module Mod
  extend Parent

  class Duck

    def show
      puts "duck shows #{Mod.thing}"
    end
  end

  class Goose

    def show
      puts "goose shows #{Mod.thing}"
    end
  end

end

d = Mod::Duck.new
g = Mod::Goose.new

d.show
d.show
d.show
d.show
g.show

