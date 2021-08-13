(function() {
    var App = function () {
        function handleBootstrap() {
            $('.carousel').carousel({
                interval: 7000,
                pause: 'hover'
            });
            $('.tooltips').tooltip();
            $('.popovers').popover();

            $('.nav-dropdown-menu').on('show.bs.dropdown', function(e){
                // ADD SLIDEDOWN ANIMATION TO DROPDOWN //
                $(this).find('.dropdown-menu').first().stop(true, true).slideDown();
            }).on('hide.bs.dropdown', function(e){
                    // ADD SLIDEUP ANIMATION TO DROPDOWN //
                    $(this).find('.dropdown-menu').first().stop(true, true).slideUp();
                });

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
                    padding: 0,
                    prevEffect: 'none',
                    nextEffect: 'none',
                    closeBtn: true,
                    parent: 'body'
                });
            },

            initBxSlider: function () {
                if (shown == 'true' || !window.matchMedia || (window.matchMedia("(max-width: 767px)").matches)) {
                    $('.bxslider').bxSlider({
                        minSlides: 2,
                        maxSlides: 2,
                        slideWidth: 360,
                        slideMargin: 10
                    });
                } else {
                    $('.bxslider').bxSlider({
                        minSlides: 4,
                        maxSlides: 4,
                        slideWidth: 360,
                        slideMargin: 10
                    });
                }

                $('.bxslider1').bxSlider({
                    minSlides: 3,
                    maxSlides: 3,
                    slideWidth: 360,
                    slideMargin: 10,
                    infiniteLoop: false,
                });
//
//                $('.bxslider2').bxSlider({
//                    minSlides: 2,
//                    maxSlides: 2,
//                    slideWidth: 360,
//                    slideMargin: 10
//                });
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
    initRefreshTuition();
    initLoadMore();
    initReadMore();
    initCollapseBoxInMobile();
    scrolltotop.init();
    initAutoSendForm();
    initSigninModel();
    initMaterialLikes();
    initCustomOrderModel();

    $('body').on('keyup', '.validate-form .form-group.required input', function (e) {
        var input = $(e.target);
        var isInputNotEmpty = !!input.val();
        var formItem = input.closest('.form-group.required');

        if (!isInputNotEmpty) {
            formItem.addClass('has-error');
        } else {
            formItem.removeClass('has-error');
        }
    });

    $('body').on('submit', '.validate-form', function(e) {
        var form = $(e.target);
        var isValid = form.find('.form-group.required').get().reduce(function (accu, item) {
            var formItem = $(item);
            var input = formItem.find('input');
            if (input.length === 0) {
                return accu;
            }
            var isInputNotEmpty = !!input.val();
            if (!isInputNotEmpty) {
                formItem.addClass('has-error');
            } else {
                formItem.removeClass('has-error');
            }
            return accu && isInputNotEmpty;
        }, true);

        if (isValid) {
            return;
        }

        e.preventDefault();
    });

    $('body').on('submit', '.search-form', function (e) {
        fbq('track', 'Search');
    });

    $('body').on('submit', '.new_order_product', function (e) {
        fbq('track', 'AddToCart');
    });

    $('body').on('submit', 'form.checkout-form', function (e) {
        fbq('track', 'AddPaymentInfo');
    })

    $('body').on('submit', 'form.purchase-form', function (e) {
        fbq('track', 'Purchase');

        const dom = document.querySelector('#order-products')
        const products = JSON.parse(dom.innerHTML)
        const trackPayload = {
            value: dom.dataset.subtotal,
            currency: 'TWD',
            contents: [
                products.map(function (product) {
                    return product.id
                })
            ],
            content_ids: products
                .map(function (product) {
                    return product.id
                })
                .join(','),
        };
        console.log(trackPayload);
        fbq('track', 'Purchase', trackPayload)
    })

    $('body').on('submit', 'form#new_user', function (e) {
        fbq('track', 'CompleteRegistration');
    })

    $('body').on('click', '.social-btn', function (e) {
        fbq('track', 'CompleteRegistration');
    });

    $('img').on('load', function(){
        $(this).animate({opacity: 1}, 500);
    }).each(function(){
            if (!this.complete) {
                $(this).css({opacity: 0});
            }
        });

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
        $('#send-email-modal').modal('show');
    });

    $('#show-gift-card-field').on('click', function(e) {
        e.preventDefault();
        $('#gift-card-field').show();
        $(this).hide();
    });

    $('.refresh-price-source').on('change', function(){
        var priceTarget = $('.refresh-price-target');
        var subtotal = parseFloat(priceTarget.data('price')) * parseInt($(this).val(), 10);
        priceTarget.text(priceTarget.text().getCurrency() + subtotal.format());

    });

    $('.course-option-price').on('change', function(){{
        var priceTarget = $('.refresh-price-target');
        var tuition = $(this).find('option:selected').data('price');
        var subtotal = parseFloat(tuition) * parseInt($('.refresh-price-source').val(), 10);
        priceTarget.data('price', tuition).text(priceTarget.text().getCurrency() + subtotal.format());
    }});

    $('.youtube-video').on('click', function(){
        convertPlayer(this);
    });

    $('[data-dismiss="disable"]').on('click', function(){
        $($(this).data('target')).prop('disabled', $(this).prop('checked'));
    });

    $('[data-dismiss="remove"]').on('click', function(){
        $($(this).data('target')).remove();
    });

//    $('.collapse-trigger').on('click', function(){
//        $(this).closest('.collapse-box').toggleClass('collapsed');
//    });

    var marquee = $('#marquee');
    if (marquee.length > 0) {
        // start at 5 seconds after
        setTimeout(function(){
            marquee.marquee(500, 5000);
        }, 5000);
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
            lat: 25.1351676,
            lng: 121.4610843,
            zoom: 17,
            options: {
                draggable: true,
                disableDoubleClickZoom: false,
                scrollwheel: false
            }
        });
        marker = map.addMarker({
            lat: 25.1351676,
            lng: 121.4610843,
            title: '布知道(quoi quoi)工作室'
        });
    }

    outdatedBrowser({
        bgColor: '#FFF'
    });
    $('#btnClose').on('click', function(){
        $('#outdated').remove();
    });
})();