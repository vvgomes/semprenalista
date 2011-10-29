require 'rufus/scheduler'

class Robot

  def initialize subscriber
    @subscriber = subscriber
  end

  def work    
    do_the_thing if today_is_monday
  end

  def do_it_now
    do_the_thing
  end

  private

  def today_is_monday
    Time.now.wday == 1
  end

  def do_the_thing
    @subscriber.subscribe_everybody
  end

end

