$(document).ready ->
  tide_dates = $("#tides").find(".datepicker")
  tide_dates.each (i, v) =>
    $(v).datepicker
      dateFormat: "dd/M/yy",
      changeMonth: true,
      changeYear: true,
      onSelect: (selectedDate) ->
        option = (if this.id == "tide-interval-start" then "minDate" else "maxDate")
        instance = $(this).data("datepicker")
        date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings)
        tide_dates.not(this).datepicker("option", option, date)
        updateTides()

  updateTides = () ->
    data = {from: $("#tide-interval-start").val(), to: $("#tide-interval-end").val()}

    if data["from"] && data["to"]
      request = $.get("/tides", data)
      request.success (data) ->
        $("#tides-information").html(data)

  updateTides() # run on page start
    