$(document).ready ->

  # initializion bootstrap stuff
  $('#slideshow').carousel {interval: 3000}
  $('#amenities').modal {show: false}
  $('.tip').tooltip()

  # bind moment to window for global use
  window.moment = Kalendae.moment;

  # create a global availability object
  window.availability = new Availability()
  window.blackout = (date, callback) -> availability.blackoutMonth(date, callback)

# bind this to window so it can be used used as a callback for loading the google api
window.gapiCallback = () ->
  console.log 'callback'
  gapi.client.setApiKey 'AIzaSyDAYWkAAkTVcBp36gN50FTC9j9wO2M0c0o'
  gapi.client.load 'calendar', 'v3', availability.ready

