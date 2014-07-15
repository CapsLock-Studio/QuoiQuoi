/**
 * Created by Apple on 2014/5/30.
 */

var refreshPrice = function(){
    var productPriceBlock = $('#product-price');
    var productPrice = parseInt(productPriceBlock.data('price'), 10);

    $('option:selected').each(function(index){
        productPrice += parseInt($(this).data('price'), 10);
    });

    productPriceBlock.text('$' + (productPrice + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
};

var convertPlayer = function(youtubeBlock) {
    $(youtubeBlock).html('<iframe style="width:100%;height:' + $(youtubeBlock).height() + 'px;" src="//www.youtube.com/embed/' + $(youtubeBlock).data('youtube-id') + '?autoplay=1" frameborder="0" allowfullscreen></iframe>');
};

var bindSelectBox = function(){
    $('.select-box .box-header').on('click', function(e){
        e.preventDefault();

        var box = $(this).parent('.box');
        var selectBoxes = $(this).closest('.select-boxes');
        var selectedBox = selectBoxes.find('.' + selectBoxes.data('name') + '_' + $(this).data('id'));

        // if box has active, remove material input else add material input(check by class name)
        if (box.hasClass('active')) {
            selectedBox.remove();
            box.removeClass('active');
            box.find('.actions i').removeClass('fa-check-square-o').addClass('fa-square-o');
        } else if (selectedBox.length <= 0) {

            // append material input
            $($('<div></div>').html(selectBoxes.find('.template').html().replace(/new_nested_item/g, new Date().getTime())).text()).appendTo(selectBoxes.find('.items'))
                .addClass(selectBoxes.data('name') + '_' + $(this).data('id'))
                .val($(this).data('id'));
            box.addClass('active');
            box.find('.actions i').removeClass('fa-square-o').addClass('fa-check-square-o');
        }
    });

    $('.select-box-paginate a').on('click', function(e){
        e.preventDefault();
        var thisButton = $(this);
        var selectBoxes = thisButton.closest('.select-boxes');
        $.ajax({
            url: thisButton.attr('href').replace('new', 'material'),
            type: 'GET',
            dataType: 'html',
            success: function(data, textStatus, jqXHR) {
                var selectedMaterials = [];
                selectBoxes.find('.box-content').html(data);
                selectBoxes.find('input.' + selectBoxes.data('name')).each(function(index, materialInput){
                    selectedMaterials.push(parseInt(materialInput.value, 10));
                });
                console.log(selectedMaterials);
                selectBoxes.find('.box-header').each(function(index, boxHeader){
                    // console.log($(boxHeader).data('material_id'));
                    if (selectedMaterials.indexOf($(boxHeader).data('id')) > -1) {
                        $(this).parent('.box').addClass('active').find('.actions i').removeClass('fa-square-o').addClass('fa-check-square-o');
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

var initChangeFee = function() {
    $('.shipping-fee').on('change', function(){
        var freeCondition = $(this).find(':selected').data('free-condition');
        var fee = parseInt($(this).find(':selected').data('fee'), 10);
        var subtotalElement = $('.subtotal');
        var subtotalFeeElement = $('.shipping-fee-subtotal');
        var subtotal = parseInt(subtotalElement.data('price'), 10);

        // 先設定運費加總額
        subtotalFeeElement.text('$' + (fee + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
        subtotalElement.text('$' + (fee + subtotal + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
        if (freeCondition != null) {

            // 結帳金額大於免運費條件免運費
            if (subtotal > freeCondition) {
                subtotalFeeElement.text('$0.00');
                subtotalElement.text('$' + (subtotal + '').replace(/(\d{1,3})(?=(\d{3})+$)/g, '$1,') + '.00');
            }
        }
    });
};

// Aside Menu
var initAsideMenu = function() {
    $('.aside-menu-switch, .navbar-toggle-aside-menu').on('click', function(e){
        if ($(this).attr('href') == '#') {
            e.preventDefault();
        }
        $('.wrapper').toggleClass('col-md-pull-3 col-sm-pull-6 col-xs-pull-10 right-0');
        $('body').toggleClass('aside-menu-in');
        $('.aside-menu-switch').toggleClass('active');
    });
};

var iniCalendarModel = function(){

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

    var cal = calendar.fullCalendar({
        header: {
            center: "title",
            left: "basicDay,basicWeek,month",
            right: "prev,today,next"
        },
        buttonText: {
            prev: "<span class=\"fa fa-chevron-left\"></span>",
            next: "<span class=\"fa fa-chevron-right\"></span>",
            today: "今天",
            basicDay: "日",
            basicWeek: "週",
            month: "月"
        },
        droppable: false,
        editable: false,
        selectable: false,
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
        events: calendar.data('url')
    });

    $('#calendar-modal').on('shown.bs.modal', function(){
        calendar.fullCalendar('render');
    });

    return cal;
};

var initOffcanvas = function(){
    $('[data-toggle=offcanvas]').on('click', function(e){
        e.preventDefault();
        $('.row-offcanvas').toggleClass('active');
    });
};

var initChangeFocusImageShow = function() {
    $('[data-toggle="preview-change"]').on('click', function(e){
        e.preventDefault();
        $('.fancybox-button').attr('href', $(this).data('large')).find('img').attr('src', $(this).data('medium'));
    });
};

var initToggleSearchGiftForm = function() {
    $('[data-toggle="gift-form"]').on('click', function(e){
        e.preventDefault();
        $('.gift-search').toggleClass('active');
    });
};

var initCartCalculate = function() {
    $('.product-price').on('change', function(e){
        var productBlock = $(this).closest('.product');
        var subtotal = parseFloat($(this).data('price')) * $(this).val();
        productBlock.find('.subtotal').text('$' + subtotal.toFixed(2)).data('subtotal', subtotal);

        var totalAmount = 0;
        $('.subtotal').each(function(e){
            totalAmount += parseFloat($(this).data('subtotal'));
        });

        $('.total-amount').text(totalAmount.toFixed(2));
    });
};

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toGMTString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
    }
    return "";
}