Warden::Manager.before_logout do |user,auth,opts|
  user.access_tokens.delete_all
end
