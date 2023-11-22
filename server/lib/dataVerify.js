const dataVerifyModel = {
  accVerify: data => {
    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,20}$/
    return regex.test(data)
  },
  pwdVerify: data => {
    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,20}$/
    return regex.test(data)
  },
  dateVerify: (year, month, day) => {
    const date_arr = [year, month - 1, day]
    const utcTimestamp = Date.UTC(year, month - 1, day)
    const date_f = new Date(utcTimestamp)
    return (
      date_f.getFullYear() == parseInt(date_arr[0]) &&
      date_f.getMonth() == parseInt(date_arr[1]) &&
      date_f.getDate() == parseInt(date_arr[2]) &&
      date_f < new Date() &&
      (new Date() - date_f) / (1000 * 60 * 60 * 24 * 365) < 150
    )
  },
  celphoneVerify: data => {
    const regex = /^[09][0-9]{8}$/
    return regex.test(parseInt(data))
  },
  mailVerify: data => {
    const regex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}/
    return regex.test(data)
  },

  addressSplite: data => {
    data = data || ''
    const regex = /^(.*?[縣市])(.*?[鄉鎮市區])(.*)$/
    const matches = data.match(regex)

    if (matches) {
      const county = matches[1].replace(/台/g, '臺')
      const district = matches[2]
      const remaining = matches[3]

      const resultArray = { city: county, town: district, remaining: remaining }
      return resultArray
    } else {
      return { city: '', town: '', remaining: '' }
    }
  },
}
module.exports = dataVerifyModel
