//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var DIRECTIONS = ['NORTH', 'SOUTH', 'EAST', 'WEST'];

/**
 * Monkey patch Array class to return a random element.
 *
 * @returns {*}
 */
Array.prototype.randomElement = function () {
    return this[Math.floor(Math.random() * this.length)]
}

/**
 * Probably a much better way of doing this, but normal document.ready didn't work.
 */
function drawRobot(){
    // Always fire because if entering manual input, we need to trigger the drawing of the robot...
    $(".actions #report").click();
}

$( document ).ready(function() {
    // Reset, but with an overriding table height and width
    $("select").change(function() {
        window.location.href = "/?height=" + $("#select-height option:selected").text()
            + "&width=" + $("#select-width option:selected").text();
    });

    /**
     * Calls an AJAX URL based on the tag ID and then updates the robot position
     */
    $(".actions .ajax").click(function(e){
        e.preventDefault();

        var action = buildAction(this);

        $.ajax({type: "GET",
            url: "/robot/" + action,
            // Always error because not returning valid JSON -- not important here
            error: function(result){
                console.log("Response: " + result.responseText)
                updateRobot(result.responseText);
            }
        });
    });

    /**
     * Parses action from DOM element and, if PLACE, generates and appends random pos/direction
     *
     * @param elem
     * @returns {*|jQuery}
     */
    function buildAction(elem) {
        var action = $(elem).attr('id');

        if (action == 'place') {
            var y = Math.floor(Math.random() * $('#chess_board tr').length);
            var x = Math.floor(Math.random() * $('#chess_board tr:first-child td').length);
            var direction = DIRECTIONS.randomElement();

            action += '?x=' + x + '&y=' + y + '&direction=' + direction;
        }

        console.log("Action: " + action)
        return action;
    }

    /**
     * Picks up any robot on the table and places a robot down, outputs report
     */
    function updateRobot(str) {
        var args = str.split(",");

        // If not an error message
        if (args.length === 3) {
            var robot = $('#robot');

            // Replace robot image with co-ordinates (e.g. 1,2)
            if (robot != undefined) {
                var x = $('#robot').parent().attr('class');
                var y = $('#robot').parent().parent().attr('class');
                $('#robot').parent().html(x + ', ' + y);
            }

            // Insert the robot image
            $('table .' + args[1] + ' .' + args[0]).html('<img id="robot" src="/assets/mm-' + args[2].toLowerCase() + '.png" />')
        }

        $('#output').html('Report: ' + str);
    }

    /**
     * Place the robot and execute random-ish commands, sit back and relax!
     */
    $(".actions #chaos").click(function(e){
        // Load the 'dice' to move more often
        var actions = ['place', 'move', 'move', 'move', 'move', 'left', 'right'];

        e.preventDefault();

        for (var i = 0; i < 10; i++) {
            setTimeout(function() {
                var action = actions.randomElement();
                $('.actions #' + action).click();
            }, i * 500);
        }
    });
});