app = window.app
app.controller "storageDetailCtrl", (
  $scope,
  StorageDetail
  
) ->
 
  $scope.selectByDate = (from) ->
    $scope.export_from = from
    
    StorageDetail.query({from:from }).then ((results) ->
      $scope.items = results.items
      $scope.from = results.from
      return
    ), (error) ->
      return





  









