//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
$( document ).ready(function() {
    $("select").change(function() {
        window.location.href = "/?height=" + $("#select-height option:selected").text() + "&width=" + $("#select-width option:selected").text();
    });
});