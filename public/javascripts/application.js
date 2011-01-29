$(function () {  
  
  // Sorting and pagination links
  $('#users th a, #users .pagination a, #jobs th a, #jobs .pagination a').live('click', function () {  
      $.getScript(this.href);  
      return false;  
    }
  );

  // Search form
  $('#users_search, #jobs_search').submit(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });  
});  
