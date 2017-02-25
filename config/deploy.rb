# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "viking_store"
set :repo_url, "git@github.com:ats89/viking_store.git"

set :deploy_to, '/home/deploy/viking_store'

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"