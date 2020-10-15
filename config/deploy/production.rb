server '54.238.125.60',
       user: 'tasuku',
       roles: %w{app db web},
       ssh_options: {
         user: 'tasuku',
         keys: %w(~/.ssh/id_rsa),
         forward_agent: true,
         port: 22,
         auth_methods: %w{publickey}
       }
