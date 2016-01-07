window.app.service('SimpleFormModel', function() {
  this.deliveryAddress = {
    name: {
      label: "收件人姓名"
    },
    phone: {
      label: "收件人电话"
    }, 
    details: {
      label: "详细地址"
    }
  }
  this.friend = {
    name: {
      label: "朋友姓名", 
      placeholder: "请输入朋友姓名"
    },
    phone: {
      label: "朋友电话", 
      placeholder: "请输入朋友电话"
    }
  }
  this.item = {
    showType: {
      label: "物品类型", 
      placeholder: "请选择物品类型"
    }, 
    brand: {
      label: "品牌"
    }, 
    version: {
      label: "型号"
    }, 
    color: {
      label: "颜色"
    }, 
    style: {
      label: "款式"
    }
  }

  this.order = {
    deliveryDate: {
      label: "送货日期"
    },
    serviceName: {
      label: "服务类型"
    }, 
    attachment: {
      label: "附件"  
    }, 
    part: {
      label: "配件"  
    },
    diagnose: {
      label: "顾问诊断"  
    },
    request: {
      label: "顾客需求"  
    }, 
    startWorkDate: {
      label: "开工日期"  
    }, 
    finishDate: {
      label: "完工日期"  
    }, 
    urgent: {
      label: "是否加急"  
    }, 
    deliveryManner: {
      label: "送货方式"  
    }, 
    source: {
      label: "来源", 
      placeholder: "物品来源, 例如专卖店购买等"
    },
    discount: {
      label: "折扣"  
    }, 
    buyDate: {
      label: "购买日期"
    }, 
    gift: {
      label: "订单赠品"  
    }
  }
  this.currentOrder = this.order

  this.appointment = {
    cancelTyep: "取消原因"  
  }
})
