class OrderLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :order

  default_scope { order("created_at desc") }

  acts_as_paranoid

  serialize :changed_values, Hash
  
  def user_name
    user.try(:name)
  end

  def user_avatar
    user.try(:avatar)
  end

  def show_type
    I18n.t("order_log.handle.#{handle_type}")
  end

  def show_attrs
    return '' if attrs.blank?
    attrs.split('|').map do |attr|
      excepted_attrs = %w(
        created_at updated_at paid delivery_date_detail fetch_date_detail
      )
      unless excepted_attrs.include?(attr)
        I18n.t("activerecord.attributes.order_log.#{attr}")
      end
    end.compact.join(', ')
  end

  def show_time
    created_at.strftime("%m月%d日%H点%M分").tap do |str|
      str.first == '0' and str[0]=''
    end
  end

end
