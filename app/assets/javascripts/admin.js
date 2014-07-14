//
// require all js in admin folder
//= require_tree ./admin

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

if($("#fileupload").length != 0) {
    $(function () {
        var fileUploadBlock = $('#fileupload');

        // Initialize the jQuery File Upload widget:
        fileUploadBlock.fileupload();
        //
        // Load existing files:
        $.getJSON(fileUploadBlock.prop('action'), function (files) {
            var fu = $('#fileupload').data('blueimpFileupload'),
                template;
            fu._adjustMaxNumberOfFiles(-files.length);
            console.log(files);
            template = fu._renderDownload(files)
                .appendTo(fileUploadBlock.find('.files'));
            // Force reflow:
            fu._reflow = fu._transition && template.length &&
                template[0].offsetWidth;
            template.addClass('in');
            $('#loading').remove();
        });

        $('.ajax-upload-insert-image-modal').on('click', '.ajax-upload-insert-image-button', function(){
           editor.composer.commands.exec( 'insertImage', $(this).data('url'));
        });
    });
}

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