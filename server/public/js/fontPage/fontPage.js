//req herder select & herder select display block
$('input[name="search"]').on("keyup", function () {
  //herder select display block
  $("#search-result").css("display", "block");
  //req herder select
  $.ajax({
    type: "get",
    url: "/api/changeProduct/search",
    data: {
      search: $(this).val(),
    },
    success: async function (response) {
      let result = ``;
      response.forEach((prod) => {
        result += `<li><a href="/commodity/${prod.prod_id}/${prod.spec_id}">${prod.prod_name}</a></li>`;
      });

      result == ""
        ? (result = "<li><p>搜尋無結果</p></li>")
        : (result = result);
      $("#search-result>ul").html(result);
    },
  });
});
$("body").on("click", function () {
  $("#search-result").css("display", "none");
});

// 熱銷商品
$.ajax({
  type: "get",
  url: "/fontPage/getHotIndexProd",
  success: function (res) {
    var itemData = res;
    var itemsHtml = "";
    var globalProdId = [];
    var globalSpecId = [];
    for (var i = 0; i < itemData.length; i++) {
      globalProdId.push(itemData[i].prod_id);
      globalSpecId.push(itemData[i].spec_id);
      var item = itemData[i];
      itemsHtml += `
          <div class="card-item col-3">
            <a style="color: black; display:block;
            text-decoration: none;" href="/commodity/${item.prod_id}/${
        item.spec_id
      }">

            <div class="card-img">
              <img src="./public${item.img_src}" alt="">
            </div>
            <div style="align-items: start;" class="card-title">
              <p style="height:50px;font-size:20px;margin-bottom:0px " id="${
                item.prod_id
              }" class="prod_name">${item.prod_name}</p>
              <p style="font-size:18px;" id="${
                item.spec_id
              }" class="spec_name">${item.spec_name}</p>
                <div class="card-text">
                  <div class="card-price">
                    <p>NT ${item.price.toLocaleString()}</p>
                  </div>
                  <div class="card-icon">
                    <a class="favorite" 
                      data-prod-id="${item.prod_id}" 
                      data-spec-id="${item.spec_id}">
                      <svg class="heart-icon" xmlns="http://www.w3.org/2000/svg" width="38"height="34" viewBox="0 0 38 34" fill="none">
                        <path
                          d="M20.0048 31.8483C19.4318 32.0506 18.488 32.0506 17.9149 31.8483C13.0273 30.1798 2.10596 23.2191 2.10596 11.4213C2.10596 6.21348 6.30258 2 11.4767 2C14.5441 2 17.2576 3.48314 18.9599 5.77528C20.6621 3.48314 23.3925 2 26.443 2C31.6172 2 35.8138 6.21348 35.8138 11.4213C35.8138 23.2191 24.8924 30.1798 20.0048 31.8483Z"
                          stroke="black" stroke-width="3" stroke-linecap="round"
                          stroke-linejoin="round" />
                      </svg>
                    </a>
                    <a class="cart"   
                      data-prod-id="${item.prod_id}" 
                      data-spec-id="${item.spec_id}">
                      <svg xmlns="http://www.w3.org/2000/svg" width="39"height="40" viewBox="0 0 39 40" fill="none">
                        <path
                          d="M1.81378 2H4.9458C6.8898 2 8.41978 3.674 8.25778 5.6L6.76378 23.528C6.51178 26.462 8.83376 28.982 11.7858 28.982H30.9558C33.5478 28.982 35.8158 26.858 36.0138 24.284L36.9858 10.784C37.2018 7.796 34.9338 5.366 31.9278 5.366H8.6898"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path
                          d="M27.4637 38C28.7065 38 29.7137 36.9927 29.7137 35.75C29.7137 34.5073 28.7065 33.5 27.4637 33.5C26.221 33.5 25.2137 34.5073 25.2137 35.75C25.2137 36.9927 26.221 38 27.4637 38Z"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path
                          d="M13.0638 38C14.3064 38 15.3138 36.9927 15.3138 35.75C15.3138 34.5073 14.3064 33.5 13.0638 33.5C11.8211 33.5 10.8138 34.5073 10.8138 35.75C10.8138 36.9927 11.8211 38 13.0638 38Z"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path d="M14.4138 12.7999H36.0138" stroke="black"
                          stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                      </svg>
                    </a>
                  </div>
                </div>
            </div>
          </a>
        </div>
      `;
    }
    $(".card-item-wrap").html(itemsHtml);
  },
});

