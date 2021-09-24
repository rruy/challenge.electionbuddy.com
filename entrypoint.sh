#!/bin/bash

bundle exec rails db:setup
bundle exec rails server -b 0.0.0.0