app = window.app;

app.controller('leftSideBarCtrl', function($scope) {

  $scope.leftSideBar = [
    {
      key: 'home',
      value: '首页',
      icon: 'fui-home'
    },
    {
      key: 'orders', 
      value: '订单',
      icon: 'fui-list-thumbnailed'
    },
    {
      key: 'customers',
      value: '顾客',
      icon: 'fui-user'
    },
    {
      key: 'operation',
      value: '运营',
      icon: 'fui-bookmark'
    },
    {
      key: 'sarehouse',
      value: '库管',
      icon: 'fui-lock'
    },
    {
      key: 'datareport',
      value: '报表',
      icon: 'fui-list-numbered'
    },
    {
      key: 'solutionists',
      value: '方案',
      icon: 'fui-document'
    },
    {
      key: 'workers',
      value: '工人',
      icon: 'fui-calendar-solid'
    },
    {
      key: 'settings',
      value: '设置',
      icon: 'fui-gear'
    }, 
    { 
      key: 'users', 
      value: '用户', 
      icon: 'fui-user'
    }
  ];

  $scope.leftSideBar[1].menus =
    [
      {
        key: 'orders',
        value: '订单列表',
        icon: 'fui-list-bulleted'
      // }, {
        // key: 'reconciliation',
        // value: '每日对账',
        // icon: 'fui-eye'
      }, {
        key: 'fetchDelivery',
        value: '取送列表',
        icon: 'glyphicon-eye'
      }, {
        key: 'fetchDeliveryDetail',
        value: '取送提醒',
        icon: 'glyphicon-import'
      }, {
        key: 'appointments',
        value: '预约待收',
        icon: 'glyphicon-gift'
      // }, {
        // key: 'objectManage',
        // value: '物品分类',
        // icon: 'glyphicon-gift'
      }, {
        key: 'serviceType',
        value: '服务类型',
        icon: 'fui-calendar-solid'
      }
    ];

  $scope.leftSideBar[3].menus = [
    {
      key: 'activities',
      value: '活动页面',
      icon: 'fui-star'
    }
  ]

  $scope.leftSideBar[4].menus = [
    {
      key: 'store',
      value: '门店',
      icon: 'fui-arrow-right'
    }
  ]

  $scope.leftSideBar[5].menus = [
    {
      key: 'reportHome',
      value: '首页',
      icon: 'fui-list-bulleted'
    }, {
      key: 'orderitem',
      value: '订单明细',
      icon: 'fui-list-bulleted'
    }, {
      key: 'overdueOrder',
      value: '超期订单',
      icon: 'fui-list-bulleted'
    }, {
      key: 'paymentDetail',
      value: '结算明细',
      icon: 'fui-list-bulleted'
    }, {
      key: 'customerDetail',
      value: '用户明细',
      icon: 'fui-star'
    },{
      key: 'storageDetail',
      value: '出入库明细',
      icon: 'fui-star'
    },{
      key: 'target',
      value: '数据目标',
      icon: 'fui-star'
    }, {
      key: 'reconciliation',
      value: '每日对账',
      icon: 'fui-star'
    }, {
      key: 'turnover',
      value: '每日流水',
      icon: 'fui-star'
    }, {
      key: 'customize',
      value: '数据定制',
      icon: 'fui-star'
    }
  ]

  $scope.leftSideBar[6].menus = [
    {
      key: 'create',
      value: '写方案',
      icon: 'fui-document'
    }, {
      key: 'symptoms',
      value: '症状库',
      icon: 'fui-loop'
    }, {
      key: 'soluTemplates',
      value: '模板库',
      icon: 'fui-folder'
    }, {
      key: 'descriptions',
      value: '话术库',
      icon: 'fui-bookmark'
    }
  ]

  $scope.leftSideBar[7].menus = [
    {
      key: "reworkOrders",
      value: '返工记录',
      icon: 'fui-loop'
    }
  ]

  $scope.leftSideBar[9].menus = [
    {
      key: "userManagement",
      value: '用户管理',
      icon: 'fui-list'
    }
  ]

  $scope.showSidebarText = false
  $scope.sidebarTextStatusChange = function(val) {
    $scope.showSidebarText = val
  }
});
