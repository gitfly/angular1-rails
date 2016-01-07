module AssetsHelper
  def user_avatar(user, options={})
    if user.avatar?
      image_tag user.avatar.url(:thumb), class: "img-#{options[:type]||'circle'}", size: options[:size]||'90x90'
    else
      image_tag "#{user.gender_attr}.svg", class: "img-#{options[:type]||'circle'}", size: options[:size]||'90x90'
    end
  end

  def active_class(name)
    'active' if params[:controller]==name
  end

  def user_link(user, options={})
    link_to user_avatar(user, options)
  end

  # def input_for(name, options={})
  #   type = options[:type]||'string'
  #   object_name = name.split('[').first
  #   attr = name.split('[').last.chop
  #   content_tag(:div, class: "form-group #{type} #{'required' if options[:required]} customer_phone") do
  #     ''.tap do |html|
  #       unless options[:label] === false
  #         html << content_tag(:div, class: 'inline-label col-sm-2') do
  #           content_tag(:label, class: type) do
  #             label_html = I18n.t("simple_form.labels.#{object_name}.#{attr}")
  #             label_html.prepend(
  #               content_tag(:abbr, '*', title: 'required')
  #             ) if options[:required]
  #             label_html.html_safe
  #           end
  #         end
  #       end

  #       html << content_tag(:div, class: 'col-sm-10 inline-input') do
  #       end
  #     end
  #   end
  # end

  def select2_input(name, label=nil, options={})
    content_tag(:div, class: 'form-group string required') do
      ''.tap do |str|
        if label
          str << content_tag(:div, class: 'inline-label col-sm-2') do
            content_tag(:label, class: 'string') do
              label.prepend(content_tag(:abbr, '*', title: 'required')).html_safe
            end
          end
        end

        options.merge!(
          class: "form-control select select-default select-block ",
          'ng-model': "#{options[:model]}", 
          'ui-select2': ""
        )

        options[:class] << ' multiselect multiselect-default' if options[:multiple]

        str << content_tag(:div, class: 'col-sm-10 inline-input') do
          select_tag name, options_for_select(options.delete(:collection)), options
        end
      end.html_safe
    end
  end
end
