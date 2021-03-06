jQuery(document).ready(function($) {

  var displayMessage = function(className, msg) {
    $('.content').prepend('<div class="' + className + '">' + msg + '</div>');
  }
  
  $('.step_details.bottom h2 span a').click(function() {
    var self = $(this);
    self.text(self.text() == "Show" ? "Hide" : "Show");
    self.closest('.form_element').next().toggle("fast");
    return false;
  });
  
  $('a.delete').click(function() {
    var answer = confirm('Are you sure?');
    var self = $(this);
    if (answer) {
      $.post(self.attr('href'), { "_method": "delete" }, function(data) {
        self.closest('tr').remove();
        displayMessage('notice', data);
        }, "js");
    }
    return false;
  });
  
  $('a.approve').click(function() {
    var self = $(this);
    $.post(self.attr('href'), { "_method": "put", "approved": true }, function(data) {
      self.replaceWith(data);
    }, "js");
    
    return false;
  });
  
  $('a.fork').live('click', function() {
    if($(this).attr('rel') != "") {
      $(this).nextAll('div.hidden').slideToggle("slow");
      return false;
    }
  });
  
  $('a.send_to_gist').live('click', function() {
    var self = $(this);
    $.get(self.attr('href'), function(data) {
      self.replaceWith('<a href="' + data + '">View Gist</a>');
    });
    return false;
  });
  
  $('a.vote').click(function() {
    var self = $(this);
    if (!self.is(".reg")) {
      value = self.is(".vote_up") ? 1 : -1;
      $.post(self.attr('href'), { "vote[score]": value }, function(data) {
        var votes = self.closest(".votes");
        var count = self.is(".vote_up") ? votes.find(".positive_vote") : votes.find(".negative_vote");
        var score = parseInt(count.html());
        score = score + value;
        
        count.html((self.is(".vote_up") ? "+" : "") + score);
        
        self.closest('.action').html("Voted");
      
      });
      return false;
    }
  });
  
  $.fn.slider = function(size) {
    this.each(function() { $(this).data("originalHeight", $(this).height()); })
      .height(size).toggle(function() { 
        $(this).animate({height: $(this).data("originalHeight")}, "slow");
      }, function() {
        $(this).animate({height: size});
      });
  }
  
  $(".refactor .gist-data").slider(125);
  $("#snippet.code .gist-data:first").slider(200);

  $('.calendar .day').hover(function() {
    $(this).addClass("rollover");
  },
  function() {
    $(this).removeClass("rollover");
  });
  
  $('a.month').live('click', function() {
    var self = $(this);
    $.get(self.attr('href'), function(data) {
      self.parents('.content').html(data);
    });
    return false;
  });

});

jQuery(document).ajaxSend(function(event, request, settings) {
  if (settings.type == 'GET' || settings.type == 'get' || typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} });


	
