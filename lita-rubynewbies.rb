require 'openssl'
require 'geokit'
require 'timezone'
require 'nearest_time_zone'

module Lita
  module Handlers
    class RubyNewbies < Handler
      route(/(?:next meetup) (.+)/, :meetup, command: true, help: { "meet up" => "Show me the next meetup" })
      route(/(?:next meetup)(?!.)/, :meetup_local, command: true, help: { "meet up" => "Show me the next meetup" })

      def meetup(response)
        location = response.matches.join("")
        response.reply(get_timezone(location, response.user.name))
      end
      
      def meetup_local(response)
        response.reply(msg_next_meetup(response.user.metadata["tz"],response.user.name))
      end
      
      
      def get_timezone(city, user)
        res = Geokit::Geocoders::GoogleGeocoder.geocode(city)
        timezone_name = NearestTimeZone.to(res.lat, res.lng)
        msg_next_meetup(timezone_name, user)
      end
      
      def msg_next_meetup(city, user)
        timezone = Timezone::Zone.new :zone => city
        
        next_date = timezone.time_with_offset(Time.new(2015, 02, 18, 22))
        
        rest = next_date - timezone.time_with_offset(Time.now)
        mm, ss = rest.divmod(60)
        hh, mm = mm.divmod(60)
        dd, hh = hh.divmod(24)
        
        return "Hey @#{user} our next meetup will take place on #{next_date.strftime("%F %H:%M")} (Your Timezone: #{city}). \n Thats only %d day, %d hours and %d minutes left :thumbsup:" % [dd, hh, mm]
      end
    end
    Lita.register_handler(RubyNewbies)
  end
end