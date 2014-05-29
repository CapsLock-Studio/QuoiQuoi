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

var convertPreview = function(link, youtubeBlock) {
    if (link.match(/[https|http]+:\/\/www.youtube.com\//)) {
//        var youtubeBlock = $(element).parent('div').find('.youtube-block');
        $(youtubeBlock).html('<iframe style="width:100%;height:' + $(youtubeBlock).height() + 'px;" src="' + link.replace(/[https|http]+:\/\/www\.youtube\.com\/watch\?v=([\w\d]+)/, '//www.youtube.com/embed/$1') + '" frameborder="0" allowfullscreen></iframe>');
    }
};

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
    $(".aside-menu-switch, #btnHideAsideMenu, .navbar-toggle-aside-menu").click(function(){
        var asideMenu = $("#asideMenu");
        if($('.aside-menu-in').length <= 0){
            $("body").addClass("aside-menu-in");
        } else {
            $("body").removeClass("aside-menu-in");
        }
        return false;
    });
};