paths = %w(
  .env
  .env.local
  .ruby-version
  .rbenv-vars
  config/**
  lib/**
  tmp/restart.txt
  tmp/caching-dev.txt
  db/migrate
)

paths.each { |path| Spring.watch path }
