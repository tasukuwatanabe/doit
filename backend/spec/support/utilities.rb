def sign_in_as(user)
  post '/api/v1/login', params: { session: { email: user.email, password: user.password } }
end