$('.switch-ipt').on('click', function () {
    if (this.checked == true) {
        //背景
        $('body').addClass('dark-body')
        // header
        $('.header').addClass('dark-header')
        // 會員中心
        $('.individual-notification').addClass('dark-out-item')
        // icon 
        $('header svg').css('color', 'white')
        // 側邊目錄
        $('aside').addClass('dark-aside')
        $('aside li a').css('color', 'white')
        // 熱銷商品
        $('.card-item-wrap .card-item').css('backgroundColor', '#9C9D9E')
        $('.card-item-wrap .card-item p').css('color', 'white')
        // icon
        $(' main path').css('stroke', 'white')
        //開學季學生主打 / 電競機
        $('.card-item-wrap2 .card').css('backgroundColor', '#9C9D9E')
        $('.card-item-wrap2 p').css('color', 'white')
        $('.card-item-wrap2 h5').css('color', 'white')
        $('.card-item-wrap3 .card').css('backgroundColor', '#9C9D9E')
        $('.card-item-wrap3 p').css('color', 'white')
        $('.card-item-wrap3 h5').css('color', 'white')
        //標題
        $('h3').css('color', 'white')
        // footer
        $('footer').addClass('dark-footer')
    } else if (this.checked == false) {
        //背景
        $('body').removeClass('dark-body')
        // header
        $('.header').removeClass('dark-header')
        // 會員中心
        $('.individual-notification').removeClass('dark-out-item')
        // icon
        $('header svg').css('color', '#808180')
        // 側邊目錄
        $('aside').removeClass('dark-aside')
        $('aside li a').css('color', 'black')
        // 熱銷商品
        $('.card-item-wrap .card-item').css('backgroundColor', 'white')
        $('.card-item-wrap .card-item p').css('color', 'black')
        //開學季學生主打 / 電競機
        $('.card-item-wrap2 .card').css('backgroundColor', 'white')
        $('.card-item-wrap2 p').css('color', 'black')
        $('.card-item-wrap2 h5').css('color', 'black')
        $('.card-item-wrap3 .card').css('backgroundColor', 'white')
        $('.card-item-wrap3 p').css('color', 'black')
        $('.card-item-wrap3 h5').css('color', 'black')
        // icon
        $('main path').css('stroke', 'black')
        //標題
        $('h3').css('color', 'black')
        // footer
        $('footer').removeClass('dark-footer')
    }
})