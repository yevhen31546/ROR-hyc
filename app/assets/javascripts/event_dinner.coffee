$(document).ready ->

  if $('form.event_dinner_booking').length == 0
    return false

  $('.js-event-dinner-booking-select-quantity').change () ->
    getChargeTotal()

  getChargeTotal = () ->
    form_data = $('form.event_dinner_booking').serializeArray()
    $('.js-event-dinner-total-price').load '/events/' + globalEventId + '/dinner-booking/total_charge', form_data

  getChargeTotal()
