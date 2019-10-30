module CraneHireBookingHelper
  def setup_form_data
    @default_time_slots = CraneHireBooking.default_time_slots
    @crane_hire_prices = CraneHirePrice.scoped

    @cradle_price = @crane_hire_prices.cradles.first
    @cradle_period_options = [
      ["No", 0],
      ["1 Day" +

        "<span class='js_ch_member_prices'> - " +
        number_to_currency(@cradle_price.member_price) +
        " members</span>" +

        "<span class='js_ch_non_member_prices'> - " +
        number_to_currency(@cradle_price.non_member_price) +
        " non-members</span>".html_safe,
        1],
      # ["2 Day" +

      #   "<span class='js_ch_member_prices'> - " +
      #   number_to_currency(@cradle_price.member_price*2) +
      #   " members</span>" +

      #   "<span class='js_ch_non_member_prices'> - " +
      #   number_to_currency(@cradle_price.non_member_price*2) +
      #   " non-members</span>".html_safe,
      #   2]
    ]
  end
end