require 'rufus/scheduler'

class Robot

  EVERY_MONDAY_MIDDAY = '0 12 * * 1'

  def initialize subscriber
    @subscriber = subscriber
  end

  def work
    Rufus::Scheduler.start_new.cron EVERY_MONDAY_MIDDAY do
      do_the_thing
    end
  end

  def do_it_now
    Rufus::Scheduler.start_new.in '5s' do
      do_the_thing
    end
  end

  private

  def do_the_thing
    @subscriber.subscribe_everybody
  end

end

