jQuery(document).ready ->
  if $('#new_crew_member').length > 0
    $('#new_crew_member').click () ->
      size = $('#new_crew_member').parent().parent().find('ul.crew_member').length
      entry_form_id = $('#entry_entry_form_id').val()
      $.get "/admin/entries/new_crew_member", {i: size, entry_form_id: entry_form_id}, (data) ->
        $('#new_crew_member').parent().before($(data).find('ul.crew_member'))
      false

  setChargeTotal = () ->
    entry_form_id = $('#entry_entry_form_id').val()
    charge_ids = []
    charge_values = {}
    # handle radios and checkboxes
    charge_ids.push($(el).val()) for el in $('#charges').find('input:checkbox:checked, input:radio:checked') 

    # handle select boxes
    for el in $('#charges').find('select')
      if charge_id = $(el).data('charge-id')
        charge_ids.push(charge_id)
        charge_values[charge_id] = $(el).find('option:selected').val()
        select_els = $(el)

    is_frontend = !!($('body.controller-entries').length > 0)

    $.get "/entries/charge_total", {is_frontend: is_frontend, entry_form_id: entry_form_id, charge_ids: charge_ids, charge_values: charge_values}, (data) ->
      $('p.charge_total span.total_value').html(data)

  if $('form.entry').length > 0
    setChargeTotal()
    $('#charges').find('input, select').click 'change', () -> 
      setChargeTotal()
    
  # changing boat class to "Other" should enable specify class
  if $("#entry_boat_class_id").length > 0
    $("#entry_boat_class_id").change ->
      boat_class = $(this).find("option:selected").text()
      if boat_class == 'Other'
        $('#entry_boat_class_specific_input').show()
      else
        $('#entry_boat_class_specific_input').hide()


  $('a.entry_conditions_opener').fancybox()
  $('a.refund_policy_opener').fancybox()