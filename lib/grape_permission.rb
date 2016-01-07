class GrapePermission < Permission
  def initialize(user)
    super(user)

    can :manage, Order do |o|
      user.type == 'Admin'
    end

    can :read, Order do |o|
      user.id
    end

  end

  # alias :update, :edit, :delete, to: :manage
end
