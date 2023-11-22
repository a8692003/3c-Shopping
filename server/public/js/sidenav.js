function toggleNav() {
  var sidenav = document.getElementById("mySidenav");
  if (sidenav.style.width === "100%") {
      // 如果侧边栏已经完全打开，则关闭它
      sidenav.style.width = "0";
  } else {
      // 否则，打开侧边栏
      sidenav.style.width = "100%";
  }
}
