class Mark < Gemini::GameObject
  has_behavior :Sprite

  attr_accessor :shape

  def load(mark)
    set_image game_state.manager(:render).get_cached_image(mark)
    @shape = mark
  end

end
