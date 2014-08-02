$ ->

  $('article.website').click (event) ->
    url = $(this).data('content')
    # // url.attr("target", "_blank");
    console.log(url);
    myWindow = window.open('http://'+url);
