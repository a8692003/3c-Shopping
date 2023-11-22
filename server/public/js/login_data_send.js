$(document).ready(function () {
  $('#formLogin').on('submit', async function (e) {
    e.preventDefault()
    const res = await $.ajax({
      type: 'POST',
      url: '/api/login',
      data: {
        acc: $('input[name = acc]').val(),
        pwd: $('input[name = pwd]').val(),
      },
      dataType: 'json',
    })

    if (res.err == 0) {
      $(this).off('submit')
      $(this).submit()
    } else {
      $('#alert').text(res.message)
    }
  })
})
