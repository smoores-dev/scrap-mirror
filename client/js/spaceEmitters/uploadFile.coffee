$ ->
  $('.direct-upload').each () ->
    # For each file selected, process and upload 
    form = $(this)

    $(this).fileupload {
      url: form.attr('action') # Grabs form's action src
      type: 'POST'
      autoUpload: true
      dataType: 'xml' # S3's XML response
      add:  (event, data) ->
        $.ajax {
          url: "/sign_s3"
          type: 'GET'
          dataType: 'json'
          data: {title: data.files[0].name} # Send filename to /signed for the signed response 
          async: false
          success: (data) ->
            # Now that we have our data, we update the form so it contains all
            # the needed data to sign the request
            form.find('input[name=key]').val data.key
            form.find('input[name=policy]').val data.policy
            form.find('input[name=signature]').val data.signature
            form.find('input[name=Content-Type]').val data.contentType
        }
        data.submit()

      # send: (e, data) ->
      #   $('.progress').fadeIn(); # Display widget progress bar

      progress: (e, data)->
        percent = Math.round((e.loaded / e.total) * 100)
        console.log 'progress', percent

      fail: (e, data) ->
        console.log 'fail', data
        # $('#circle').removeClass('animate');

      success: (data) ->
        url = $(data).find('Location').text(); # Find location value from XML response
        console.log 'success', url
        # $('.share-url').show(); # Show input
        # $('.share-url').val(url.replace("%2F", "/")); # Update the input with url address 

      done: (event, data) ->
        console.log 'done', data
        # When upload is done, fade out progress bar and reset to 0
        # $('.progress').fadeOut 300, () ->
        #   $('.bar').css 'width', 0

        # Stop circle animation
        # $('#circle').removeClass 'animate'
    }