Backbone.Views ||= {}

class Backbone.Views.WorkspaceShowView extends Backbone.View
  template: JST["backbone/templates/area_tabs"]

  events:
    'click #add-area': 'addArea'
    'click .tab': 'changeTab'
    'click #delete-area': 'removeArea'
    'click .active a': 'startRenameArea'
    'focusout .active input': 'finishRenameArea'
    'keypress .active input': 'returnKeyRenameArea'

  initialize: () ->
    @currentTab = new Backbone.Diorama.ManagedRegion()

  changeTab: (e) ->
    $el = $(e.target)

    unless $el.parent().hasClass('active')
      pica.currentWorkspace.setCurrentArea(pica.currentWorkspace.areas[$el.attr('data-area-id')])
      @render()

  addArea: ->
    if pica.currentWorkspace.areas.length <= 3
      workspace = pica.currentWorkspace

      area = new Pica.Models.Area()
      area.setName("Area ##{pica.currentWorkspace.areas.length + 1}")

      workspace.addArea(area)
      pica.currentWorkspace.setCurrentArea(area)
      @render()

  removeArea: ->
    if @areas.length > 1
      id = @areas.indexOf(@currentArea)
      area = @areas.splice(id,1)[0]

      area.delete()

      @currentArea = @areas[@areas.length - 1]
      pica.currentWorkspace.currentArea = @currentArea
      @render()

  startRenameArea: (e) ->
    currentAreaLink = $(e.target)
    currentAreaLink.hide()
    currentAreaInput = currentAreaLink.next()
    currentAreaInput.show().focus()

  finishRenameArea: (e) ->
    currentAreaInput = $(e.target)
    currentAreaInput.hide()
    currentAreaLink = currentAreaInput.prev()
    currentAreaLink.show()

    name = currentAreaInput.val()
    pica.currentWorkspace.currentArea.setName(name)
    currentAreaLink.html(name)

  returnKeyRenameArea: (e) =>
    if e.keyCode == 13  # Return key
      @finishRenameArea(e)

  render: =>
    @$el.html(@template(areas: pica.currentWorkspace.areas, currentArea: pica.currentWorkspace.currentArea))

    areaView = new Backbone.Views.AreaView(area: pica.currentWorkspace.currentArea)
    @currentTab.showView(areaView)
    @$el.find('#area-tabs').append(@currentTab.$el)

    return @
