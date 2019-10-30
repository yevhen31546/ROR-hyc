$(document).ready ->

  if $('.js-ch-membership-change').length == 0
    return false

  checkShowCradle = () ->
    crane_size = $('.js-ch-size-change:checked').val()
    if (crane_size and crane_size.length)
      if (crane_size == 'small')
        $('.js-cradle-available-fields').find('input').attr('disabled', true)
        $('.js-cradle-available-fields').hide();
        $('.js-ch-cradle-unavailable-msg').show()
        enableAvailabilityTimeSlotSearch()
      else
        $('.js-cradle-available-fields').find('input').removeAttr('disabled')
        $('.js-cradle-available-fields').show();
        $('.js-ch-cradle-unavailable-msg').hide()
        checkShowAvailabilityBasedOnCradle()
    else # no crane size specified
      $('.js-cradle-available-fields').find('input').attr('disabled', true)
      $('.js-cradle-available-fields').hide();
      $('.js-ch-cradle-unavailable-msg').show()


  # customiseExtraPricing
  togglePricesByMembership = () ->
    if ($('.js-ch-membership-change:checked').length)
      is_member = ($('.js-ch-membership-change:checked').val() == 'true');
      active_price_selector = (if is_member then 'js_ch_member_prices' else 'js_ch_non_member_prices')
      inactive_price_selector = (if is_member then 'js_ch_non_member_prices' else 'js_ch_member_prices')

      if is_member
        $('.js-ch-size-change').filter("[value='small']").parent().show()
      else
        $('.js-ch-size-change').filter("[value='small']").parent().hide()

        if $('.js-ch-size-change').filter("[value='small']").is(':checked')
          $('.js-ch-size-change').filter("[value='big']").prop('checked', true)

      $('.'+active_price_selector).show()
      $('.'+inactive_price_selector + ':not(.' + active_price_selector + ')').hide()

  handleCraneSizeChange = () ->
    stated_crane_size = parseFloat($('.js-ch-loa').val().replace(/[^\d.]/g, ''));

    if stated_crane_size > 0
      found_bucket_size = convertToCraneSizeBucket(stated_crane_size)
      $('.js-ch-crane-price').css('opacity', '0.6')
      $('.js-ch-crane-price').find('input').attr('disabled', true).removeProp('checked')
      active_bucket_size_el = $('.js-ch-crane-price[data-size="'+found_bucket_size+'"]')
      active_bucket_size_el.css('opacity', '1')
      active_bucket_size_el.find('input').removeAttr('disabled').prop('checked', true)
    else
      $('.js-ch-crane-price').css('opacity', '1')
      $('.js-ch-crane-price').find('input').removeAttr('disabled')

  convertToCraneSizeBucket = (stated_crane_size) ->
    found_bucket_size = null
    i = 0
    all_buckets = $('.js-ch-crane-price[data-size]').toArray()
    while !found_bucket_size && all_buckets[i]
      sizes = $(all_buckets[i]).data('size')
      [min, max] = sizes.split('-')
      up_to_size = (sizes.includes('Upto') && parseFloat(sizes.replace(/[^\d.]/g, '')) >= stated_crane_size)
      is_between_sizes = (sizes.includes('-') && ((parseFloat(min.replace(/[^\d.]/g, '')) <= stated_crane_size) && (parseFloat(max.replace(/[^\d.]/, '')) >= stated_crane_size)))
      above_size = (sizes.includes('Over') && parseFloat(min.replace(/[^\d.]/g, '')) < stated_crane_size)
      if up_to_size or is_between_sizes or above_size
        found_bucket_size = sizes
        break
      i++

    return found_bucket_size

  disableAvailabilityFieldset = () ->
    $('.js-crane-hire-availability-fieldset').hide()

  enableAvailabilityFieldset = () ->
    $('.js-crane-hire-availability-fieldset').show()

  availability_time_slot_el = $('.js-crane-hire-availability-time-slot-search')

  enableAvailabilityTimeSlotSearch = () ->
    availability_time_slot_el.show()
    availability_time_slot_el.find('input').removeAttr('disabled')

  disableAvailabilityTimeSlotSearch = () ->
    availability_time_slot_el.hide()
    availability_time_slot_el.find('input').attr('disabled', true)

  checkShowAvailabilityBasedOnCradle = () ->
    cradle_period = $('.js-cradle-period-change:checked').val()
    setUnavailableDays(cradle_period)
    if (cradle_period && cradle_period == '0') or $('.js-cradle-period-change').attr('disabled') == 'disabled'
      enableAvailabilityTimeSlotSearch()
    else
      disableAvailabilityTimeSlotSearch()

  unavailable_days = []

  setUnavailableDays = (cradle_period) ->
    if (cradle_period == '0')
      unavailable_days = []
    else if (cradle_period == '1')
      unavailable_days = cradle_unavailable_days_by_cradle_period['single']
    else if (cradle_period == '2')
      unavailable_days = cradle_unavailable_days_by_cradle_period['double']
    else
      unavailable_days = []
    refreshDatePicker()


  datepicker_el = $('.js-crane-hire-datepicker')
  initCraneHireDatePicker = () ->
    datepicker_el.datepicker
      dateFormat: "dd-mm-yy",
      changeMonth: true,
      minDate: "+0D",
      maxDate: "+1Y",
      changeYear: true,
      onSelect: (selectedDate) ->
        # option = (if this.id == "tide-interval-start" then "minDate" else "maxDate")
        # instance = $(this).data("datepicker")
        # date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings)
        # tide_dates.not(this).datepicker("option", option, date)
        doAvailabilityTimeSlotSearch(selectedDate)
      beforeShowDay: (date) ->
        date = moment(date).format("DD-MM-YYYY")
        if (unavailable_days.indexOf(date) < 0)
          # available
          return [true, 'available', 'Available'];
        else
          return [false, 'unavailable', 'Unavailable'];

  refreshDatePicker = () ->
    datepicker_el.datepicker("destroy");
    initCraneHireDatePicker()
    datepicker_el.datepicker('refresh')

  doAvailabilityTimeSlotSearch = (date) ->
    date = (if date then date else datepicker_el.val())
    crane_size = $('.js-ch-size-change:checked').val()
    if date and crane_size
      $.get '/crane-booking/time_slots', {date: date, crane_size: crane_size}, (result) ->
        $('.js-crane-hire-availability-time-slot-search').html(result)

  getChargeTotal = () ->
    form_data = $('form.crane_hire_booking').serializeArray()
    $('.js-crane-hire-total-price').load '/crane-booking/total_charge', form_data

  #### do stuff on load
  checkShowCradle()

  togglePricesByMembership()

  $('.js-ch-membership-change').click 'change', () ->
    togglePricesByMembership()
    getChargeTotal()

  $('.js-ch-size-change').change () ->
    doAvailabilityTimeSlotSearch()
    checkShowCradle()
    getChargeTotal()

  $('.js-ch-loa').change () ->
    handleCraneSizeChange()
    getChargeTotal()

  handleCraneSizeChange()

  $('.js-cradle-period-change').change () ->
    checkShowAvailabilityBasedOnCradle()
    getChargeTotal()

  $('.js-crane-hire-extra-select').change () ->
    getChargeTotal()

  checkShowAvailabilityBasedOnCradle()

  initCraneHireDatePicker()

  getChargeTotal()

  # more info
  $('.booking-more-info-opener').click (e) ->
    e.preventDefault()
    if ($('.booking-more-info-wrapper').hasClass('hide'))
      $(this).html($(this).html().replace('+', '-'))
      $('.booking-more-info-wrapper').removeClass('hide')
    else
      $(this).html($(this).html().replace('-', '+'))
      $('.booking-more-info-wrapper').addClass('hide')
