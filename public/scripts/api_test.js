function scroll_to_table() {
  $('html, body').animate({
    scrollTop: $("#record-table").offset().top
  }, 1000);
}

function reset_form() {
  $(".input-group").removeClass("has-error");
  $("#api-error").slideUp(); 
  $("#newrecord").val("");
}

$(function() {

  function reload_table (data) {
    $("#api-output").html(data);    
    console.log(data);
    $("#total-records").html(data.length);
    $("#record-table > tbody").empty();
    $.each(data, function(idx, row) {
      newRow = "<tr><td>" + (idx + 1) + "</td>";
      newRow += "<td>" + row.first_name + "</td>";
      newRow += "<td>" + row.last_name + "</td>";
      newRow += "<td>" + row.gender + "</td>";
      newRow += "<td>" + row.favorite_color + "</td>";
      newRow += "<td>" + row.birthdate + "</td>";
      $('#record-table tbody').append(newRow);
    });
  }

  function get_data(endpoint) {
    $.get("/api/records/" + endpoint, function(data) {
      console.log("successful get");
      reload_table(data);
    });
  }

  function add_data() {
    $.ajax({
      type: "POST",
      url: "/api/records",
      data: {
        record: $("#newrecord").val()
      },
      success: function(data) {
        console.log(data);
        reset_form();
        get_data("name");
      },
      error: function(data) {
        console.log("BAD REQUEST");
        $(".input-group").addClass("has-error");
        $("#api-error").slideDown();
      } 
    });
  };

  $('.data-grabber').click(function() {
    console.log("clicked " + $(this).attr('id'))
    get_data($(this).attr('id'))
    scroll_to_table()
  });

  $('#addbutton').click(function() {
    console.log("clicked " + $(this).attr('id'))
    add_data();
    scroll_to_table()
  });


});
