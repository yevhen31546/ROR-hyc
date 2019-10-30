module PaymentItemsHelper
  def expiry_months 
    [['Expiry Month', ''], ['01 (Jan)', '01'], ['02 (Feb)', '02'], ['03 (Mar)', '03'], ['04 (Apr)', '04'], ['05 (May)', '05'], ['06 (Jun)', '06'], ['07 (Jul)', '07'], ['08 (Aug)', '08'], ['09 (Sep)', '09'], ['10 (Oct)', '10'], ['11 (Nov)', '11'], ['12 (Dec)', '12']]
  end

  def expiry_years
    [['Expiry Year', '']] + (Time.now.year..(Time.now.year + 10)).to_a.map {|x| [x] }
  end
end
