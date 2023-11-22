$(document).ready(function () {
  let data = JSON.parse(localStorage.getItem("product"));
  let temp = ``;

  for (let i = 0; i < data.length; i++) {
    let color = "";
    if (data[i].price <= data[1].price || data[i].price >= data[2].price) {
      color = "white";
    } else if (
      data[i].price <= data[1].price &&
      data[i].price <= data[2].price
    ) {
      color = "lightgreen";
    } else if (
      data[i].price >= data[1].price &&
      data[i].price >= data[2].price
    ) {
      color = "red";
    }
    temp += `
    <div class="col-3 text-center">  
    <div style="width: 200px; height: 200px;"><img style=" margin-left:5rem; object-fit: contain;width: 12rem; height: 12rem;" src='/public/${
      data[i].imgSrc
    }'></div>
    <a class="pname" href="/commodity/${data[i].pId}/${data[i].sId}">${
      data[i].pName
    }${data[i].sName}</a>
    <p>${data[i].brand}</p>
    <p
    style="background:${color};"
    >${data[i].price.toLocaleString()}</p>
    <p>${data[i].cpu}</p>
    <p>${data[i].gpu}</p>
    <p>${data[i].ram}</p>
    <p>${data[i].os}</p>
    <p>${data[i].screen}</p>
    <p>${data[i].battery}</p>
    <p>${data[i].size}</p>
    <p>${data[i].weight}</p>
    <p>${data[i].warranty}</p>
  </div>
    `;
  }
  $(".row").append(temp);
});
