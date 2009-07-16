class Cursor < Gemini::GameObject
  has_behavior :Sprite
  has_behavior :ReceivesEvents
  has_behavior :Timeable

  attr_accessor :player_id
  attr_accessor :grid_x, :grid_y
  attr_accessor :locked
  
  DRAW_LOCK_DURATION = 0.20
  
  def load(player)
    self.player_id = player
    set_image game_state.manager(:render).get_cached_image(mark == :x ? :x_cursor : :o_cursor)
    image_scaling 1.5
    self.grid_x = self.grid_y = 0
    
    @locked = false

    @screen_center_x = game_state.screen_width / 2
    @screen_center_y = game_state.screen_height / 2
    self.x = @screen_center_x
    self.y = @screen_center_y
    
    handle_event :change_y, :change_y
    handle_event :change_x, :change_x
    handle_event :draw_mark, :draw_mark
    
    on_update do |delta|
      update_image
    end
    
    on_countdown_complete do |name|
      @locked = false
    end
    
  end

private

  def change_y(message)
    return unless player_id == message.player
    @grid_y = message.value
    update_image
  end

  def change_x(message)
    return unless player_id == message.player
    @grid_x = message.value
    update_image
  end

  def draw_mark(message)
    return unless player_id == message.player
    return if @locked
    if game_state.grid[@grid_x][@grid_y].nil?
      @locked = true
      add_countdown :lock, DRAW_LOCK_DURATION, 0.03
      new_mark = game_state.create :Mark, mark
      new_mark.move(self.x, self.y)
      game_state.grid[@grid_x][@grid_y] = new_mark
      game_state.manager(:sound).play_sound :draw
    else
      game_state.manager(:sound).play_sound :no
    end  
  end
  
  def update_image
    move(@screen_center_x + (@grid_x * 250), @screen_center_y + (@grid_y * 300))
  end
  
  def mark
    player_id == 0 ? :x : :o
  end

end
