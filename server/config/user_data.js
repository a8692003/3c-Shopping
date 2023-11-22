class MemberData {
  constructor(u_id, u_name, right, verified, mail, islog = true) {
    this.u_id = u_id
    this.u_name = u_name
    this.right = right
    this.verified = verified
    this.mail = mail
    this.islog = islog
  }
}
class ComparisonList {
  constructor(prod_id, spec_id) {
    this.compares.push({ prod_id: prod_id, spec_id: spec_id })
  }
  // addCompare(prod_id, spec_id) {
  //   this.compares.push({ prod_id: prod_id, spec_id: spec_id })
  // }
}
class UserSetting {
  constructor(darkmode = false) {
    this.darkmode = darkmode
  }
}
module.exports = {
  MemberData,
  ComparisonList,
  UserSetting,
}
