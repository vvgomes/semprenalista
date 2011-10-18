require 'rufus/scheduler'

class Robot

  EVERY_MONDAY_MIDDAY = '0 12 * * 1'

  def initialize subscriber
    @subscriber = subscriber
  end

  def work
    Rufus::Scheduler.start_new.cron EVERY_MONDAY_MIDDAY do
      @subscriber.subscribe_everybody
    end
  end

end

