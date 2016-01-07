# module AssetViewHelper
#   def user_avatar(user, options={})
#     if user.avatar?
#       image_tag user.avatar.url(:thumb), class: "img-#{options[:type]||'circle'}", size: options[:size]||'90x90'
#     else
#       image_tag "#{user.gender_attr}.svg", class: "img-#{options[:type]||'circle'}", size: options[:size]||'90x90'
#     end
#   end
# 
#   def active_class(name)
#     'active' if params[:controller]==name
#   end
# 
#   def user_link(user, options={})
#     link_to user_avatar(user, options)
#   end
# 
#   def custom_form_for(object, *args, &block)
#     self.class.class_eval do
#       include SimpleForm::ActionViewExtensions::FormHelper
#     end
#     simple_form_for(object, *args, &block)
#   end
# 
# end
