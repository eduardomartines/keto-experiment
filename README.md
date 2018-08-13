docker-compose down; docker-compose run --rm keto-migrate

docker-compose run --rm test rspec spec/integration/role_creation_spec.rb

docker-compose run --rm test rspec spec/integration/policy_creation_spec.rb

docker-compose run --rm test rspec spec/integration/policy_authorization_spec.rb
