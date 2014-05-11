//= require unify/plugins/gmap/gmap.js
App.init();
//App.initSliders();
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

$('.refresh-price-source').on('change', function(){
    var priceTarget = $('.refresh-price-target');
    priceTarget.text(((parseInt(priceTarget.data('price'), 10) * parseInt($(this).val(), 10)) + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
});

if ($('#map').length > 0) {
    map = new GMaps({
        div: '#map',
        lat: 25.1359486,
        lng: 121.4612855,
        zoom: 18,
        options: {
            draggable: false,
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

$('body').on('click', function(){
    if($('.aside-menu-in').length > 0){
        $(this).removeClass('aside-menu-in');
    }
}).on('change', '.file-input-wrapper input[type=file]', function(){
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
    });;

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

var bindSelectBox = function(){
    $('.select-box .box-header').on('click', function(e){

        var box = $(this).parent('.box');
        var selectedMaterial = $('.material_id_' + $(this).data('material_id'));

        // if box has active, remove material input else add material input(check by class name)
        if (box.hasClass('active')) {
            selectedMaterial.remove();
            box.removeClass('active');
        } else if (selectedMaterial.length <= 0) {

            // append material input
            $($('<div></div>').html($('.template').html().replace(/new_nested_item/g, new Date().getTime())).text()).appendTo('.items')
                .addClass('material_id_' + $(this).data('material_id'))
                .val($(this).data('material_id'));
            box.addClass('active');
        }
    });

    $('.select-box-paginate a').on('click', function(e){
        e.preventDefault();
        var thisButton = $(this);
        $.ajax({
            url: thisButton.attr('href').replace('new', 'material'),
            type: 'GET',
            dataType: 'html',
            success: function(data, textStatus, jqXHR) {
                var selectedMaterials = [];
                $('.select-boxes').html(data);
                $('input.material_id').each(function(index, materialInput){
                    selectedMaterials.push(parseInt(materialInput.value, 10));
                });

                console.log(selectedMaterials);

                $('.select-box .box-header').each(function(index, boxHeader){
                    console.log($(boxHeader).data('material_id'));
                    if (selectedMaterials.indexOf($(boxHeader).data('material_id')) > -1) {
                        $(this).parent('.box').addClass('active');
                    }
                });

                bindSelectBox();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                window.alert('無法讀取頁面 / Can\'t load page.');
            }
        });
    });
};

bindSelectBox();