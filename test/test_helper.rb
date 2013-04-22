# Run this via 'beg'
require 'working/test_helper'

def load_all_lib
  Dir['lib/**/*.rb'].each{|e| load e}
end
if defined? Spork
  Spork.each_run do load_all_lib end
else
  load_all_lib
end

# Spork.prefork doesn't like when this is missing
