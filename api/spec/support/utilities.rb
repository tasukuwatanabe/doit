def sign_in_as(user)
  session_params = {
    session: {
      email: user.email,
      password: user.password
    }
  }

  post '/api/v1/login', params: session_params
end