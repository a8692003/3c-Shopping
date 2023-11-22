$(document).ready(function () {
  // check account duplicate
  $('input[name=acc]').on('blur input', async function (e) {
    var inputText = $(this).val()
    if (inputText !== '') {
      try {
        const res = await $.ajax({
          type: 'POST',
          url: '/api/register/duplicateAcc',
          data: { acc: inputText },
          dataType: 'json',
        })

        if (res.err == 0) {
          $(this).closest('.box').next('.alert').remove()
        } else {
          showErrorInput(res.data)
        }
      } catch (err) {
        throw err
        console.log(err)
      }
    }
  })

  // register
  $('#formRegister').on('submit', async function (e) {
    e.preventDefault()
    var data = $('#formRegister').serializeArray()
    var serializedCheckBox = $('input:checkbox')
      .map(function () {
        return { name: this.name, value: this.checked ? true : false }
      })
      .get()

    var radios = {}
    $('input:radio').each(function () {
      var name = this.name
      var value = this.checked ? this.value : ''
      if (!radios.hasOwnProperty(name)) {
        radios[name] = { name: name, value: value }
      } else {
        radios[name].value = value
      }
    })
    var serializedRadio = []
    for (var key in radios) {
      if (radios.hasOwnProperty(key)) {
        serializedRadio.push(radios[key])
      }
    }

    // var result = [...data, serializedCheckBox[0], ...serializedRadio]
    var result = [...data, serializedCheckBox[0]]

    var values = toJson(result)
    try {
      const res = await $.ajax({
        type: 'POST',
        url: '/api/register',
        data: values,
        dataType: 'json',
      })

      if (res.err == 0) {
        $(this).off('submit')
        $(this).submit()
      } else {
        showErrorInput(res.data)
        console.log(res)
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  })

  let dataPhoto
  $('#formData').on('submit', async function (e) {
    e.preventDefault()
    var data = $('#formData').serializeArray()

    let serializedSelect = []
    $('select').each(function () {
      var name = this.name
      var value = this.value ? this.value : ''
      serializedSelect.push({ name: name, value: value })
    })
    var result = [...serializedSelect, ...data]

    var values = toJson(result)

    try {
      const res = await $.ajax({
        type: 'PUT',
        url: '/api/member/dataUpdate',
        data: {
          ...values,
          photo: dataPhoto || '',
        },
        dataType: 'json',
      })
      if (res.err == 0) {
        $(this).off('submit')
        $(this).submit()
      } else {
        if (res.message == undefined) {
          showErrorInput(res.data)
          console.log(res)
        } else {
          alert(res.message)
          location.reload()
        }
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  })

  $('#iptPhoto').on('change', function () {
    const reader = new FileReader()
    reader.onload = async function (e) {
      dataPhoto = e.target.result
      $('label[for=iptPhoto]').find('img').prop('src', dataPhoto)
    }
    reader.readAsDataURL($('#iptPhoto')[0].files[0])
  })
  //pwdChange
  $('#formPwdChage').submit(async function (e) {
    e.preventDefault()
    var data = $('#formPwdChage').serializeArray()
    var values = toJson(data)

    try {
      const res = await $.ajax({
        type: 'PUT',
        url: '/api/member/pwdChange',
        data: values,
        dataType: 'json',
      })

      if (res.err == 0) {
        $(this).off('submit')
        $(this).submit()
      } else {
        if (res.message == undefined) {
          showErrorInput(res.data)
        } else {
          $('.input_alert').remove()
          $('#alert').text(res.message)
        }
      }
    } catch (err) {
      throw err
      console.log(res)
    }
  })

  // collect prod btn
  $('.btnCollect').on('click', async function (e) {
    console.log('collect Btn')
    try {
      const res = await $.ajax({
        type: 'post',
        url: '/api/member/collectProd',
        data: {
          prod_id: $(this).attr('prod'),
          spec_id: $(this).attr('spec'),
        },
        dataType: 'json',
      })
      if (res.err == 0) {
        $(this).val(res.data.btn_text)
      } else {
        $(this).val('系統錯誤')
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  })

  $('form[id^=formCard]:not(form[id$=new])').on('submit', async function (e) {
    e.preventDefault()
    var data = $(this).serializeArray()
    var values = toJson(data)
    const cid = $(this).attr('card')
    try {
      const res = await $.ajax({
        type: 'PUT',
        url: '/api/member/editCard',
        data: { cid, ...values },
        dataType: 'json',
      })

      if (res.err == 0) {
        alert(res.message)
        location.reload()
      } else {
        alert(res.message)
        console.log(res)
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  })

  $('form[id$=new]').on('submit', async function (e) {
    e.preventDefault()
    var data = $(this).serializeArray()
    var values = toJson(data)
    try {
      const res = await $.ajax({
        type: 'POST',
        url: '/api/member/addCard',
        data: values,
        dataType: 'json',
      })

      if (res.err == 0) {
        alert(res.message)
        location.reload()
      } else {
        alert(res.message)
        console.log(res)
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  })
  $('.btnDelete').on('click', async function (e) {
    let checkDelete = confirm('確定刪除')
    if (!checkDelete) {
      return
    }
    const form = $(this).closest('form[id^=formCard]')
    form.find('input').prop('disabled', false)
    var data = form.serializeArray()
    var values = toJson(data)
    const cid = form.attr('card')
    try {
      const res = await $.ajax({
        type: 'DELETE',
        url: '/api/member/deleteCard',
        data: { cid, ...values },
        dataType: 'json',
      })

      if (res.err == 0) {
        alert(res.message)
        location.reload()
      } else {
        alert(res.message)
        console.log(res)
      }
    } catch (err) {
      throw err
      console.log(err)
    }
  })
  $('#btnAddNewCard').on('click', function (e) {
    $(this).hide()
    $('form[id$=new]').show()
  })
  //
  $('.star').on('click', function (e) {
    let grade = $(this).attr('value')
    const stars = $(this).closest('.stars')
    stars.attr('value', grade)
    stars.find('.star').each((index, element) => {
      $(element).find('i').removeClass('fa-star fa-star-o')
      $(element)
        .find('i')
        .addClass(index < grade ? 'fa-star' : 'fa-star-o')
    })
  })
  $('[id^=formComment]').on('submit', async function (e) {
    e.preventDefault()

    var data = $(this).serializeArray()
    var values = toJson(data)

    if (values.content.length >= 250) {
      let check = confirm('字數設超過上限，多於文字將自動刪除\n確定上傳?')
      if (!check) {
        return
      }
    }

    try {
      const res = await $.ajax({
        type: 'patch',
        url: '/api/member/commentUpdate',
        data: {
          order_id: $(this).attr('order'),
          prod_id: $(this).attr('prod'),
          spec_id: $(this).attr('spec'),
          grade: $(this).find('.stars').attr('value'),
          ...values,
        },
        dataType: 'json',
      })

      if (res.err == 0) {
        location.reload()
      } else {
        if (res.message == undefined) {
          showErrorInput(res.data)
          console.log(res)
        } else {
          alert(res.message)
          location.reload()
        }
      }
    } catch (err) {
      console.log(err)
    }
  })
  //
  $('#cancelOrder').on('click', async function (e) {
    let check = confirm('確定取消訂單?')
    if (!check) {
      return
    }

    try {
      const res = await $.ajax({
        type: 'PUT',
        url: '/api/member/cancelOrder',
        data: {
          order_id: $(this).attr('order'),
        },
        dataType: 'json',
      })

      if (res.err == 0) {
        location.reload()
      } else {
        if (res.message == undefined) {
          showErrorInput(res.data)
          console.log(res)
        } else {
          alert(res.message)
          location.reload()
        }
      }
    } catch (err) {
      console.log(err)
    }
  })
  //---------------------------

  function toJson(data) {
    var values = {}
    for (index in data) {
      values[data[index].name] = data[index].value
    }
    return values
  }
  function showErrorInput(datas) {
    $('.input_alert').remove()
    for (data of datas) {
      dom = `<div class='alert input_alert'><strong>${data.text}</strong></div>`
      $(`input[name=${data.input}]`).closest('.box').after(dom)
    }
  }
})
