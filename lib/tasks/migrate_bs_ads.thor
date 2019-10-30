require './config/environment'  

class Migrate < Thor
  desc "bs_ads", "Migrate buy and sell ads"
  def bs_ads
    BsAd.all.each do |bs_ad|
      if bs_ad.approved?
        bs_ad.inactive_date = bs_ad.created_at + 2.months
        bs_ad.delete_date = bs_ad.created_at + 4.months
        bs_ad.status = 'active'
        bs_ad.save!
      end
    end
  end
end