// 開學季學生主打
$.ajax({
  type: "get",
  url: "/fontPage/getStudentIndexProd",
  success: function (res) {
    var itemData = res;
    var itemsHtml = "";
    for (var i = 0; i < itemData.length; i++) {
      var item = itemData[i];
      itemsHtml += `
          <div class="card-item col-4">
            <a style="color: black;
            text-decoration: none;" class="card"  href="/commodity/${
              item.prod_id
            }/${item.spec_id}">
              <h5 id="${item.prod_id}">${item.prod_name}</h5>
              <div class="frame">
                  <div class="text">
                    <div class="frame1">
                      <div class="favorite" 
                        data-prod-id="${item.prod_id}"
                        data-spec-id="${item.spec_id}">
                        <svg class="heart-icon" xmlns="http://www.w3.org/2000/svg" width="38" height="34" viewBox="0 0 38 34" fill="none">
                          <path
                            d="M19.8989 31.8483C19.3258 32.0506 18.382 32.0506 17.809 31.8483C12.9213 30.1798 2 23.2191 2 11.4213C2 6.21348 6.19662 2 11.3708 2C14.4382 2 17.1517 3.48314 18.8539 5.77528C20.5562 3.48314 23.2865 2 26.3371 2C31.5112 2 35.7078 6.21348 35.7078 11.4213C35.7078 23.2191 24.7865 30.1798 19.8989 31.8483Z"
                            stroke="black" stroke-width="3" stroke-linecap="round"
                            stroke-linejoin="round" />
                        </svg>
                      </div>
                      <div class="cart"
                        data-prod-id="${item.prod_id}"
                        data-spec-id="${item.spec_id}">
                        <svg xmlns="http://www.w3.org/2000/svg" width="39" height="40" viewBox="0 0 39 40" fill="none">
                        <path
                          d="M1.70782 2H4.83984C6.78384 2 8.31382 3.674 8.15182 5.6L6.65782 23.528C6.40582 26.462 8.72781 28.982 11.6798 28.982H30.8498C33.4418 28.982 35.7098 26.858 35.9078 24.284L36.8798 10.784C37.0958 7.796 34.8278 5.366 31.8218 5.366H8.58384"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path
                          d="M27.3578 38C28.6005 38 29.6078 36.9927 29.6078 35.75C29.6078 34.5073 28.6005 33.5 27.3578 33.5C26.1151 33.5 25.1078 34.5073 25.1078 35.75C25.1078 36.9927 26.1151 38 27.3578 38Z"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path
                          d="M12.9578 38C14.2005 38 15.2078 36.9927 15.2078 35.75C15.2078 34.5073 14.2005 33.5 12.9578 33.5C11.7152 33.5 10.7078 34.5073 10.7078 35.75C10.7078 36.9927 11.7152 38 12.9578 38Z"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path d="M14.3079 12.7999H35.9079" stroke="black"
                          stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                      </svg>
                    </div>
                  </div>
                <p>NT ${item.price.toLocaleString()}</p>
              </div>
              <div class="item2-img">
                <img src="./public${item.img_src}" alt="">
              </div>
            </div>
          </a>
        </div>
      `;
      $(".card-item-wrap2").html(itemsHtml);
    }
  },
});

// 電競機
$.ajax({
  type: "get",
  url: "/fontPage/getGamingIndexProd",
  success: function (res) {
    var itemData = res;
    var itemsHtml = "";
    for (var i = 0; i < itemData.length; i++) {
      var item = itemData[i];
      itemsHtml += `
          <div class="card-item col-4">
            <a style="color: black;
            text-decoration: none;" class="card"  href="/commodity/${
              item.prod_id
            }/${item.spec_id}">
              <h5 id="${item.prod_id}">${item.prod_name}</h5>
              <div class="frame">
                  <div class="text">
                    <div class="frame1">
                      <div class="favorite" 
                        data-prod-id="${item.prod_id}"
                        data-spec-id="${item.spec_id}">
                        <svg class="heart-icon" xmlns="http://www.w3.org/2000/svg" width="38" height="34" viewBox="0 0 38 34" fill="none">
                          <path
                            d="M19.8989 31.8483C19.3258 32.0506 18.382 32.0506 17.809 31.8483C12.9213 30.1798 2 23.2191 2 11.4213C2 6.21348 6.19662 2 11.3708 2C14.4382 2 17.1517 3.48314 18.8539 5.77528C20.5562 3.48314 23.2865 2 26.3371 2C31.5112 2 35.7078 6.21348 35.7078 11.4213C35.7078 23.2191 24.7865 30.1798 19.8989 31.8483Z"
                            stroke="black" stroke-width="3" stroke-linecap="round"
                            stroke-linejoin="round" />
                        </svg>
                      </div>
                      <div class="cart"
                        data-prod-id="${item.prod_id}"
                        data-spec-id="${item.spec_id}">
                        <svg xmlns="http://www.w3.org/2000/svg" width="39" height="40" viewBox="0 0 39 40" fill="none">
                        <path
                          d="M1.70782 2H4.83984C6.78384 2 8.31382 3.674 8.15182 5.6L6.65782 23.528C6.40582 26.462 8.72781 28.982 11.6798 28.982H30.8498C33.4418 28.982 35.7098 26.858 35.9078 24.284L36.8798 10.784C37.0958 7.796 34.8278 5.366 31.8218 5.366H8.58384"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path
                          d="M27.3578 38C28.6005 38 29.6078 36.9927 29.6078 35.75C29.6078 34.5073 28.6005 33.5 27.3578 33.5C26.1151 33.5 25.1078 34.5073 25.1078 35.75C25.1078 36.9927 26.1151 38 27.3578 38Z"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path
                          d="M12.9578 38C14.2005 38 15.2078 36.9927 15.2078 35.75C15.2078 34.5073 14.2005 33.5 12.9578 33.5C11.7152 33.5 10.7078 34.5073 10.7078 35.75C10.7078 36.9927 11.7152 38 12.9578 38Z"
                          stroke="black" stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                        <path d="M14.3079 12.7999H35.9079" stroke="black"
                          stroke-width="3" stroke-miterlimit="10"
                          stroke-linecap="round" stroke-linejoin="round" />
                      </svg>
                    </div>
                  </div>
                <p>NT ${item.price.toLocaleString()}</p>
              </div>
              <div class="item2-img">
                <img src="./public${item.img_src}" alt="">
              </div>
            </div>
          </a>
        </div>
      `;
    }
    $(".card-item-wrap3").html(itemsHtml);
  },
});

