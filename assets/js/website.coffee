websiteOption = (event) ->
  url = $(this).data('content')
  # // url.attr("target", "_blank");
  console.log(url);
  myWindow = window.open('http://'+url);

$ ->
  $('article.website').on 'dblclick', websiteOption
