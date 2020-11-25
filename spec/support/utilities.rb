def sign_in_as(user)
  post '/api/login', params: { session: { email: user.email, password: user.password } }
end