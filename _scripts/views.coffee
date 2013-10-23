class document.gignal.views.Event extends Backbone.View

  el: '#gignal-widget'
  columnWidth: 230
  isotoptions:
    itemSelector: '.gignal-outerbox'
    layoutMode: 'masonry'
    sortAscending: false
    sortBy: 'saved_on'
    getSortData:
      saved_on: (el) ->
        parseInt(el.data('saved_on'), 10)

  initialize: ->
    # set Isotope masonry columnWidth
    radix = 10
    magic = 20
    mainWidth = @$el.innerWidth()
    columnsAsInt = parseInt(mainWidth / @columnWidth, radix)
    @columnWidth = @columnWidth + (parseInt((mainWidth - (columnsAsInt * @columnWidth)) / columnsAsInt, radix) - magic)
    # init Isotope
    @$el.isotope @isotoptions

  refresh: =>
    @$el.imagesLoaded =>
      @$el.isotope @isotoptions


class document.gignal.views.TextBox extends Backbone.View
  tagName: 'div'
  className: 'gignal-outerbox'
  initialize: ->
    @listenTo @model, 'change', @render
  render: =>
    @$el.data 'saved_on', @model.get('saved_on')
    # set width
    @$el.css 'width', document.gignal.widget.columnWidth
    # owner?
    if @model.get 'admin_entry'
      @$el.addClass 'gignal-owner'
    # else if @model.get('username') is 'roskildefestival' and @model.get('service') is 'Instagram'
    #   @$el.addClass 'gignal-owner'
    data = @model.getData()
    if not data.message
      document.gignal.widget.$el.isotope 'remove', @$el
    @$el.html Templates.post.render data,
      footer: Templates.footer
    return @


class document.gignal.views.PhotoBox extends Backbone.View
  tagName: 'div'
  className: 'gignal-outerbox'
  events:
    'click a.direct': 'linksta'
  initialize: ->
    @listenTo @model, 'change', @render
    # image exist?
    img = new Image()
    img.src = @model.get 'large_photo'
    img.onerror = =>
      document.gignal.widget.$el.isotope 'remove', @$el
  render: =>
    @$el.data 'saved_on', @model.get('saved_on')
    # set width
    @$el.css 'width', document.gignal.widget.columnWidth
    # owner?
    if @model.get 'admin_entry'
      @$el.addClass 'gignal-owner'
    # else if @model.get 'username' is 'roskildefestival' and @model.get 'service' is 'Instagram'
    #   @$el.addClass 'gignal-owner'
    # get data
    data = @model.getData()
    # img exist?
    if not data.photo
      document.gignal.widget.$el.isotope 'remove', @$el
      return
    # render
    @$el.html Templates.photo.render @model.getData(),
      footer: Templates.footer
    return @
  linksta: (event) =>
    if @model.get('service') is 'Instagram'
      event.preventDefault()
      $.getJSON('https://api.instagram.com/v1/media/' + @model.get('original_id') + '?client_id=3ebcc844a6df41169c1955e0f75d6fce&callback=?')
      .done (response) =>
        if response.data?
          window.open response.data.link, '_blank'
