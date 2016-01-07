app = window.app

app.factory 'listFilter', () ->
  (list, keyword) ->
    filtered = []
    _.filter(list, (item) ->
      item.indexOf(keyword) >= 0
    )
