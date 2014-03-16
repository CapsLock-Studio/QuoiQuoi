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