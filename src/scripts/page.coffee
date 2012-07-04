show_signedin: (user_email) =>
  $('#signedout').hide()
  $('#signedin').show()
  $('#signed_in_as').text "Signed in as #{user_email}"

check_signedin: =>
  false

$(document).ready ->
  ## signin stuff
  #check_signedin()
  $signin =  $('#signin')

  # show signin div on signin button click
  $('#signin_button').click ->
    $signin.css 'left', Math.max(($(window).width() - $signin.width())/2, 0) # center it
    $signin.show()

  # set form action for signing
  $signin_form = $('#signin_form')
  $signin_form.submit ->
    data = $signin_form.serialize()
    $.post('/signin', data)
    .done (received) ->
      console.log("signin success")
      $signin.hide()
      show_signedin(data.email)
    .error (jqXHR, textStatus) ->
      console.log("signin failed: #{textStatus}")

