require 'viewpoint'
include Viewpoint::EWS

class User < ActiveRecord::Base
  def events
    cli = Viewpoint::EWSClient.new($ews_url, self.name, self.password)

    utc_time_zone = ActiveSupport::TimeZone.new('UTC')
    start_time = Time.now.iso8601
    end_time = (Time.now + $avail_duration).iso8601

    begin
      user_free_busy = cli.get_user_availability([self.email.downcase],
        start_time: start_time,
        end_time:   end_time,
        requested_view: :free_busy)
    rescue => e
      Rails.logger.error "WES error on #{self.email.downcase}\n#{e}\n"
      return nil
    end
    
    tz = user_free_busy.working_hours.first[:time_zone][:elems] rescue []
    time_bias = ((tz[0][:bias][:text].to_i rescue 0) + (tz[1][:standard_time][:elems][0][:bias][:text].to_i rescue 0) + (tz[2][:daylight_time][:elems][0][:bias][:text].to_i rescue 0)).minutes
    events = user_free_busy.calendar_event_array.map do |event| 
      {
        :type=> cli.event_busy_type(event),
        :start_time=> utc_time_zone.parse(cli.event_start_time(event)) + time_bias,
        :end_time=> utc_time_zone.parse(cli.event_end_time(event)) + time_bias
      }
    end
    whs = user_free_busy.working_hours.last[:working_period_array][:elems][0][:working_period][:elems] rescue []
    day_of_week = whs[0][:day_of_week][:text].split(' ').map do |d|
      case d
        when "Sunday"
          0
        when "Monday"
          1
        when "Tuesday"
          2
        when "Wednesday"
          3
        when "Thursday"
          4
        when "Friday"
          5
        when "Saturday"
          6
      end
    end rescue []
    start_time = whs[1][:start_time_in_minutes][:text].to_i rescue 480
    end_time = whs[2][:end_time_in_minutes][:text].to_i rescue 1080
    
    {
      :email => self.email,
      :events => events,
      :time_zone => tz,
      :time_bias => (time_bias.to_i / 60),
      :working_hours => {
        :day_of_week => day_of_week,
        :start_time => start_time,
        :end_time => end_time
      }
    }
  end
end
