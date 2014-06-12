(function() {
    var App = function () {

        function handleBootstrap() {
            jQuery('.carousel').carousel({
                interval: 15000,
                pause: 'hover'
            });
            jQuery('.tooltips').tooltip();
            jQuery('.popovers').popover();
        }

        function handleSearch() {
            jQuery('.search').click(function () {
                if(jQuery('.search-btn').hasClass('icon-search')){
                    jQuery('.search-open').fadeIn(500);
                    jQuery('.search-btn').removeClass('icon-search');
                    jQuery('.search-btn').addClass('icon-remove');
                } else {
                    jQuery('.search-open').fadeOut(500);
                    jQuery('.search-btn').addClass('icon-search');
                    jQuery('.search-btn').removeClass('icon-remove');
                }
            });
        }

        function handleSwitcher() {
            var panel = jQuery('.style-switcher');

            jQuery('.style-switcher-btn').click(function () {
                jQuery('.style-switcher').show();
            });

            jQuery('.theme-close').click(function () {
                jQuery('.style-switcher').hide();
            });

            jQuery('li', panel).click(function () {
                var color = jQuery(this).attr("data-style");
                var data_header = jQuery(this).attr("data-header");
                setColor(color, data_header);
                jQuery('.list-unstyled li', panel).removeClass("theme-active");
                jQuery(this).addClass("theme-active");
            });

            var setColor = function (color, data_header) {
                jQuery('#style_color').attr("href", "assets/css/themes/" + color + ".css");
                if(data_header == 'light'){
                    jQuery('#style_color-header-1').attr("href", "assets/css/themes/headers/header1-" + color + ".css");
                    jQuery('#logo-header').attr("src", "assets/img/logo1-" + color + ".png");
                    jQuery('#logo-footer').attr("src", "assets/img/logo2-" + color + ".png");
                } else if(data_header == 'dark'){
                    jQuery('#style_color-header-2').attr("href", "assets/css/themes/headers/header2-" + color + ".css");
                    jQuery('#logo-header').attr("src", "assets/img/logo1-" + color + ".png");
                    jQuery('#logo-footer').attr("src", "assets/img/logo2-" + color + ".png");
                }
            }
        }

        function handleBoxed() {
            jQuery('.boxed-layout-btn').click(function(){
                jQuery(this).addClass("active-switcher-btn");
                jQuery(".wide-layout-btn").removeClass("active-switcher-btn");
                jQuery("body").addClass("boxed-layout container");
            });
            jQuery('.wide-layout-btn').click(function(){
                jQuery(this).addClass("active-switcher-btn");
                jQuery(".boxed-layout-btn").removeClass("active-switcher-btn");
                jQuery("body").removeClass("boxed-layout container");
            });
        }

        return {
            init: function () {
                handleBootstrap();
                handleSearch();
                handleSwitcher();
                handleBoxed();
            },

            initSliders: function () {
                $('#clients-flexslider').flexslider({
                    animation: "slide",
                    easing: "swing",
                    animationLoop: true,
                    itemWidth: 1,
                    itemMargin: 1,
                    minItems: 2,
                    maxItems: 9,
                    controlNav: false,
                    directionNav: false,
                    move: 2
                });

                $('#clients-flexslider1').flexslider({
                    animation: "slide",
                    easing: "swing",
                    animationLoop: true,
                    itemWidth: 1,
                    itemMargin: 1,
                    minItems: 2,
                    maxItems: 5,
                    controlNav: false,
                    directionNav: false,
                    move: 2
                });

                $('#photo-flexslider').flexslider({
                    animation: "slide",
                    controlNav: false,
                    animationLoop: false,
                    itemWidth: 80,
                    itemMargin: 0
                });

                $('#testimonal_carousel').collapse({
                    toggle: false
                });
            },

            initFancybox: function () {
                jQuery(".fancybox-button").fancybox({
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
    Index.initRevolutionSlider();
    App.initFancybox();
    App.initBxSlider();

    initAsideMenu();
    bindSelectBox();
    initChangeFee();
    scrolltotop.init();
    var calendar = iniCalendarModel();

    $('.show-calendar').on('click', function(e) {
        var dataParameter = $(this).data('month');
        var CurrentDate = new Date();
        var CurrentYear = CurrentDate.getFullYear();

        e.preventDefault();

        calendar.fullCalendar('gotoDate', CurrentYear, dataParameter - 1);

        $('#calendar-modal').modal('show');
    });

    $('.refresh-price-source').on('change', function(){
        var priceTarget = $('.refresh-price-target');
        priceTarget.text(((parseInt(priceTarget.data('price'), 10) * parseInt($(this).val(), 10)) + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
    });

    $('#flexHome').flexslider({
        animation: "slide",
        controlNav:false,
        directionNav:false,
        touch: true,
        direction: "vertical"
    });

    $('#flexHome2').flexslider({
        animation: "slide",
        controlNav:false,
        directionNav:false,
        touch: true,
        direction: "vertical"
    });

    $('.youtube-link').each(function(){
        convertPreview($(this).data('link'), this);
    });

    $('.wizard').wizard();
    $('.nested-field').each(function(index){
        $(this).nestedFields({
            afterInsert: function(item) {
                if (jQuery().bootstrapFileInput) {
                    $(item).find('input[type=file]').bootstrapFileInput();
                }
            }
        });
    });

    $('[data-toggle="tooltip"]').tooltip('hide').hover(function(e){
        if ($(this).data('shown') == true) {
            $(this).tooltip('destroy');
        } else {
            $(this).data('shown', true);
        }
    });

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
            title: 'QuoiQuoi不知道工作室'
        });
    }
})();