// 渲染加入最愛的商品
$(document).ready(function () {
  $.ajax({
    type: "get",
    url: "/fontPage/getFavoriteProd",
    success: function (res) {
      for (var i = 0; i < res.length; i++) {
        var favoriteProdId = res[i].prod_id;
        var favoriteSpecId = res[i].spec_id;
        var $matchingItem = $(
          ".favorite[data-prod-id=" +
            favoriteProdId +
            "][data-spec-id=" +
            favoriteSpecId +
            "]"
        );
        $matchingItem.find(".heart-icon").css("fill", "red");
      }
    },
  });
});

// 渲染加入購物車的商品
$(document).ready(function () {
  $.ajax({
    type: "get",
    url: "/fontPage/getCartProd",
    success: function (res) {
      for (var i = 0; i < res.length; i++) {
        var favoriteProdId = res[i].prod_id;
        var favoriteSpecId = res[i].spec_id;
        var $matchingItem = $(
          ".cart[data-prod-id=" +
            favoriteProdId +
            "][data-spec-id=" +
            favoriteSpecId +
            "]"
        );
        $matchingItem.find("svg").css("fill", "gray");
      }
    },
  });
});

// 收藏
$(".card-item-wrap, .card-item-wrap2, .card-item-wrap3").on(
  "click",
  ".favorite",
  async function (e) {
    e.preventDefault();
    const icon = $(this).find("svg");

    try {
      const res = await $.ajax({
        type: "post",
        url: "/api/member/collectProd",
        data: {
          prod_id: $(this).data("prod-id"),
          spec_id: $(this).data("spec-id"),
        },
        dataType: "json",
      });
      console.log(res);
      if (res.err == 0) {
        if (res.data.type) {
          icon.css("fill", "red");
        } else {
          icon.css("fill", "none");
        }
      } else {
        alert("請先登入再收藏");
        location.href = "/login";
      }
    } catch (err) {
      throw err;
    }
  }
);
// 購物車
$(".card-item-wrap, .card-item-wrap2, .card-item-wrap3").on(
  "click",
  ".cart",
  async function (e) {
    e.preventDefault();
    const icon = $(this).find("svg");
    try {
      const res = await $.ajax({
        type: "post",
        url: "/api/member/cartProd",
        data: {
          prod_id: $(this).data("prod-id"),
          spec_id: $(this).data("spec-id"),
        },
        dataType: "json",
      });

      if (res.err == 0) {
        if (res.data.type) {
          icon.css("fill", "gray");
        } else {
          icon.css("fill", "none");
        }
      } else {
        alert("請先登入再加入購物車");
        location.href = "/login";
      }
    } catch (err) {
      throw err;
    }
  }
);
$(document).ready(function () {
  //top-screen-button
  function blkTopScrBtn(elem) {
    if (
      document.body.scrollTop > 20 ||
      document.documentElement.scrollTop > 20 ||
      elem > 20
    ) {
      $("#topScreenBtn").css("display", "block");
    } else {
      $("#topScreenBtn").css("display", "none");
    }
  }
  function screenTop() {
    let [productScreen, elem] = document.getElementsByClassName("info");
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
    productScreen.scrollTop = 0;
  }
  $(".info").on("scroll", function (e) {
    blkTopScrBtn(this.scrollTop);
  });
  $(window).on("scroll", function () {
    blkTopScrBtn();
  });
  $("#topScreenBtn").click(function () {
    screenTop();
  });
});
