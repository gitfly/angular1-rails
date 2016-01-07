app = window.app

app.run (Permission, Rails) ->
  user = Rails.currentUser
  Permission.defineRole('anonymous', (stateParams) ->
    return !!user
  )
  roles = [
    'Admin',
    'Manager',
    'Finance',
    'Worker',
    'Counselor',
    'FrontDesker',
    'Solutionist',
    'CustomerService',
    'CounselorManager'
  ]
  _.each(roles, (role) ->
    Permission.defineRole(role, (stateParams) ->
      return user.type == role
    )
  )
