window.app.filter 'listFilter', [ ->
  (items, searchText) ->
    if searchText && searchText.length
      filtered = []
      angular.forEach items, (item) ->
        if item.indexOf(searchText) >= 0
          filtered.push item
        return
      filtered
    else
      items
 ]
