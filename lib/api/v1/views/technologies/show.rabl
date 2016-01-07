object @technology => false

attributes :ttype, :order_id, :remark, :end_time, :user_id, :id, 
:show_ttype, :user_name, :show_end_time, :duration, :show_start_time,
:substituted

locals[:object] ||= @technology

node(:quality_testing) do |m|
  partial('quality_testings/index', object: locals[:object].quality_testings.last)
end
