object :users

node(:users) do |m|
  @users.map do |user|
    partial('users/brief', object: user)
  end
end

node(:roles) do |m|
  User::Roles.to_a
end

