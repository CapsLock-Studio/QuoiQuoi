(function() {
    initAsideMenu();

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
        });

    App.init();
    Index.initRevolutionSlider();
    App.initFancybox();
    App.initBxSlider();

    bindSelectBox();
    initChangeFee();

    $('.show-calendar').on('click', function(e) {
        var dataSource = $(this).data('url');
        var dataParameter = $(this).data('month');

        e.preventDefault();
        bootbox.dialog({
            message: "<div class='row' style='margin-top:20px;'><div class='box'><div class='box-content'><div class='full-calendar-demo'></div></div></div></div>",
        }).on('shown.bs.modal', function(innerEvent){
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

                var cal = calendar.fullCalendar({
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
                    events: dataSource
                });

                cal.fullCalendar('gotoDate', CurrentYear, dataParameter - 1);
                console.log(dataSource);
            });
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