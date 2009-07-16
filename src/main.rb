require 'java'

$LOAD_PATH.clear
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

# only when running in non-standalone
if File.exist? File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'java'))
  jar_glob = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'java', '*.jar'))
  Dir.glob(jar_glob).each do |jar|
    $CLASSPATH << File.expand_path(jar)
  end
end
%w{behaviors game_objects input_helpers input_mappings states}.each do |dir|
  $LOAD_PATH << File.expand_path("src/#{dir}")
end

require 'gemini'

begin
  # Change :HelloState to point to the initial state of your game
  Gemini::Main.start_app("ATacToe", 768, 768, :MainState, false)
rescue => e
  warn e
  warn e.backtrace
end
