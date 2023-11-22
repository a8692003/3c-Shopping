$(document).ready(async function () {
  let addressData = await $.ajax({
    type: 'get',
    url: '/public/json/address.json',
    dataType: 'json',
  })

  addressData = addressData.filter(data => data.CityName != '釣魚臺' && data.CityName != '南海島')

  const cityVal = $('select[name=address_city]').attr('city')
  const townVal = $('select[name=address_area]').attr('town')

  for (city of addressData) {
    var newOption = $('<option>', {
      eng: city.CityEngName,
      value: city.CityName,
      text: city.CityName,
      selected: city.CityName == cityVal,
    })
    $('select[name=address_city]').append(newOption)
    if (cityVal && townVal && city.CityName == cityVal) {
      for (town of city.AreaList) {
        var newOption = $('<option>', {
          eng: town.AreaEngName,
          value: town.AreaName,
          text: town.AreaName,
          selected: town.AreaName == townVal,
        })
        $('select[name=address_area]').append(newOption)
      }
    }
  }

  $('select[name=address_city]').on('change', function (e) {
    let select = $(this).val()
    const city = addressData.find(data => data.CityName == select)
    $('select[name=address_area]').empty()
    const selectTitle = '<option value="" disabled hidden selected>鄉鎮市區</option>'
    $('select[name=address_area]').append(selectTitle)
    for (town of city.AreaList) {
      var newOption = $('<option>', {
        eng: town.AreaEngName,
        value: town.AreaName,
        text: town.AreaName,
      })
      $('select[name=address_area]').append(newOption)
    }
  })
})
