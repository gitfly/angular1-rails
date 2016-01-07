class Express < ActiveRecord::Base
  belongs_to :expressable, polymorphic: true

  attr_accessor :company_name

  CompanyType = {
  	"申通快递": 0,
  	"顺丰速运": 1,
  	"圆通快递": 2,
  	"韵达快递": 3,
  	"中通快递": 4,
  	"EMS邮政特快": 5,
  	"如风达快递": 6,
  	"快捷快递": 7,
  	"天天快递": 8,
  	"德邦物流": 9,
  	"宅急送": 10,
  	"百世汇通": 11,
  	"优速快递": 12,
  	"速尔快递": 13
  }

  def show
    "#{company_name}-#{number}"
  end

  def company_name
    CompanyType.key(company_type)
  end

  def company_name=(name)
    self.company_type = CompanyType[name]
  end
end
