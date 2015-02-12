require './lita-rubynewbies'

Lita.configure do |config|
  # The name your robot will use.
  config.robot.name = "RubyNewbiesBot"

  # The locale code for the language to use.
  # config.robot.locale = :en

  # The severity of messages to log. Options are:
  # :debug, :info, :warn, :error, :fatal
  # Messages at the selected level and above will be logged.
  config.robot.log_level = :info
  config.robot.admins = ["U03KRFLDS"]
  
  
  if ENV["RACK_ENV"]=="production"
    config.redis[:url] = ENV["REDISTOGO_URL"]
    config.http.port = ENV["PORT"]
    config.adapters.slack.token = ENV['SLACK_TOKEN']
    config.robot.adapter = :slack
  else
    config.adapters.slack.token = ""
    config.robot.adapter = :shell
  end
  end
