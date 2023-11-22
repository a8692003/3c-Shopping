const bcrypt = require('bcrypt')
const fs = require('fs')
const path = require('path')
const conn = require('../../config/db')
const { Success, Error } = require('../../config/response')
const {
  pwdVerify,
  dateVerify,
  celphoneVerify,
  mailVerify,
  addressSplite,
} = require('../../lib/dataVerify')

const ToCurrency = require('../../lib/toCurrency')

const MemberModel = {
  dataRender: async uid => {
    try {
      const sql =
        'SELECT user_id ,name,phone,birth,address,email,verified,IFNULL(photo,"")AS photo FROM combuy.user WHERE user_id = ?'
      const result = await conn.queryAsync(sql, uid)

      if (result.length == 1) {
        var data = { ...result[0], ...addressSplite(result[0].address) }
        data.user_id = data.user_id.toString().padStart(8, '0')
        const birthDate = new Date(data.birth)
        data.year = data.birth ? birthDate.getFullYear() : ''
        data.month = data.birth ? birthDate.getMonth() + 1 : ''
        data.day = data.birth ? birthDate.getDate() : ''
        delete data.birth
        return new Success(data)
      } else {
        return new Error('data failed')
      }
    } catch (err) {
      throw err
      return new Error(err)
    }
  },
  dataUpdateAPI: async (uid, data) => {
    let errorInputs = []
    const { name, year, month, day, phone, mail, address_city, address_area, address, photo } = data

    if (name == '') {
      errorInputs.push({
        input: 'name',
        text: '姓名不可為空',
      })
    }

    if (Number.isInteger(year)) {
      errorInputs.push({
        input: 'year',
        text: '年分輸入錯誤',
      })
    }
    if (Number.isInteger(month)) {
      errorInputs.push({
        input: 'month',
        text: '月份輸入錯誤',
      })
    }
    if (Number.isInteger(day)) {
      errorInputs.push({
        input: 'day',
        text: '日期輸入錯誤',
      })
    }
    if (!dateVerify(year, month, day)) {
      errorInputs.push({
        input: 'year',
        text: '日期資料錯誤',
      })
    }

    if (!celphoneVerify(parseInt(phone))) {
      errorInputs.push({
        input: 'phone',
        text: '手機號碼錯誤',
      })
    }

    if (!mailVerify(mail)) {
      errorInputs.push({
        input: 'mail',
        text: '電子信箱格式錯誤',
      })
    }

    if (errorInputs.length > 0) {
      return new Error(errorInputs)
    }
    let uniqueFileName
    let originalFile

    try {
      sql = 'SELECT IFNULL(photo,"") AS photo FROM user WHERE user_id = ?  '
      const result = await conn.queryAsync(sql, uid)
      originalFile = result[0].photo

      if (photo) {
        const base64Data = photo

        const binaryData = base64Data.replace(/^data:image\/\w+;base64,/, '')
        let extension
        const parts = base64Data.split(';')
        if (parts.length === 2) {
          const mimePart = parts[0].trim()
          extension = mimePart.split('/')[1]
        }
        const dataBuffer = Buffer.from(binaryData, 'base64')

        uniqueFileName = 'image_' + uid + '_' + Date.now() + '.' + extension

        const storagePath = 'public/images/user/'

        fs.writeFile(storagePath + uniqueFileName, dataBuffer, 'binary', err => {
          if (err) {
            console.error(err)
            return new Error('保存文件失敗')
          }
        })

        if (originalFile) {
          console.log(path.dirname(require.main.filename))
          fs.unlink(path.dirname(require.main.filename) + '/public' + originalFile, err => {
            console.log(err)
          })
        }
      }

      sql2 =
        'UPDATE user SET name = ? , phone = ? , email = ? , birth = ? , address = ? , photo = ? WHERE user_id = ?  '
      const result2 = await conn.queryAsync(sql2, [
        name,
        phone,
        mail,
        year + '-' + month + '-' + day,
        address_city + address_area + address,
        photo ? '/images/user/' + uniqueFileName : originalFile,
        uid,
      ])
      return new Success('OK')
      // return new Success(result2)
    } catch (err) {
      throw err
      console.log(err)
    }
  },
  authRender: async uid => {
    try {
      const sql =
        'SELECT 	google_auth_id,	google_auth_mail,	facebook_auth_id,	facebook_auth_mail FROM combuy.user WHERE user_id = ?'
      const result = await conn.queryAsync(sql, uid)
      if (result.length == 1) {
        return new Success(result[0])
      } else {
        return new Error('data failed')
      }
    } catch (err) {
      // throw err
      console.log(err)
    }
  },
  pwdChangeAPI: async (uid, data) => {
    let errorInputs = []
    const { o_pwd, pwd, pwdCheck } = data

    if (!pwdVerify(pwd)) {
      errorInputs.push(
        { input: 'pwd', text: '輸入 8 - 20 字，並至少含有一個大寫英文、小寫英文、數字' },
        { input: 'pwdCheck', text: '輸入 8 - 20 字，並至少含有一個大寫英文、小寫英文、數字' }
      )
    } else if (pwd != pwdCheck) {
      errorInputs.push({
        input: 'pwdCheck',
        text: '密碼輸入不相符',
      })
    }
    if (errorInputs.length > 0) {
      return new Error(errorInputs)
    }
    try {
      const sql1 = 'select pwd,change_pwd_time from user where user_id =?'
      const result1 = await conn.queryAsync(sql1, [uid])
      console.log(result1)
      if (result1.length == 1) {
        if (result1[0].pwd == '') {
          const hashPwd = bcrypt.hashSync(pwd, 10)
          const sql2 =
            'update user set pwd = ? ,change_pwd_time= current_timestamp()	 where user_id =?'
          const result2 = await conn.queryAsync(sql2, [hashPwd, uid])
          return new Success(result2)
        } else {
          if (Math.floor(new Date() - result1[0].change_pwd_time) / (1000 * 3600 * 24) < 14) {
            return new Error('需與上次修改時間相個兩個禮拜以上')
          } else {
            if (bcrypt.compareSync(o_pwd, result1[0].pwd)) {
              const hashPwd = bcrypt.hashSync(pwd, 10)
              const sql2 =
                'update user set pwd = ? ,change_pwd_time= current_timestamp()	 where user_id =?'
              const result2 = await conn.queryAsync(sql2, [hashPwd, uid])
              return new Success(result2)
            } else {
              errorInputs.push({
                input: 'o_pwd',
                text: '密碼輸入錯誤',
              })
              return new Error(errorInputs)
            }
          }
        }
      } else {
        return new Error('預期外錯誤')
      }
    } catch (err) {
      throw err
      return new Error(err)
    }
  },
  cardRender: async (uid, data) => {
    const sql1 = 'SELECT COUNT(*) AS total FROM card WHERE user_id = ?'
    const sql2 = 'SELECT *  FROM card WHERE user_id = ?'
    const result1 = await conn.queryAsync(sql1, uid)
    const result2 = await conn.queryAsync(sql2, uid)

    for (let data of result2) {
      data.nums = []
      for (let i = 0; i < data.card_num.length; i += 4) {
        data.nums.push(data.card_num.substring(i, i + 4))
      }
    }
    return new Success({
      ...result1[0],
      cards: result2,
    })
  },
  addCradAPI: async (uid, data) => {
    const { card_1, card_2, card_3, card_4, expiry_date, security_code } = data

    if (
      card_1.length != 4 ||
      card_2.length != 4 ||
      card_3.length != 4 ||
      card_4.length != 4 ||
      expiry_date.length != 4 ||
      security_code.length != 3
    ) {
      return new Error('輸入錯誤')
    }
    try {
      const result1 = await MemberModel.checkCardNumDupliacte(
        card_1 + card_2 + card_3 + card_4,
        '',
        '',
        '',
        uid
      )
      if (result1.count == 1) {
        return new Error('此卡片已被登記')
      }
      const sql =
        'INSERT INTO card(card_num, expiry_date, security_code, user_id) VALUES ( ? , ? , ? , ? )'
      const result2 = await conn.queryAsync(sql, [
        card_1 + card_2 + card_3 + card_4,
        expiry_date,
        security_code,
        uid,
      ])
      return new Success('新增成功')
    } catch (err) {
      throw err
      console.log(err)
    }
  },
  editCardAPI: async (uid, data) => {
    const { card_1, card_2, card_3, card_4, expiry_date, security_code, cid } = data
    if (
      card_1.length != 4 ||
      card_2.length != 4 ||
      card_3.length != 4 ||
      card_4.length != 4 ||
      expiry_date.length != 4 ||
      security_code.length != 3
    ) {
      return new Error('輸入錯誤')
    }
    try {
      const result = await MemberModel.checkCardNumDupliacte('', '', '', cid, uid)
      if (result.count == 0) {
        return new Error('查無卡片')
      }
      const sql1 =
        'UPDATE card SET card_num = ? , expiry_date = ? , security_code = ?  WHERE user_id = ? AND card_id = ?'
      const result1 = await conn.queryAsync(sql1, [
        card_1 + card_2 + card_3 + card_4,
        expiry_date,
        security_code,
        uid,
        cid,
      ])
      return new Success('修改成功')
    } catch (err) {
      throw err
      console.log(err)
    }
  },
  deleteCardAPI: async (uid, data) => {
    const { card_1, card_2, card_3, card_4, expiry_date, security_code, cid } = data
    try {
      const result = await MemberModel.checkCardNumDupliacte(
        card_1 + card_2 + card_3 + card_4,
        expiry_date,
        security_code,
        cid,
        uid
      )
      if (result.count == 0) {
        return new Error('查無卡片')
      }
      const sql1 = 'DELETE FROM card WHERE user_id = ? AND card_id = ?'
      const result1 = await conn.queryAsync(sql1, [uid, cid])
      return new Success('刪除成功')
    } catch (err) {
      throw err
      console.log(err)
    }
  },
  orderlistRender: async (uid, page) => {
    const sql = 'SELECT COUNT(*) AS total FROM vw_order_info WHERE user_id = ?'
    const result1 = await conn.queryAsync(sql, [uid])
    const result2 = await MemberModel.getOrderinfo(uid, '', page - 1)
    return new Success({
      ...result1[0],
      orders: result2,
      max_pages: Math.ceil(result1[0].total / 5) || 1,
    })
  },
  orderRender: async (uid, order_id) => {
    try {
      const result = await MemberModel.getOrderinfo(uid, order_id)
      if (result.length == 1) {
        return new Success({ orders: result })
      } else {
        return new Error('data Error')
      }
    } catch (err) {
      throw err
    }
  },
  cancelOrderAPI: async (uid, order_id) => {
    const sql = 'UPDATE orders SET state = 0   WHERE user_id = ? AND order_id = ?'
    const result = await conn.queryAsync(sql, [uid, order_id])
    console.log(result)
    return new Success(result[0])
  },
  collectRender: async (uid, page) => {
    try {
      const sql1 = 'SELECT COUNT(*) AS total FROM collect WHERE collect.user_id = ?'
      const result1 = await conn.queryAsync(sql1, [uid])
      const result2 = await MemberModel.getCollectDetail(uid, page - 1)

      return new Success({
        ...result1[0],
        collects: result2,
        max_pages: Math.ceil(result1[0].total / 5) || 1,
      })
    } catch (err) {
      throw err
      return new Error(err)
    }
  },
  collectProdAPI: async (uid, prod_id, spec_id) => {
    try {
      const sql1 =
        'SELECT count(*) AS count FROM vw_products_info WHERE prod_id = ? AND spec_id =? AND publish = 1'
      const result1 = await conn.queryAsync(sql1, [prod_id, spec_id])

      if (result1[0].count == 0) {
        return new Error('查無該商品')
      }
      const sql2 =
        'SELECT count(*) as count FROM collect WHERE user_id = ? AND prod_id = ? AND spec_id= ?'
      const result2 = await conn.queryAsync(sql2, [uid, prod_id, spec_id])

      if (result2[0].count == 0) {
        // 無收藏紀錄，收藏
        const sql3 = 'INSERT INTO collect( user_id , prod_id , spec_id ) VALUES ( ? , ? , ? )'
        const result3 = await conn.queryAsync(sql3, [uid, prod_id, spec_id])

        return new Success({ type: true, message: '成功收藏', btn_text: '取消收藏' })
      } else {
        // 有收藏紀錄，刪除
        const sql3 = 'DELETE FROM collect WHERE user_id = ? AND prod_id = ? AND spec_id = ?'
        const result3 = await conn.queryAsync(sql3, [uid, prod_id, spec_id])

        return new Success({ type: false, message: '取消收藏', btn_text: '收藏商品' })
      }
    } catch (err) {
      throw err
    }
  },
  cartProdAPI: async (uid, prod_id, spec_id) => {
    try {
      const sql1 =
        'SELECT count(*) AS count FROM vw_products_info WHERE prod_id = ? AND spec_id =? AND publish = 1'
      const result1 = await conn.queryAsync(sql1, [prod_id, spec_id])

      if (result1[0].count == 0) {
        return new Error('查無該商品')
      }
      const sql2 =
        'SELECT inventory FROM vw_products_info WHERE prod_id = ? AND spec_id =? AND publish = 1'
      const result12 = await conn.queryAsync(sql2, [prod_id, spec_id])

      if (result12[0].inventory == 0) {
        return new Success({ type: false, message: '缺貨中', btn_text: '缺貨中' })
      }
      const sql3 =
        'SELECT count(*) as count FROM shopcart WHERE user_id = ? AND prod_id = ? AND spec_id= ?'
      const result3 = await conn.queryAsync(sql3, [uid, prod_id, spec_id])

      if (result3[0].count == 0) {
        // 無收藏紀錄，收藏
        const sql3 = 'INSERT INTO shopcart( user_id , prod_id , spec_id ) VALUES ( ? , ? , ? )'
        const result3 = await conn.queryAsync(sql3, [uid, prod_id, spec_id])

        return new Success({ type: true, message: '加入購物車', btn_text: '已加入購物車' })
      } else {
        // 有收藏紀錄，刪除
        const sql3 = 'DELETE FROM shopcart WHERE user_id = ? AND prod_id = ? AND spec_id = ?'
        const result3 = await conn.queryAsync(sql3, [uid, prod_id, spec_id])

        return new Success({ type: false, message: '移除購物車', btn_text: '加入購物車' })
      }
    } catch (err) {
      throw err
    }
  },
  commentRender: async (uid, page) => {
    try {
      const sql1 =
        'SELECT COUNT(*) AS total FROM vw_comment WHERE user_id = ? AND comment_time IS NOT NULL '
      const result1 = await conn.queryAsync(sql1, [uid])
      const result2 = await MemberModel.getCommentDetail(uid, page - 1)
      return new Success({
        ...result1[0],
        comments: result2,
        max_pages: Math.ceil(result1[0].total / 5) || 1,
      })
    } catch (err) {
      throw err
      return new Error(err)
    }
  },
  commentEditRender: async (uid, order_id, prod_id, spec_id) => {
    sql1 =
      'SELECT COUNT(*) AS total FROM  vw_comment WHERE user_id = ? AND (order_id = ? OR "" = ?) AND (prod_id = ? OR "" = ?) AND (spec_id = ? OR "" = ?) ORDER BY comment_time DESC'
    sql2 =
      'SELECT * FROM  vw_comment WHERE user_id = ? AND (order_id = ? OR "" = ?) AND (prod_id = ? OR "" = ?) AND (spec_id = ? OR "" = ?) ORDER BY comment_time DESC'

    try {
      const result1 = await conn.queryAsync(sql1, [
        uid,
        order_id,
        order_id,
        prod_id,
        prod_id,
        spec_id,
        spec_id,
      ])
      const result2 = await conn.queryAsync(sql2, [
        uid,
        order_id,
        order_id,
        prod_id,
        prod_id,
        spec_id,
        spec_id,
      ])
      for (data of result2) {
        data.comment_time = data.comment_time ? new Date(data.comment_time).toLocaleString() : ''
      }
      return new Success({
        ...result1[0],
        comments: result2,
      })
    } catch (err) {
      throw err
      console.log(err)
    }
  },
  commentUpdateAPI: async (uid, data) => {
    const { order_id, prod_id, spec_id, grade, content } = data

    sql1 =
      'SELECT COUNT(*) AS count FROM vw_comment WHERE user_id = ? AND order_id = ? AND prod_id = ? AND spec_id = ? '
    sql2 =
      'UPDATE order_product LEFT JOIN vw_comment ON order_product.order_id = vw_comment.order_id AND order_product.prod_id = vw_comment.prod_id AND vw_comment.spec_id = order_product.spec_id' +
      ' SET order_product.comment = ? , order_product.comment_grade = ? , order_product.comment_time = CURRENT_TIMESTAMP() ' +
      'WHERE user_id = ? AND order_product.order_id = ? AND order_product.prod_id = ? AND order_product.spec_id = ?'

    try {
      const result1 = await conn.queryAsync(sql1, [uid, order_id, prod_id, spec_id])
      if (result1[0].count != 1) {
        return new Error('update failed')
      }
      const result2 = await conn.queryAsync(sql2, [
        content.substr(0, 249),
        grade,
        uid,
        order_id,
        prod_id,
        spec_id,
      ])
      return new Success('update Success')
    } catch (err) {
      throw err
      console.log(err)
    }
  },

  //------------------------------
  getOrderinfo: async (uid, order_id = '', page = 0) => {
    try {
      const sql =
        'SELECT * FROM vw_order_info WHERE user_id = ? AND (order_id = ? OR "" = ?) LIMIT 5 OFFSET ?'

      const result = await conn.queryAsync(sql, [uid, order_id, order_id, page * 5])

      if (result.length === 0) {
        return result
      } else {
        for (let data of result) {
          const result = await MemberModel.getOrderDetail(uid, data.order_id)
          data.order_id = data.order_id.toString().padStart(8, '0')
          data.order_date = new Date(data.order_date).toLocaleString().replace(/ /g, '<br/>')
          data.total = 'NT $ ' + ToCurrency(data.total)
          data.state_name =
            data.state === 0 ? '訂單取消' : data.state === 1 ? '訂單成立' : '訂單完成'
          data.pay_name = data.pay === 0 ? '尚未付款' : '付款完成'
          data.pay_method_nmae = data.pay_method === 0 ? '銀行或郵局轉帳' : '信用卡(一次付清)'
          data.order_detail = result
        }
        return result
      }
    } catch (err) {
      throw err
      return err
    }
  },
  getOrderDetail: async (uid, order_id) => {
    try {
      const sql = 'SELECT * FROM vw_order_detail WHERE user_id = ? AND (order_id = ? OR "" = ? ) '
      const result = await conn.queryAsync(sql, [uid, order_id, order_id])
      if (result.length === 0) {
        return result
      } else {
        for (let data of result) {
          data.price = 'NT $ ' + ToCurrency(data.price)
          data.subtotal = 'NT $ ' + ToCurrency(data.subtotla)
        }
        return result
      }
    } catch (err) {
      throw err
      return err
    }
  },
  getCollectDetail: async (uid, page) => {
    try {
      const sql =
        'SELECT collect.prod_id, collect.spec_id, prod_name, spec_name, price, collect.update_time, publish, inventory,img_src FROM collect LEFT JOIN vw_products_info ON collect.prod_id = vw_products_info.prod_id AND collect.spec_id = vw_products_info.spec_id WHERE collect.user_id = ? ORDER BY collect.update_time DESC LIMIT 5 OFFSET ? '
      const result = await conn.queryAsync(sql, [uid, page * 5])
      for (let data of result) {
        data.price = 'NT $ ' + ToCurrency(data.price)
        data.update_time = new Date(data.update_time).toLocaleDateString()
      }
      return result
    } catch (err) {
      throw err
      return err
    }
  },
  getCommentDetail: async (uid, page) => {
    try {
      const sql = 'SELECT * FROM vw_comment WHERE user_id = ? AND comment <> "" LIMIT 5 OFFSET ?'
      const result = await conn.queryAsync(sql, [uid, page * 5])
      for (let data of result) {
        data.order_id = data.order_id.toString().padStart(8, '0')
        data.comment_time = new Date(data.comment_time).toLocaleString().replace(/ /g, '<br/>')
      }
      return result
    } catch (err) {
      throw err
      return err
    }
  },
  checkCardNumDupliacte: async (cardNum, e_d, s_c, cid, uid) => {
    try {
      const sql =
        'SELECT COUNT(*) AS count FROM card where ( card_num = ? OR "" =  ? ) AND ( expiry_date = ? OR "" =  ? ) AND ( security_code = ? OR "" =  ? ) AND ( card_id = ? OR "" = ? ) AND user_id = ?'
      const result = await conn.queryAsync(sql, [
        cardNum,
        cardNum,
        e_d,
        e_d,
        s_c,
        s_c,
        cid,
        cid,
        uid,
      ])
      return result[0]
    } catch (err) {
      throw err
      console.log(err)
    }
  },
}
module.exports = MemberModel
