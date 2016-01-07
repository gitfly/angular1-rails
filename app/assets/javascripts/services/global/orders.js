window.app.factory('Orders', function(Order) {
  return function(data) {
    this.data = data

    this.length = function (){
      return this.data.length
    }

    this.first = function() {
      return this.data[0]
    }

    this.last = function() {
      return this.data[this.data.length-1]
    }

    this.index = function(item) {
      return _.indexOf(this.data, item)
    }

    this.value = function(index) {
      return this.data[index]
    }

    this.selectedIds = function () {
      var ids = []
      _.each(this.data, function(order) {
        if (order.selected) {
          ids.push(order.id)
        }
      })
      return ids
    }

    this.unSelectedIds = function () {
      var ids = []
      _.each(this.data, function(order) {
        if (!order.selected) {
          ids.push(order.id)
        }
      })
      return ids
    }

    this.selected = function (){
      return _.filter(this.data, function(order) {
        return order.selected
      })
    }

    this.unSelected = function (){
      return _.filter(this.data, function(order) {
        return !order.selected
      })
    }

    this.selectByIndex = function(index) {
      this.data[index].selected = true
      return true
    }

    this.unSelectByIndex = function(index) {
      this.data[index].selected = undefined
      return true
    }

    this.selectAll = function (){
      _.each(this.data, function(order) {
        order.selected = true
      })
      return this.data
    }

    this.unSelectAll = function (){
      _.each(this.data, function(order) {
        order.selected = true
      })
      return this.data
    }

    this.valueById = function(id) {
      if (id) {
        index = this.indexById(id)
        return this.value(index)
      } else {
        return undefined
      }
    }

    this.delete = function(index) {
      this.data.splice(index, 1)
    }
    
    this.ids = function() {
      return _.map(this.data, function(item) {
        return item.id
      })
    }

    this.indexById = function(itemId) {
      i = -1
      _.each(this.data, function(val, index) {
        if (val.id === itemId) {
          i = index
        }
      })
      return i
    }

    this.nextById = function(itemId) {
      index = this.indexById(itemId)
      debugger
      if (index >= 0) {
        debugger
        if (index < this.length()-1) {
          return this.value(index+1)
        } else if (index === this.length()-1) {
          return this.first()
        }
      } else {
        return undefined
      }
    }

    this.preById = function(itemId) {
      index = this.indexById(itemId)

      if (index >= 0) {
        if (index) {
          return this.value(index-1)
        } else {
          return this.last()
        }
      } else {
        return undefined
      }
    }
  }
})
