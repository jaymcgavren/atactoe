class MenuState < Gemini::BaseState
  
  def load(target_score = 10)
    @target_score = target_score
    set_manager :sound, create(:SoundManager)
    manager(:sound).loop_song "j-hop.ogg", :volume => 0.6
    manager(:sound).add_sound :no, "no.wav"
    
    manager(:render).cache_image :grid, "grid.png"

    load_keymap :GameStartKeymap
    
    create :Background, "grid.png"
    
    create :Text, "ATacToe", :position => Vector.new(screen_width / 2, screen_height * 0.33), :justification => :center
    create :Text, "by Jay McGavren", :position => Vector.new(screen_width / 2, screen_height * 0.36), :justification => :center
    
    @target_score_text = create(:Text,
      target_score_string,
      :position => Vector.new(screen_width * 0.25, screen_height * 0.27),
      :justification => :center
    )
    create :Text, "Up/Down to change target score", :position => Vector.new(screen_width * 0.25, screen_height * 0.30), :justification => :center

    menu_handler = create :GameObject, :ReceivesEvents
    menu_handler.handle_event :change_target_score do |message|
      @target_score += message.value
      if @target_score < 1
        @target_score = 1
        manager(:sound).play_sound :no
      end
      @target_score_text.text = target_score_string
    end
    menu_handler.handle_event :quit do
      quit_game
    end
    menu_handler.handle_event :start do
      switch_state :PlayState, @target_score, 0, 0
    end

  end
  
  def target_score_string
    "Press Draw button to start a #{@target_score}-point match"
  end
  
end