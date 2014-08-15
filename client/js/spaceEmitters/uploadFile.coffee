$ ->

  $('input:file').change () ->
    filePath = $(this).val()
    lastSlash = filePath.lastIndexOf "\\"
    fileName = filePath.substring(lastSlash + 1)

    s3upload = new window.S3Upload {
      s3_object_name: fileName,
      file_dom_selector: 'files',
      s3_sign_put_url: '/sign_s3',
      onProgress: (percent, message) ->
        console.log 'Upload progress:', percent, '%',  message
      onFinishS3Put: (public_url) ->
        console.log 'Upload completed. Uploaded to:', public_url
        # '<img src="' + public_url + '" style="width:300px;" />'
      onError: (status) -> 
        console.log 'Upload error:', status
    }
