$(document).ready(function () {
  $("form.lock").find(":input:not(:button)").prop("disabled", true);

  $("#formEdit").on("click", "input", function () {
    $(this).parent().hide();
    var form = $(this).closest("form");
    form.find("#formSave").show();
    form.find("input").prop("disabled", false);
    form.find("select").prop("disabled", false);
  });
  $("*").on("keypress", "input.num", function (e) {
    if (e.keyCode < 48 || e.keyCode > 57) {
      e.preventDefault();
    }
  });
  $("[name=phone]").on("keypress", function (e) {
    if ($(this).val().length >= 10) {
      e.preventDefault();
      const regex = /^[09][0-9]*/;
    }
  });
  $("[name=year]").on("keypress", function (e) {
    if ($(this).val().length >= 4) {
      e.preventDefault();
    }
  });
  $("[name=month],[name=day]").on("keypress", function (e) {
    if ($(this).val().length >= 2) {
      e.preventDefault();
    }
  });
  $("*").on("keypress", "[name^=card]", function (e) {
    if ($(this).val().length >= 4) {
      e.preventDefault();
      $(this).next("[name^=card]").focus();
    }
  });
  $("*").on("keypress", "[name=security_code]", function (e) {
    if ($(this).val().length >= 3) {
      e.preventDefault();
    }
  });
  $("*").on("keypress", "[name=expiry_date]", function (e) {
    if ($(this).val().length >= 4) {
      e.preventDefault();
    }
  });

  $(".cards").on("click", ".cardEdit input", function (e) {
    var parent = $(this).closest("div.submit");
    $(this).hide();
    parent.closest("form").find("input").prop("disabled", false);
    parent.find(".cardSave").show();
  });

  $(".collapse").on("click", "div:first", function (e) {
    e.preventDefault();
    $(this).parent("div").toggleClass("active");
  });
});
