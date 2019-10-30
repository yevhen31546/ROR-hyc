Airbrake.configure do |config|
  config.api_key = '6cc54b7084083eb932d04a713cb4296c'
  config.host    = 'errbit.lucidity.ie'
  config.port    = 80
  config.secure  = config.port == 443
end