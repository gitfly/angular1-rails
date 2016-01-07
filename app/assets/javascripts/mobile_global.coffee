jQuery ->
  getDistricts = (select) ->
    $.get('/api/v1/addresses/districts', city: select.val()).done (data) ->
      district = select.parents(".address-select:first").find('select.district')
      district.empty()
      $.each data, (i) ->
        district.append $('<option></option>').attr('value', data[i]).text(data[i])
        return
      return

  $('.address-select .province').change(->
    select = $(this)

    $.get('/api/v1/addresses/cities', province: select.val()).done (data) ->
      city = select.parents(".address-select:first").find('select.city')
      city.empty()
      $.each data, (i) ->
        city.append $('<option></option>').attr('value', data[i]).text(data[i])
        return

      if data.length == 1
        city.find('option').each (option) ->
          option.selected = option.text == data[0]
      getDistricts(city)
      return
  )

  $('.address-select .city').change(->
    getDistricts($(this))
  )
