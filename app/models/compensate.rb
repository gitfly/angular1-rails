# this model is of no use
class Compensate < ActiveRecord::Base

  belongs_to :order
  belongs_to :customer

  # 减免多少钱？多少折？免单选项？赔付多少费用？
  CType = {
    0 => "减免", 
    1 => "折扣", 
    2 => "免单", 
    3 => "赔付"
  }

  def show_ctype
    CType[ctype]
  end
  
end
