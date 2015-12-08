/**
 * Created by Apple on 2014/5/30.
 */
var initAutoSendForm = function() {
    $('.auto-send-form').each(function(){
        $(this).submit();
    });
};

var initRefreshTuition = function(){
    var registrationSection = $('.registration-course');

    registrationSection.find('.attendance').on('change', function(){
        registrationSection.find('.amount').text(
            registrationSection.find('.amount').text().getCurrency() + (parseFloat(registrationSection.find('.tuition').data('subtotal')) * $(this).val()).format()
        );
    });

    registrationSection.find('.option-price').on('change', function(){
        var optionSubtotal = 0;
        registrationSection.find('.option-price option:selected').each(function(){
            optionSubtotal += parseFloat($(this).data('price'));
        });

        var tuitionSection = registrationSection.find('.tuition');
        tuitionSection.data('subtotal', parseFloat(tuitionSection.data('raw')) + optionSubtotal);

        registrationSection.find('.amount').text(
            registrationSection.find('.amount').text().getCurrency() + (parseFloat(registrationSection.find('.tuition').data('subtotal')) * registrationSection.find('.attendance').val()).format()
        );
    });
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
            if (subtotal >= freeCondition) {
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

// TO-DO: need to add hover change image function, however, add hover but not work well, i don't know why.
var initChangeFocusImageShow = function() {
    $('[data-toggle="preview-change"]').on('click', function(e){
        e.preventDefault();
        $('[data-toggle="preview-change"]').removeClass('active');
        $(this).addClass('active');
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
    $('.product-option').on('change', function(e){
        var totalOptionPrice = 0;
        var parentElement = $(this).parent('div');

        parentElement.find('select.product-option').each(function(){
            totalOptionPrice += parseFloat($(this).find('option:selected').data('price'));
        });

        var productPriceBlock = parentElement.find('.product-price');

        var totalAmountBlock = $('.total-amount');
        var subtotal = parseFloat(productPriceBlock.data('raw-price')) + totalOptionPrice;
        var totalAmount = 0;

        productPriceBlock.data('price', subtotal);
        parentElement.find('.subtotal').text(parentElement.find('.subtotal').text().getCurrency() + subtotal.format()).data('subtotal', subtotal);

        $('.subtotal').each(function(e){
            totalAmount += parseFloat($(this).data('subtotal'));
        });
        totalAmountBlock.text(totalAmountBlock.text().getCurrency() + totalAmount.format());
    });
    $('.product-price').on('change', function(e){
        var productBlock = $(this).closest('.product');
        var totalAmountBlock = $('.total-amount');
        var subtotal = parseFloat($(this).data('price')) * $(this).val();
        productBlock.find('.subtotal').text(productBlock.find('.subtotal').text().getCurrency() + subtotal.format()).data('subtotal', subtotal);

        var totalAmount = 0;
        $('.subtotal').each(function(e){
            totalAmount += parseFloat($(this).data('subtotal'));
        });

        totalAmountBlock.text(totalAmountBlock.text().getCurrency() + totalAmount.format());
    });
};

var initLoadMore = function() {
    $('.load-more').on('click', function(e){
        // disable default action of archor
        e.preventDefault();

        var loadMoreButton = $(this);
        var template = $(loadMoreButton.data('template'));

        $.ajax({
            url: $(this).attr('href'),
            type: 'GET',
            dataType: 'json',
            success: function(data, textStatus, jqXHR){
                for (var i = 0; i < data.items.length; i++) {
                    var item = template.html();
                    for (var j = 0; j < data.items[i].length; j++) {
                        // fill the data into template
                        item = item.replace((new RegExp('{{' + data.items[i][j].key + '}}', 'g')), data.items[i][j].value);
                    }
                    $(item).insertBefore(template);
                }

                if (data.nextPage != null) {
                    loadMoreButton.attr('href', data.nextPage);
                } else {
                    loadMoreButton.hide();
                }
            },
            error: function(jqXHR, textStatus, errorThrown){

            }
        });
    });
};

var initReadMore = function() {
    $('.article-collapse').readmore({
        collapsedHeight: 260,
        moreLink: $('#read-more-button').html(),
        lessLink: $('#read-less-button').html()
    });
};

var initCollapseBoxInMobile = function() {
    if (!window.matchMedia || (window.matchMedia("(max-width: 767px)").matches)) {
       $('.collapse-in-mobile').addClass('box-collapsed');
    }
};

var initSigninModel = function() {
    var socialSignin = $('.social-signin');
    var userEmailForm = $('.user-email-form');
    $('#email-signin-btn').on('click', function(){
        socialSignin.hide();
        userEmailForm.show();
    });

    userEmailForm.find('button[type=submit]').on('click', function(){
        var emailInput = userEmailForm.find('input[name=email]');
        if (validateEmail(emailInput.val())) {
            emailInput.css('border-color', '');
            $.ajax({
                url: $(this).data('url'),
                type: 'post',
                dataType: 'json',
                data: {
                    email: emailInput.val(),
                    redirect_url: window.location.href
                },
                success: function(data, textStatus, jqXHR){
                    userEmailForm.hide();
                    $('.user-email-sent').show();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    window.alert('Send email error');
                }
            });
        } else {
            emailInput.css('border-color', 'red');
        }
    });

    $('#signin-modal').on('hidden.bs.modal', function(){
        socialSignin.show();
        userEmailForm.hide();
        $('.user-email-sent').hide();
    });
};

var initMaterialLikes = function() {
    $('body').on('click', '.material-like', function(e) {
        e.preventDefault();

        $(this).toggleClass('selected');

        var materials = decodeURIComponent(getCookie('material-likes'));
        if (materials == null || materials == '') {
            materials = []
        } else {
            materials = JSON.parse(materials);
        }

        if ($(this).hasClass('selected')) {
            materials.push($(this).data('id'));
            setCookie('material-likes', encodeURIComponent(JSON.stringify(materials)), 9999, '/');
        } else {
            if (materials.indexOf($(this).data('id')) > -1) {
                materials.splice(materials.indexOf($(this).data('id')), 1);
                setCookie('material-likes', encodeURIComponent(JSON.stringify(materials)), 9999, '/');

                $($(this).data('remove-target')).fadeOut(500);
            }
        }
    });
};

var initCustomOrderModel = function() {
    var customOrdeModal = $('.custom-order-modal');
    var step1 = customOrdeModal.find('.step1');
    var step2 = customOrdeModal.find('.step2');
    var chooseMaterials = customOrdeModal.find('.choose-materials');
    var step3 = customOrdeModal.find('.step3');
    customOrdeModal.find('.button-to-step1').on('click', function() {
        step1.show();
        chooseMaterials.hide();
        step2.hide();
    });

    customOrdeModal.find('#button-choose-materials').on('click', function(){
        var buttonChooseMaterials = $(this);
        if (buttonChooseMaterials.hasClass('not-loaded')) {
            $.ajax({
                url: buttonChooseMaterials.data('url'),
                dataType: 'json',
                type: 'get',
                success: function(data) {
                    var materialsTemplate = customOrdeModal.find('#selectable-materials-template');
                    var materialTemplate = customOrdeModal.find('#selectable-material-template');
                    for (var i = 0; i < data.length; i++) {
                        var materials = materialsTemplate.html();
                        materials = $(materials.replace('{{type}}', data[i].type));

                        for (var j = 0; j < data[i].materials.length; j++) {
                            var material = materialTemplate.html();
                            material = material.replace((new RegExp('{{id}}', 'g')), data[i].materials[j].id);
                            material = material.replace((new RegExp('{{image}}', 'g')), data[i].materials[j].image);
                            material = material.replace('{{original_image}}', data[i].materials[j].original_image);
                            material = material.replace('{{thumb_image}}', data[i].materials[j].thumb_image);
                            material = material.replace((new RegExp('{{selected}}', 'g')), data[i].materials[j].selected);
                            material = material.replace('{{truncated_name}}', data[i].materials[j].truncated_name);
                            material = material.replace('{{name}}', data[i].materials[j].name);
                            materials.find('.materials').append(material);
                        }

                        materials.insertBefore(materialsTemplate);
                    }
                    chooseMaterials.show();
                    step1.hide();
                    buttonChooseMaterials.removeClass('not-loaded');
                },
                error: function() {
                    window.alert('load materials error!');
                }
            });
        } else {
            chooseMaterials.show();
            step1.hide();
        }
    });

    customOrdeModal.find('.button-to-step2').on('click', function() {
        step1.hide();
        step2.show();
    });

    customOrdeModal.on('click', '.selectable', function(e){
        e.preventDefault();
        $(this).toggleClass('selected').toggleClass('text-muted');
        if ($(this).hasClass('selected')) {
            var template = customOrdeModal.find('#removable-material-template');
            $(template.html().replace('{{id}}', $(this).data('id')).replace('{{image}}', $(this).data('image'))).insertBefore(template);
        } else {
            step1.find('.removable[data-id=' + $(this).data('id') + ']').remove();
        }
    });

    customOrdeModal.on('click', '.removable', function(){
        var material = $(this);
        customOrdeModal.find('.selectable[data-id=' + material.data('id') + ']').removeClass('selected').html('');
        material.remove();
    });

    step2.find('button[type=submit]').on('click', function() {
        var emailInput = customOrdeModal.find('input[name=email]');
        if (validateEmail(emailInput.val())) {
            emailInput.css('border-color', '');
            var materials = [];
            customOrdeModal.find('.material.removable').each(function(i){
                materials[i] = $(this).data('id');
            });

            if (window.confirm(customOrdeModal.find('#confirm-message').text())) {
              $.ajax({
                url: $(this).data('url'),
                data: {
                  style: customOrdeModal.find('input[name=style]').val(),
                  order_type: customOrdeModal.find('input[name=order_type]:checked').val(),
                  materials: JSON.stringify(materials),
                  name: customOrdeModal.find('input[name=name]').val(),
                  phone: customOrdeModal.find('input[name=phone]').val(),
                  line: customOrdeModal.find('input[name=line]').val(),
                  references: customOrdeModal.find('input[name=references]').val(),
                  size: customOrdeModal.find('input[name=size]').val(),
                  description: customOrdeModal.find('input[name=description]').val(),
                  email: emailInput.val()
                },
                dataType: 'json',
                type: 'post',
                success: function(data) {
                  if (data.redirectNow) {
                    window.location.href = data.redirectUrl;
                  } else {
                    step2.hide();
                    step3.show();
                  }
                },
                error: function() {
                  window.alert('Authenticate wrong!');
                }
              });
            }

        } else {
            emailInput.css('border-color', 'red');
        }
    });

    customOrdeModal.on('hidden.bs.modal', function(){
        step2.hide();
        step3.hide();
        step1.show();
        chooseMaterials.hide();
    });
};

$.fn.marquee = function(animateTime, waitTime) {
    var marqueeBlock = $(this);
    var marqueeHeight = marqueeBlock.height();
    var marqueeLength = marqueeBlock.find('li').length;
    var eachMarginTop = marqueeBlock.height();
    var marquees = marqueeBlock.find('ul');
    var scrollUp = function(index, end){
        marquees.animate({
            marginTop: eachMarginTop * (0 - index)
        }, animateTime, function(){
            if (index == end) {
                index = 0;
                marquees.css({
                    marginTop: index
                });
            }
        });

        setTimeout(function(){
            scrollUp(index + 1, end);
        }, waitTime);
    };

    marqueeBlock.css({
        height: marqueeHeight
    }).addClass('active');

    marquees.append(marqueeBlock.find('li:first-child').clone());

    scrollUp(1, marqueeLength);
};

function setCookie(cname, cvalue, exdays, path) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toGMTString();
    document.cookie = cname + "=" + cvalue + "; " + expires + ((typeof path === 'undefined')? '' : ';path=' + path);
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

function validateEmail(email) {
  var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
  return re.test(email);
}

String.prototype.getCurrency = function() {
    return this.toString().replace(/(\w*\$[\s\r\n]*)[\w,.]*/g, '$1');
};

Number.prototype.format = function(){
    return this.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
};