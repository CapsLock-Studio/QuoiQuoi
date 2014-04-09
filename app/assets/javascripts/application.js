//= require unify/plugins/gmap/gmap.js
App.init();
App.initSliders();
//Index.initParallaxSlider();
Index.initRevolutionSlider();
App.initFancybox();
App.initBxSlider();

var refreshPrice = function(){
    var productPriceBlock = $('#product-price');
    var productPrice = parseInt(productPriceBlock.data('price'), 10);

    $('option:selected').each(function(index){
        productPrice += parseInt($(this).data('price'), 10);
    });

    productPriceBlock.text('$' + (productPrice + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
};

var convertPreview = function(link, youtubeBlock) {
    if (link.match(/[https|http]+:\/\/www.youtube.com\//)) {
//        var youtubeBlock = $(element).parent('div').find('.youtube-block');
        $(youtubeBlock).html('<iframe style="width:100%;height:' + $(youtubeBlock).height() + 'px;" src="' + link.replace(/[https|http]+:\/\/www\.youtube\.com\/watch\?v=([\w\d]+)/, '//www.youtube.com/embed/$1') + '" frameborder="0" allowfullscreen></iframe>');
    }
}

if ($('#map').length > 0) {
    map = new GMaps({
        div: '#map',
        lat: 25.173848,
        lng: 121.447575,
        options: {
            draggable: false,
            disableDoubleClickZoom: true,
            scrollwheel: false
        }
    });
    marker = map.addMarker({
        lat: 25.173848,
        lng: 121.447575,
        title: '淡江大學'
    });
}

$('[data-toggle="tooltip"]').tooltip('hide').hover(function(e){
    if ($(this).data('shown') == true) {
        $(this).tooltip('destroy');
    } else {
        $(this).data('shown', true);
    }
});

// Aside Menu
$(".aside-menu-switch, #btnHideAsideMenu, .navbar-toggle-aside-menu").click(function(){
    var asideMenu = $("#asideMenu");
    if($('.aside-menu-in').length <= 0){
        $("body").addClass("aside-menu-in");
    } else {
        $("body").removeClass("aside-menu-in");
    }
    return false;
});

(function() {
    $('.show-calendar').on('click', function(e){
        var dataSource = $(this).data('url');
        var dataParameter = $(this).data('month');

        e.preventDefault();
        bootbox.dialog({
            message: "<div class='row' style='margin-top:20px;'><div class='box'><div class='box-content'><div class='full-calendar-demo'></div></div></div></div>",
        }).on('shown.bs.modal', function(e){
                var CurrentDate = new Date();
                var CurrentYear = CurrentDate.getFullYear();

                setDraggableEvents = function() {
                    return $("#events .external-event").each(function() {
                        var eventObject;
                        eventObject = {
                            title: $.trim($(this).text())
                        };
                        $(this).data("eventObject", eventObject);
                        return $(this).draggable({
                            zIndex: 999,
                            revert: true,
                            revertDuration: 0
                        });
                    });
                };

                setDraggableEvents();

                var calendar = $(".full-calendar-demo");

                cal = calendar.fullCalendar({
                    header: {
                        center: "title",
                        left: "basicDay,basicWeek,month",
                        right: "prev,today,next"
                    },
                    buttonText: {
                        prev: "<span class=\"icon-chevron-left\"></span>",
                        next: "<span class=\"icon-chevron-right\"></span>",
                        today: "今天",
                        basicDay: "日",
                        basicWeek: "週",
                        month: "月"
                    },
                    droppable: false,
                    editable: true,
                    selectable: true,
                    select: function(start, end, allDay) {
                        return bootbox.prompt("Event title", function(title) {
                            if (title !== null) {
                                cal.fullCalendar("renderEvent", {
                                    title: title,
                                    start: start,
                                    end: end,
                                    allDay: allDay
                                }, true);
                                return cal.fullCalendar('unselect');
                            }
                        });
                    },
                    eventClick: function(calEvent, jsEvent, view) {

                    },
                    drop: function(date, allDay) {

                    },
                    events: dataSource
                });

                calendar.fullCalendar('gotoDate', CurrentYear, dataParameter - 1);
            });
    });

    refreshPrice();
})();

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

//$('body').on('DOMNodeInserted', '.bootstrap-select', function(e){
//    if ($(e.target).attr('class') === 'options') {
//        $('.options').on('hover', function(){
//            console.log($(this).data('image'));
//        });
//    }
//});
$('.select-parent').on('click', '.bootstrap-select', function(){
    var mainImageBlock = $('.main-image');
    $(this).find('.options').parent('a').hover(function(){
        mainImageBlock.css({
           background: 'url(' + $(this).find('.options').data('image') + ')'
        });
        mainImageBlock.find('img').stop().animate({
            opacity: 0
        }, 300);
    }, function(){
        mainImageBlock.find('img').stop().animate({
            opacity: 1
        }, 300)
    });
});

$('.selectpicker').on('change', function(e){
    refreshPrice();
});

$('.youtube-link').each(function(){
    convertPreview($(this).data('link'), this);
});

$('.wizard').wizard();