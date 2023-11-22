$(document).ready(function () {
  $("#mode").on("change", function (e) {
    $.get("/api/userSetting/darkMode");
  });
  $("#logout").on("click", function (e) {
    e.preventDefault();
    $.ajax({
      type: "get",
      url: "/api/logout",

      success: function (response) {
        if (response) {
          location.reload();
        }
      },
    });
  });
});
