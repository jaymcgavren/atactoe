class Mark < Gemini::GameObject
  has_behavior :Sprite
  has_behavior :ReceivesEvents
  has_behavior :Timeable

  attr_accessor :shape

  def load(mark)
    set_image game_state.manager(:render).get_cached_image(mark)
    @shape = mark
    add_countdown :drawing, Cursor::DRAW_LOCK_DURATION, 0.03
    on_timer_tick do |timer|
      scale_image_from_original 2.0 - (timer.percent_complete)
    end
    on_countdown_complete do
      scale_image_from_original 1.0
    end
  end
  
end
