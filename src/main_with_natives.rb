system("jruby -J-Djava.library.path=lib/native_files #{File.expand_path(File.join(File.dirname(__FILE__)), 'main.rb')}")
