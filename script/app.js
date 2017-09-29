/**
 * Kore App
 * Copyright(c) 2014 Koreviz
 * MIT Licensed
 */
!function($) {
    var $el = $('.navbar-toggle')

    FastClick.attach(document.body)

    $('.navbar-collapse a:not(.dropdown-toggle)').on('click', 
    function(event) { 
        if ($el.is(':visible'))
        $el.click() 
    })
}(window.jQuery)