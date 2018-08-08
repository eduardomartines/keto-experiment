docker-compose down; docker-compose run --rm keto-migrate

docker-compose run --rm test rspec spec/integration/policy_creation_spec.rb

ocker-compose run --rm test rspec spec/integration/policy_authorization_spec.rb
