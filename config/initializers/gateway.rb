GATEWAY_TYPE = 'Realex'
if Rails.env.production? # || Rails.env.staging?
  GATEWAY_CONFIG = { login: 'howthyachtclub', password: 'YX95eT1gp8', account: 'internet' }
else
  # GATEWAY_CONFIG = { login: 'lucidityie', password: '9WYmPV8duL', account: 'internettest' }
  GATEWAY_CONFIG = { login: 'howthyachtclubtest', password: 'secret', account: 'internet' }
end

# This doesnt seem to work anymore...
# ActiveMerchant::Billing::Gateway.wiredump_device = File.open("/tmp/realex.log", "a+")
# ActiveMerchant::Billing::Gateway.wiredump_device.sync = true  
