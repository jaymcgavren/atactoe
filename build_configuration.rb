configuration do |c|
  c.project_name = 'ATacToe'
  c.output_dir = 'package'
  c.main_ruby_file = 'main'
  c.main_java_file = 'org.rubyforge.rawr.Main'

  # Compile all Ruby and Java files recursively
  # Copy all other files taking into account exclusion filter
  c.source_dirs = ['src', 'lib/ruby']
  c.source_exclude_filter = []

  # Location of the jruby-complete.jar. Override this if your jar lives elsewhere.
  # This allows Rawr to make sure it uses a compatible jrubyc when compiling,
  # so the class files are always compatible, regardless of your system JRuby.
  #c.jruby_jar = 'lib/java/jruby-complete.jar'
  c.compile_ruby_files = true
  #c.java_lib_files = []  
  c.java_lib_dirs = ['lib/java']
  c.files_to_copy = Dir['lib/java/native_files/**/*']

  c.target_jvm_version = 1.5
  c.jars[:data] = { :directory => 'data', :location_in_jar => 'data', :exclude => /bak/}
  c.jvm_arguments = "-XX:+UseConcMarkSweepGC -Djruby.compile.mode=FORCE -Xms256m -Xmx512m"
  c.java_library_path = "lib/java/native_files"
  
  c.mac_icon_path = 'data/icon.icns'
  # c.windows_icon_path = 'data/icon.ico'

  # Bundler options
  # c.do_not_generate_plist = false
end
