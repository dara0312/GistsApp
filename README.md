# GistsApp

GistsApp uses [GitHub API v3](https://developer.github.com/v3/).

## Information

* Ruby version

ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-darwin15]

* Rails version

Rails 5.0.0.1

* Library added

Ghee ~> 0.15.22

This library has been modified for gotting headers and body request response [Gists API](https://developer.github.com/v3/gists/).

## Getting Started

1- Run `bundle install`
```bash
bundle install
```
2- Add your `access_token` in `config/gists.yml`
``` yaml
development:
  access_token: 54f5e4f54ef54e5f4e54f5e4f5e
```
3- Start Rails server
```bash
rails s
```
4- Visit [localhost:3000](localhost:3000)
