(function(){
    $('.wysihtml5').wysihtml5();
    $('.wysihtml5-less').wysihtml5({
        "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
        "emphasis": true, //Italics, bold, etc. Default true
        "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
        "html": false, //Button which allows you to edit the generated HTML. Default false
        "link": true, //Button to insert a link. Default true
        "image": false, //Button to insert an image. Default true,
        "color": false //Button to change color of font
    });
    $('.wysihtml5-less-image').wysihtml5({
        "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
        "emphasis": true, //Italics, bold, etc. Default true
        "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
        "html": false, //Button which allows you to edit the generated HTML. Default false
        "link": true, //Button to insert a link. Default true
        "image": true, //Button to insert an image. Default true,
        "color": false //Button to change color of font
    });

    $('.nested-field').each(function(){
        $(this).nestedFields({
            afterInsert: function(item) {
                if (jQuery().bootstrapSwitch) {
                    $(item).find(".switch").bootstrapSwitch();
                }
                if (jQuery().bootstrapFileInput) {
                    $(item).find('input[type=file]').bootstrapFileInput();
                }
                if (jQuery().datetimepicker) {
                    $(item).find(".datetimepicker").datetimepicker();

                    $(item).find(".datepicker").datetimepicker({pickTime: false});

                    $(item).find(".timepicker").datetimepicker({pickDate: false});
                }
            }
        });
    });

    $('body').on('change', '.file-input-wrapper input[type=file]', function(){
        if (this.files && this.files[0]) {
            var $this = $(this);
            var image =  $this.parent().prev('img');

            if (image.length <= 0) {
                image = $this.parent().prev('.crop').find('img');
            }

            var fileReader = new FileReader();
            fileReader.onload = function(e) {

                // there is two ways to show image preview for user
                // if the input field has class 'fit-placeholder-size', the preview image will fill the size of placeholder image
                if ($this.hasClass('fit-placeholder-size')) {
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
                } else {
                    image.attr('src', e.target.result);
                }
            };
            fileReader.readAsDataURL(this.files[0]);
        }
    });

    var slideSort = $('#slide-sortable');
    if (slideSort.length > 0) {
        slideSort.sortable({
            placeholder: 'ui-state-highlight'
        });

        slideSort.on('sortupdate', function(event, ui){
            $('.sort-item').each(function(index){
                $(this).val(index + 1);
            });
        });
    }

    var broadcastSortable = $('#broadcast-sortable');
    if (broadcastSortable.length > 0) {
        broadcastSortable.sortable({
            placeholder: 'ui-state-highlight'
        });

        broadcastSortable.on('sortupdate', function(event, ui){
            $('.sort-item').each(function(index){
                $(this).val(index + 1);
            });
        });
    }

    $('.fileupload').each(function(i){
        var fileUploadBlock = $(this);

        // Initialize the jQuery File Upload widget:
        fileUploadBlock.fileupload();
        //
        // Load existing files:
        $.getJSON(fileUploadBlock.attr('action'), function (files) {
            var fu = fileUploadBlock.data('blueimpFileupload'),
                template;
            fu._adjustMaxNumberOfFiles(-files.length);
            template = fu._renderDownload(files)
                .appendTo(fileUploadBlock.find('.files'));
            // Force reflow:
            fu._reflow = fu._transition && template.length &&
                template[0].offsetWidth;
            template.addClass('in');
            $('#loading').remove();
        });
    });

    $('.lang-options').on('change', function(){
        $('.decline-btn').attr('href', $('.' + $(this).val()).text());
    });

    $('.box').on('change', '.youtube-link', function(){
        // gsub(/[https|http]+:\/\/www\.youtube\.com\/watch\?v=([\w\d]+)/, '\1')
        if ($(this).val().match(/[https|http]+:\/\/www\.youtube\.com\/watch\?v=([\w\d]+)/)) {
            var youtubeId = $(this).val().replace(/[https|http]+:\/\/www\.youtube\.com\/watch\?v=([\w\d]+)/, '$1');
            $(this).closest('.box').find('img').attr('src', 'http://img.youtube.com/vi/' + youtubeId + '/maxresdefault.jpg');
        }
    });


    if ($("#stats-chart1").length !== 0 && $("#stats-chart2").length !== 0) {
        $.ajax({
            url: 'admin.json',
            dataType: 'json',
            type: 'GET',
            success: function(data, textStatus, jqXHR){
                $.plot($("#stats-chart1"), [
                    {
                        data: data.order_quantity_each_day,
                        label: "New Orders"
                    }
                ], {
                    series: {
                        lines: {
                            show: true,
                            lineWidth: 3
                        },
                        shadowSize: 0
                    },
                    legend: {
                        show: false
                    },
                    grid: {
                        clickable: true,
                        hoverable: true,
                        borderWidth: 0,
                        tickColor: "#f4f7f9"
                    },
                    colors: ["#00acec", "#f8a326"],
                    xaxis: {
                        mode: "time",
                        timeformat: "%y/%m/%d"
                    }
                });

                $.plot($("#stats-chart2"), [
                    {
                        data: data.new_user_each_day,
                        label: "New Users"
                    }
                ], {
                    series: {
                        lines: {
                            show: true,
                            lineWidth: 3
                        },
                        shadowSize: 0
                    },
                    legend: {
                        show: false
                    },
                    grid: {
                        clickable: true,
                        hoverable: true,
                        borderWidth: 0,
                        tickColor: "#f4f7f9"
                    },
                    colors: ["#f8a326"],
                    xaxis: {
                        mode: "time",
                        timeformat: "%Y/%m/%d"
                    }
                });
            },
            error: function(jqXHR, textStatus, errorThrown){

            }
        });
    }
})();