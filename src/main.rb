require 'java'

$LOAD_PATH.clear
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

# only when running in non-standalone
if File.exist? File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'java'))
  jar_glob = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'java', '*.jar'))
  Dir.glob(jar_glob).each do |jar|
    $CLASSPATH << jar
  end
end

require 'gemini'

begin
  # Change :HelloState to point to the initial state of your game
  Gemini::Main.start_app("", 800, 600, :HelloWorldState, false)
rescue => e
  warn e
  warn e.backtrace
end
