class TiedState < Gemini::BaseState
  
  def load(target_score, score_x, score_o)
    set_manager :sound, create(:SoundManager)
    manager(:sound).add_sound :tie, "huh.wav"
    end_game_text = create :Text, screen_width / 2, screen_height / 2, "Tie game!"
    end_game_text.size = 60
    end_game_text.add_behavior :Timeable
    end_game_text.add_countdown :end_game, 0.1
    manager(:sound).play_sound :tie
    end_game_text.on_countdown_complete do
      switch_state :PlayState, target_score, score_x, score_o
    end
  end
    
end