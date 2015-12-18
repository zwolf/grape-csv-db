$(function() {

  function reload_table (data) {
    $("#api-output").html(data);    
    console.log(data);
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

        // $('#ring_value').text("rang " + data.rang.toString() + " time(s)");
        // $('#ring_action').text("click here to ring again");
      }
    });
  };

  $('.data-grabber').click(function() {
    console.log("clicked " + $(this).attr('id'))
    get_data($(this).attr('id'))
  });
});
