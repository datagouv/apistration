#!/bin/bash

rails db:drop db:create db:schema:load db:seed RAILS_ENV=development
