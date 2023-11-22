$(document).ready(function () {
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

  // 切換深色模式
  $("#dark-mode-toggle").on("change", function () {
    if (this.checked) {
      enableDarkMode();
    } else {
      disableDarkMode();
    }
  });

  // 啟用深色模式
  function enableDarkMode() {
    $("body").addClass("dark-mode");
  }

  // 禁用深色模式
  function disableDarkMode() {
    $("body").removeClass("dark-mode");
  }

  // 回到頂部
  $("#BackTop").click(function () {
    $("html,body").animate({ scrollTop: 0 }, 333);
  });
  $(window)
    .scroll(function () {
      if ($(this).scrollTop() > 300) {
        $("#BackTop").fadeIn(222);
      } else {
        $("#BackTop").stop().fadeOut(222);
      }
    })
    .scroll();

  // 按下+-符號時，數量會跟著變動
  var currentNumber = 1;
  $("#num").val(currentNumber);

  $("#plus").click(function () {
    currentNumber += 1;
    $("#num").val(currentNumber);
  });

  $("#minus").click(function () {
    if (currentNumber > 1) {
      currentNumber -= 1;
      $("#num").val(currentNumber);
    }
  });

  $(".no-link").click(function (e) {
    e.preventDefault();
  });

  var user_id = $("#userId").data("userId");
  $("#cart").off("click");
  $("#collect").off("click");
  $("#addtocart").off("click");
  $("#addtocollect").off("click");

  // 加入購物車
  $(document).on("click", "#cart", function () {
    if (user_id == "") {
      window.location.href = "/login";
    } else {
      var prod_id = $(this).data("prod_id");
      var spec_id = $(this).data("spec_id");

      $.ajax({
        url: "/commodity/addcart",
        type: "POST",
        data: {
          user_id: user_id,
          prod_id: prod_id,
          spec_id: spec_id,
        },
        success: function (response) {
          swal('已成功加入購物車',"請至購物車查看", "success");
          $('#cart svg').html('<svg xmlns="http://www.w3.org/2000/svg" width="20" height="" fill="currentColor" class="bi bi-cart-plus-fill" viewBox="0 0 16 16"><path d="M.5 1a.5.5 0 0 0 0 1h1.11l.401 1.607 1.498 7.985A.5.5 0 0 0 4 12h1a2 2 0 1 0 0 4 2 2 0 0 0 0-4h7a2 2 0 1 0 0 4 2 2 0 0 0 0-4h1a.5.5 0 0 0 .491-.408l1.5-8A.5.5 0 0 0 14.5 3H2.89l-.405-1.621A.5.5 0 0 0 2 1H.5zM6 14a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm7 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zM9 5.5V7h1.5a.5.5 0 0 1 0 1H9v1.5a.5.5 0 0 1-1 0V8H6.5a.5.5 0 0 1 0-1H8V5.5a.5.5 0 0 1 1 0z"/></svg>');
        },
        error: function (error) {
          console.error('加入購物車失敗', error)
          swal('加入購物車失敗',"該商品以在購物車中", "error");
        },
      });
    }
  });

  // 加入收藏
  $(document).on("click", "#collect", function () {
    if (user_id == "") {
      window.location.href = "/login";
    } else {
      var prod_id = $(this).data("prod_id");
      var spec_id = $(this).data("spec_id");
      var update_time = $(this).data("update_time");

      $.ajax({
        url: "/commodity/addcollect",
        type: "POST",
        data: {
          user_id: user_id,
          prod_id: prod_id,
          spec_id: spec_id,
          update_time: update_time,
        },
        success: function (response) {
          if (response.message === "商品已在收藏中") {
            // Product is already in collection, display alert message
            alert('該商品已在收藏清單中');
            console.log('該商品已在收藏清單中');
          } else if (response.message === "成功加入收藏") {
            // Product was added to collection, change button's icon to filled heart
            $("#collect svg").html('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/></svg>').css('color', 'red');
            console.log('已成功加入收藏');
          }
        },
        error: function (error) {
          console.error("加入收藏失敗", error);
        },
      });
    }
  });

  // 相關商品加入購物車
  $(document).on("click", ".addtocart", function () {
    if (user_id == "") {
      window.location.href = "/login";
    } else {
      var prod_id = $(this).data("prod_id");
      var spec_id = $(this).data("spec_id");

      $.ajax({
        url: "/commodity/addCart",
        type: "POST",
        data: {
          user_id: user_id,
          prod_id: prod_id,
          spec_id: spec_id,
        },
        success: function (response) {
          console.log("已成功加入購物車");
          swal('已成功加入購物車',"請至購物車查看", "success");
        },
        error: function (error) {
          console.error("加入購物車失敗", error);
          swal('加入購物車失敗',"該商品以在購物車中", "error");

        },
      });

      console.log("addtocart click event bound:", $("#addtocart").length > 0);
    }
  });

  // 相關商品加入收藏
  $(document).on("click", "#addtocollect", function () {
    if (user_id == "") {
      window.location.href = "/login";
    } else {
      var prod_id = $(this).data("prod_id");
      var spec_id = $(this).data("spec_id");
      var update_time = $(this).data("update_time");
      var clickedBtn = $(this)

      $.ajax({
        url: "/commodity/addCollect",
        type: "POST",
        data: {
          user_id: user_id,
          prod_id: prod_id,
          spec_id: spec_id,
          update_time: update_time,
        },
        success: function (response) {
          console.log("已成功加入收藏");
          clickedBtn.find('svg').html('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/></svg>').css('color', 'red');
        },
        error: function (error) {
          console.error("加入收藏失敗", error);
        },
      });

      console.log(
        "addtocollect click event bound:",
        $("#addtocollect").length > 0
      );
    }
  });

  // 直接購買
  $(document).on("click", "#direct-buy", function () {
    var prod_id = $(this).data("prod_id");
    var spec_id = $(this).data("spec_id");

    $.ajax({
      url: "/commodity/checkcart",
      type: "POST",
      data: {
        user_id: user_id,
        prod_id: prod_id,
        spec_id: spec_id,
      },

      success: function (response) {
        if (response.exists) {
          // 如果購物車裡有資料就跳轉至購買頁面
          window.location.href = "/shopcart";
        } else {
          addToCart(prod_id, spec_id);
        }
      },

      error: function (error) {
        console.error("檢查購物車失敗", error);
      },
    });
  });

  // 添加到購物車並跳轉至購買頁面
  function addToCart(prod_id, spec_id) {
    $.ajax({
      url: "/commodity/addcart",
      type: "POST",
      data: {
        user_id: user_id,
        prod_id: prod_id,
        spec_id: spec_id,
      },
      success: function (response) {
        console.log("成功加入購物車");
        window.location.href = "/shopcart";
      },
      error: function (error) {
        console.error("加入購物車失敗", error);
        console.log(error);
      },
    });
  }
});
