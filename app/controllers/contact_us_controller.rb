class ContactUsController < ApplicationController

  def index
    @club_contacts = [
      ["Bar", nil, "832 0606", nil],
      ["Dining room", nil, "839 2100", "dining@hyc.ie"],
      ['Fax', nil, "839 2430", nil],
      ['General Manager', "Nic Parton", "832 2141", "nparton@hyc.ie"],
      ['General Office', nil, '832 2141', "office@hyc.ie"],
      ['Marine Manager', "Mark McGowan", '839 2777', "mmcgowan@hyc.ie"],
      ['Marina Office', nil, '839 2777', "marina@hyc.ie"],
      ['Coaching Development Manager', "Graeme Grant", '832 2141', "coaching@hyc.ie"]
    ]
  end

end
