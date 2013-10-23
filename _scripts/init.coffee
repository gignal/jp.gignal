getParameterByName = (name) ->
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]')
  regex = new RegExp('[\\?&]' + name + '=([^&#]*)')
  results = regex.exec(location.search)
  (if not results? then '' else decodeURIComponent(results[1].replace(/\+/g, ' ')))


jQuery ($) ->

  $.ajaxSetup
    cache: true

  Backbone.$ = $

  document.gignal.widget = new document.gignal.views.Event()

  eventid = $('#gignal-widget').data('eventid')
  if getParameterByName 'eventid'
    eventid = getParameterByName 'eventid'

  document.gignal.stream = new Stream [],
    url: '//api.gignal.com/fetch/' + eventid + '?callback=?'
    #url: '//localhost:3000/fetch/' + eventid + '?callback=?'


  $(window).on 'scrollBottom', offsetY: -100, ->
    document.gignal.stream.update true
