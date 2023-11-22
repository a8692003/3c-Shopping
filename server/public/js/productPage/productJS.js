//myalert
let getAlertGroupShop = document.querySelector(".alertGroup");
class AlertGroup {
  constructor(changeClass, text) {
    this.changeClass = changeClass;
    this.text = text;
  }
  //alertGroup (("default","danger","info","success"),("meseege"))
  alertOfReload() {
    let setDiv = document.createElement("div");
    setDiv.classList.add(this.changeClass);
    setDiv.innerHTML = `<p
  class="closebtn"
  onclick="this.parentElement.parentElement.style.display='none';
  this.parentElement.remove();
  location.reload();"
>
  &times;
</p>
<p class="alert-text">${this.text}</p>`;
    getAlertGroupShop.appendChild(setDiv);
    getAlertGroupShop.style.display = "block";
  }
  alertOfNoReload() {
    let setDiv = document.createElement("div");
    setDiv.classList.add(this.changeClass);
    setDiv.innerHTML = `<p
    class="closebtn"
    onclick="this.parentElement.parentElement.style.display='none';
    this.parentElement.remove();"
  >
    &times;
  </p>
  <p class="alert-text">${this.text}</p>`;
    getAlertGroupShop.appendChild(setDiv);
    getAlertGroupShop.style.display = "block";
  }
  alertInTheIndex() {
    let setDiv = document.createElement("div");
    setDiv.classList.add(this.changeClass);
    setDiv.innerHTML = `<p
    class="closebtn"
    onclick="this.parentElement.parentElement.style.display='none';
    this.parentElement.remove();
    location.href='/index.html';"
  >
    &times;
  </p>
  <p class="alert-text">${this.text}</p>`;
    getAlertGroupShop.appendChild(setDiv);
    getAlertGroupShop.style.display = "block";
  }
  alertInTheProduct() {
    let setDiv = document.createElement("div");
    setDiv.classList.add(this.changeClass);
    setDiv.innerHTML = `<p
    class="closebtn"
    onclick="this.parentElement.parentElement.style.display='none';
    this.parentElement.remove();
    location.href='/product.html';"
  >
    &times;
  </p>
  <p class="alert-text">${this.text}</p>`;
    getAlertGroupShop.appendChild(setDiv);
    getAlertGroupShop.style.display = "block";
  }
  alertForCheckOut() {
    let setDiv = document.createElement("div");
    setDiv.classList.add(this.changeClass);
    setDiv.innerHTML = `<p
    class="closebtn"
    onclick="this.parentElement.parentElement.style.display='none';
    this.parentElement.remove();
    location.href='/product.html';"
  >
    &times;
  </p>
  <p class="alert-text">${this.text}</p>`;
    getAlertGroupShop.appendChild(setDiv);
    getAlertGroupShop.style.display = "block";
  }
}
$(document).ready(function () {
  //change header navber sun and moon
  $(".slider").on("click ", function () {
    if ($(this).hasClass("sun")) {
      $(".sun").css({
        display: "none",
      });
      $(".moon").css({
        display: "block",
      });
    } else {
      $(".sun").css({
        display: "block",
      });
      $(".moon").css({
        display: "none",
      });
    }
  });
  $(document).ready(function () {
    $("#mode").on("change", function (e) {
      $.get("/api/userSetting/darkMode");
    });
  });
  //top-screen-button
  function blkTopScrBtn(elem) {
    if (
      document.body.scrollTop > 20 ||
      document.documentElement.scrollTop > 20 ||
      elem > 20
    ) {
      $("#BackTop").css("display", "block");
    } else {
      $("#BackTop").css("display", "none");
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
  $("#BackTop").click(function () {
    screenTop();
  });
  // $("#BackTop").click(function () {
  //   $("html,body").animate({ scrollTop: 0 }, 100);
  // });
  // $(window)
  //   .scroll(function () {
  //     if ($(this).scrollTop() > 100) {
  //       $("#BackTop").fadeIn(222);
  //     } else {
  //       $("#BackTop").stop().fadeOut(222);
  //     }
  //   })
  //   .scroll();
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
  function getProdData(
    setData,
    isPriceDescClick,
    isAddTimeDescClick,
    removePage
  ) {
    $.ajax({
      type: "get",
      url: "/api/changeProduct",
      data: setData,
      success: async function (response) {
        await $(".productBox").remove();
        if (removePage) {
          await $(".contral-product-page").remove();
        }
        await $(".productSlecet").after(`${response}`);
        if (isAddTimeDescClick) {
          addTimeIsClick > 0 ? addTimeIsClick-- : addTimeIsClick++;
        }
        if (isPriceDescClick) {
          priceDescIsClick > 0 ? priceDescIsClick-- : priceDescIsClick++;
        }
      },
    });
  }
  //req addTime product & addTime product button change img
  let addTimeIsClick = 1;
  $("#addTime").click(function () {
    //addTime product button change img
    if ($(this).children("img").attr("alt") === "chevron-down") {
      $(this).children("img").attr({
        src: "/public/images/icons/chevron-up.svg",
        alt: "chevron-up",
      });
    } else {
      $(this).children("img").attr({
        src: "/public/images/icons/chevron-down.svg",
        alt: "chevron-down",
      });
    }
    //req addTime product
    $.ajax({
      type: "get",
      url: "/api/changeProduct",
      data: {
        getBrand: $(this).attr("data-brand"),
        getUpdateTime: addTimeIsClick,
      },
      success: async function (response) {
        await $(".productBox").remove();
        await $(".contral-product-page").remove();
        await $(".productSlecet").after(`${response}`);
        addTimeIsClick > 0 ? addTimeIsClick-- : addTimeIsClick++;
      },
    });
  });

  //req PriceDesc product & PriceDesc product button change img
  let priceDescIsClick = 1;
  $("#priceDesc").click(function () {
    //PriceDesc product button change img
    if ($(this).children("img").attr("alt") === "chevron-down") {
      $(this).children("img").attr({
        src: "/public/images/icons/chevron-up.svg",
        alt: "chevron-up",
      });
    } else {
      $(this).children("img").attr({
        src: "/public/images/icons/chevron-down.svg",
        alt: "chevron-down",
      });
    }
    //req PriceDesc product
    $.ajax({
      type: "get",
      url: "/api/changeProduct",
      data: {
        getBrand: $(this).attr("data-brand"),
        getPriceDesc: priceDescIsClick,
      },
      success: async function (response) {
        await $(".productBox").remove();
        await $(".contral-product-page").remove();
        await $(".productSlecet").after(`${response}`);
        priceDescIsClick > 0 ? priceDescIsClick-- : priceDescIsClick++;
      },
    });
  });
  //req PriceRange product
  $("input[pattern='[0-9]{7}']").on("keypress", function (e) {
    if (e.keyCode < 48 || e.keyCode > 57) {
      e.preventDefault();
    }
  });
  $("input[pattern='[0-9]{7}']").keyup(function () {
    $.ajax({
      type: "get",
      url: "/api/changeProduct",
      data: {
        getBrand: $(this).attr("data-brand"),
        getPriceRange: {
          form: $("input[name='priceFrom']").val()
            ? $("input[name='priceFrom']").val()
            : 0,
          to: $("input[name='priceTo']").val()
            ? $("input[name='priceTo']").val()
            : 0,
        },
      },
      success: async function (response) {
        await $(".productBox").remove();
        await $(".contral-product-page").remove();
        await $(".productSlecet").after(`${response}`);
      },
    });
  });
  //req productItemPage & ctrl product page css
  $("body").on("click", ".changePage", async function () {
    //ctrl product page css
    $(".contral-product-page>button").removeClass("active");
    $(this).addClass("active");
    //req productItemPage
    $.ajax({
      type: "get",
      url: "/api/changeProduct",
      data: {
        getBrand: $(this).attr("data-brand"),
        prodItemPage: $(this).text(),
      },
      success: async function (response) {
        await $(".productBox").remove();
        await $(".productSlecet").after(`${response}`);
      },
    });
  });
  //req productSelecet tag
  $("select[name='selectItem']").on("change", async function () {
    //req prodData
    await $.ajax({
      type: "get",
      url: "/api/changeProduct",
      data: {
        getBrand: $(this).attr("data-brand"),
        prodSelTag: $(this).val(),
      },
      success: async function (response) {
        await $(".productBox").remove();
        await $(".contral-product-page").remove();
        await $(".productSlecet").after(`${response}`);
      },
    });
  });
  //req product comparison
  if (JSON.parse(localStorage.getItem("product")) == null) {
    localStorage.setItem("product", JSON.stringify([]));
  }
  //display btn
  if (JSON.parse(localStorage.getItem("product")).length > 0) {
    $("#watchComparison").css("display", "block");
  } else {
    $("#watchComparison").css("display", "none");
  }
  $("body").on("click", ".prodComparison", async function () {
    await $.ajax({
      type: "get",
      url: "/api/changeProduct/prodComparison",
      data: {
        prod_id: $(this).data("prod_id"),
        spec_id: $(this).data("spec_id"),
      },
      success: function (response) {
        let arrTemp = [];
        let objTemp = {
          pId: response[0].prod_id,
          sId: response[0].spec_id,
          pName: response[0].prod_name,
          sName: response[0].spec_name,
          brand: response[0].brand,
          cpu: response[0].cpu,
          gpu: response[0].gpu,
          ram: response[0].ram,
          os: response[0].os,
          screen: response[0].screen,
          battery: response[0].battery,
          size: response[0].size,
          weight: response[0].weight,
          warranty: response[0].warranty ? response[0].warranty : "2年官網保固",
          imgSrc: response[0].dir + response[0].filename,
          price: response[0].price,
        };
        if (!localStorage.getItem("product")) {
          localStorage.setItem("product", JSON.stringify(objTemp));
        } else {
          if (Array.isArray(JSON.parse(localStorage.getItem("product")))) {
            arrTemp = JSON.parse(localStorage.getItem("product"));
            if (arrTemp.length == 3) {
              arrTemp.shift();
            }
          } else {
            arrTemp.push(JSON.parse(localStorage.getItem("product")));
          }
          arrTemp.push(objTemp);
          localStorage.setItem("product", JSON.stringify(arrTemp));
        }
        //display btn
        $("#watchComparison").css("display", "block");
        new AlertGroup("success", "成功加入到比較!").alertOfNoReload();
      },
      error: function (error) {
        new AlertGroup("danger", "無法加入!").alertOfNoReload();
      },
    });
  });

  //api/changeProductItem and this button prevent bubble events防止泡沫事件
  $("body").on("click", ".prodToPItem", function (e) {
    e.stopPropagation();
  });
  $("body").on("click", ".ctrlBtn", function (e) {
    e.preventDefault();
    e.stopPropagation();
  });
  let user_id = $("#userId").data("userId");
  //plusProduct
  $(".card-icon").on("click", ".cart", async function (e) {
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
          alert("添加成功");
        } else {
          icon.css("fill", "none");
          alert("取消添加");
        }
      } else {
        alert("請先登入再加入購物車");
        location.href = "/login";
      }
    } catch (err) {
      throw err;
    }
  });

  //collectProduct
  $(".card-icon").on("click", ".favorite", async function (e) {
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

      if (res.err == 0) {
        if (res.data.type) {
          icon.css("fill", "red");
          alert("添加成功");
        } else {
          icon.css("fill", "none");
          alert("取消添加");
        }
      } else {
        alert("請先登入再收藏");
        location.href = "/login";
      }
    } catch (err) {
      throw err;
    }
  });
  //jq ready bottom
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
