class Permission
  attr_reader :rules, :alias, :user

  def initialize(user)
    @user = user
    @rules = {}
    @alias = {}
  end

  def can(action, object, &blk)
    @rules.merge!("#{action}-#{object.name}" => blk)
  end

  def alias_action(*args)
    to_action = args.extract_options![:to]
    from_action = args
    from_action.each do |action|
      @alias[action] = to_action
    end
  end

  def authorize!(action, object)
    all_value = @rules["#{action}-all"] || @rules["#{@alias[action]}-all"]
    all_value && all_value.call(object) and return true

    name = if object.respond_to?(:superclass)
             object.name
           else
             object.class.name
           end
    rule_key = "#{action}-#{name}"
    unless @rules[rule_key]
      if @alias[action]
        rule_key = "#{@alias[action]}-#{name}"
      end
    end

    rule_value = @rules["#{action}-#{name}"]

    unless rule_value && rule_value.call(object)
      raise AccessDenied.new("没有权限访问！")
    end
  end

  class AccessDenied < Exception
  end
end
