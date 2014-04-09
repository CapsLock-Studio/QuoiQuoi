//
// require all js in admin folder
//= require_tree ./admin

var replaceYoutubeBlock = function(){
    $('.youtube-link').on('change', function(){
        convertPreview($(this).val(), $(this).parent('div').find('.youtube-block'));
    }).each(function(){
            convertPreview($(this).val(), $(this).parent('div').find('.youtube-block'));
        });

    function convertPreview(link, youtubeBlock) {
        if (link.match(/[https|http]+:\/\/www.youtube.com\//)) {
//            var youtubeBlock = $(element).parent('div').find('.youtube-block');
            $(youtubeBlock).html('<iframe style="width:100%;height:' + $(youtubeBlock).height() + 'px;" src="' + link.replace(/[https|http]+:\/\/www\.youtube\.com\/watch\?v=([\w\d]+)/, '//www.youtube.com/embed/$1') + '" frameborder="0" allowfullscreen></iframe>');
        }
    }
};

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

$('.append-youtube').on('click', function(){
    replaceYoutubeBlock();
});

replaceYoutubeBlock();