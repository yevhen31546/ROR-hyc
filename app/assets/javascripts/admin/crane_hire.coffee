$(document).ready ->

  # this is the datepicker to select dates where there is some booking happening
  if $('.ui-datepicker-chb-filter').length
    selectable_dates_str = $('.ui-datepicker-chb-filter').data('selectable-dates')
    selectable_dates = selectable_dates_str.split(',')

    $('.ui-datepicker-chb-filter').datepicker
      dateFormat: "dd-mm-yy",
      changeMonth: true,
      changeYear: true,
      beforeShowDay: (date) ->
        date = moment(date).format("DD-MM-YYYY")
        if (selectable_dates.indexOf(date) >= 0)
          # available
          return [true, 'available', 'Available'];
        else
          return [false, 'unavailable', 'Unavailable'];
