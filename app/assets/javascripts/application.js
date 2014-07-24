(function() {
    var App = function () {
        function handleBootstrap() {
            $('.carousel').carousel({
                interval: 7000,
                pause: 'hover'
            });
            $('.tooltips').tooltip();
            $('.popovers').popover();
        }

        function handleSearch() {
            $('.search').click(function () {
                var searchOpen = $('.search-open');
                var searchBtn = $('.search-btn');
                if(searchBtn.hasClass('fa-search')){
                    searchOpen.fadeIn(500);
                    searchBtn.removeClass('fa-search').addClass('fa-times');
                } else {
                    searchOpen.fadeOut(500);
                    searchBtn.addClass('fa-search').removeClass('fa-times');
                }
            });
        }

        return {
            init: function () {
                handleBootstrap();
                handleSearch();
            },

            initFancybox: function () {
                $(".fancybox-button").fancybox({
                    groupAttr: 'data-rel',
                    prevEffect: 'none',
                    nextEffect: 'none',
                    closeBtn: true,
                    helpers: {
                        title: {
                            type: 'inside'
                        }
                    }
                });
            },

            initBxSlider: function () {
                $('.bxslider').bxSlider({
                    minSlides: 4,
                    maxSlides: 4,
                    slideWidth: 360,
                    slideMargin: 10
                });

                $('.bxslider1').bxSlider({
                    minSlides: 3,
                    maxSlides: 3,
                    slideWidth: 360,
                    slideMargin: 10
                });

                $('.bxslider2').bxSlider({
                    minSlides: 2,
                    maxSlides: 2,
                    slideWidth: 360,
                    slideMargin: 10
                });
            }

        };

    }();

    $('body').on('change', '.file-input-wrapper input[type=file]', function(){
            if (this.files && this.files[0]) {
                var image =  $(this).parent().prev('img');
                if (image.length <= 0) {
                    image = $(this).parent().prev('.crop').find('img');
                }

                var fileReader = new FileReader();
                fileReader.onload = function(e) {
                    if (image.parent('.crop').length <= 0) {
                        image.wrap('<div class="crop"></div>' );
                        image.parent('.crop').css({
                            width: image.width() + 'px',
                            height: image.height() + 'px',
                            'background-size': 'cover',
                            'background-position': 'center',
                            'background-repeat': 'no-repeat'
                        });
                    }
                    image.css({
                        display: 'none'
                    }).parent('.crop').css({
                            'background-image': 'url(' + e.target.result + ')'
                        });
                };
                fileReader.readAsDataURL(this.files[0]);
            }
        });

    App.init();
    App.initFancybox();
    App.initBxSlider();

    initAsideMenu();
    bindSelectBox();
    initChangeFee();
    initOffcanvas();
    initChangeFocusImageShow();
    initToggleSearchGiftForm();
    initCartCalculate();
    scrolltotop.init();

    var calendar = iniCalendarModel();

    $('.carousel-link').on('click', function(e) {
        if ($(this).data('target') != '') {
            window.open($(this).data('target'), '_blank');
        }
    });

    $('.show-calendar').on('click', function(e) {
        var dataParameter = $(this).data('month');
        var CurrentDate = new Date();
        var CurrentYear = CurrentDate.getFullYear();

        e.preventDefault();

        calendar.fullCalendar('gotoDate', CurrentYear, dataParameter - 1);

        $('#calendar-modal').modal('show');
    });

    $('.send-serial-btn').on('click', function(){
        $('[name=user_gift_serial_id]').val($(this).data('id'));
    });

    $('.refresh-price-source').on('change', function(){
        var priceTarget = $('.refresh-price-target');
        priceTarget.text(((parseInt(priceTarget.data('price'), 10) * parseInt($(this).val(), 10)) + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
    });

    $('.youtube-video').on('click', function(){
        convertPlayer(this);
    });

    var marquee = $('#marquee');
    if (marquee.length > 0) {
        setTimeout(function(){
            marquee.marquee(500, 5000);
        }, 1000);
    }
    $('.wizard').wizard();
    $('.nested-field').each(function(index){
        $(this).nestedFields({
            afterInsert: function(item) {
                if ($().bootstrapFileInput) {
                    $(item).find('input[type=file]').bootstrapFileInput();
                }
            }
        });
    });

    var shown = getCookie('tooltip-switch');
    if (shown == 'true' || !window.matchMedia || (window.matchMedia("(max-width: 991px)").matches)) {
        $('[data-toggle=tooltip]').tooltip('destroy');
    } else {
        $('[data-toggle=tooltip]').tooltip('show').hover(function(){
            setCookie('tooltip-switch', true, 3);
            $(this).tooltip('destroy');
        });
    }

    if ($('#map').length > 0) {
        map = new GMaps({
            div: '#map',
            lat: 25.1359486,
            lng: 121.4612855,
            zoom: 17,
            options: {
                draggable: true,
                disableDoubleClickZoom: false,
                scrollwheel: false
            }
        });
        marker = map.addMarker({
            lat: 25.1359486,
            lng: 121.4612855,
            title: '布知道(quoi quoi)工作室'
        });
    }
})();