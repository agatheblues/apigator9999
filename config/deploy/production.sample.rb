# frozen_string_literal: true

set :stage, :production
set :branch, 'production'

server 'SERVER_IP', user: 'USER', roles: %w[app db web]
