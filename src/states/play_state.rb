class PlayState < Gemini::BaseState
  
  attr_accessor :grid
  attr_accessor :score_x
  attr_accessor :score_o

  def load(target_score, score_x, score_o)
    @target_score = target_score
    @score_x = score_x
    @score_o = score_o
    
    set_manager :sound, create(:SoundManager)
    
    manager(:game_object).add_layer_at :gui_text, 5
    
    manager(:render).cache_image :x, "x.png"
    manager(:render).cache_image :o, "o.png"
    manager(:render).cache_image :x_cursor, "x-cursor.png"
    manager(:render).cache_image :o_cursor, "o-cursor.png"
    manager(:render).cache_image :x_match, "x-match.png"
    manager(:render).cache_image :o_match, "o-match.png"

    manager(:sound).add_sound :draw, "draw.wav"
    manager(:sound).add_sound :no, "no.wav"
    manager(:sound).add_sound :win, "woo-hoo.wav"
    manager(:sound).add_sound :tie, "huh.wav"

    load_keymap :PlayKeymap

    create :Background, "grid.png"
    
    game_end_checker = create :GameObject, :Updates, :ReceivesEvents
    game_end_checker.handle_event :quit do
      switch_state :MenuState, target_score
    end
    game_end_checker.on_update do
      marks = winning_marks
      if marks
        increment_score(marks.first.shape)
        show_winner(marks)
        game_won(marks.first.shape)
      elsif tie?
        game_tied
      else
        next
      end
    end

    after_warmup = create :GameObject, :Timeable
    after_warmup.add_countdown(:warmup, 1)
    after_warmup.on_countdown_complete do
      #TODO
    end

    [0, 1].each do |player_id|
      create :Cursor, player_id
    end
    
    @score_text_x = create(:Text,
      "X: #{@score_x}",
      :position => Vector.new(screen_width * 0.1, screen_height * 0.1),
      :justification => :center
    )
    @score_text_x.size = 60
    @score_text_o = create(:Text,
      "O: #{@score_o}",
      :position => Vector.new(screen_width * 0.9, screen_height * 0.1),
      :justification => :center
    )
    @score_text_o.size = 60
    
    @grid = Hash.new{|h,k| h[k] = Hash.new}
    
  end
  
  private
  
    def winning_marks
      [
        #Compare columns.
        [@grid[-1][-1], @grid[-1][ 0], @grid[-1][ 1]],
        [@grid[ 0][-1], @grid[ 0][ 0], @grid[ 0][ 1]],
        [@grid[ 1][-1], @grid[ 1][ 0], @grid[ 1][ 1]],
        #Compare rows.
        [@grid[-1][-1], @grid[ 0][-1], @grid[ 1][-1]],
        [@grid[-1][ 0], @grid[ 0][ 0], @grid[ 1][ 0]],
        [@grid[-1][ 1], @grid[ 0][ 1], @grid[ 1][ 1]],
        #Compare diagonals.
        [@grid[-1][-1], @grid[ 0][ 0], @grid[ 1][ 1]],
        [@grid[-1][ 1], @grid[ 0][ 0], @grid[ 1][-1]],
      ].each do |squares|
        if squares[0] and squares[1] and squares[2]
          if squares[0].shape == squares[1].shape and squares[1].shape == squares[2].shape
            return squares
          end
        end
      end
      return nil
    end
    
    def tie?
      @grid[-1][-1] and @grid[-1][ 0] and @grid[-1][ 1] and
      @grid[ 0][-1] and @grid[ 0][ 0] and @grid[ 0][ 1] and
      @grid[ 1][-1] and @grid[ 1][ 0] and @grid[ 1][ 1]
    end

    def increment_score(winning_mark)
      case winning_mark
      when :x
        @score_x += 1
        @score_text_x.text = "X: #{@score_x}"
      when :o
        @score_o += 1
        @score_text_o.text = "O: #{@score_o}"
      end
    end
    
    def display_match_winner(winner)
      end_match_text.on_countdown_complete do
        switch_state :MenuState, @target_score
      end
    end
    
    def show_winner(marks)
      marks.each do |mark|
        mark.image = manager(:render).get_cached_image(mark.shape == :x ? :x_match : :o_match)
      end
    end
    
    def game_won(winner)
      manager(:sound).play_sound :win
      if @score_x < @target_score and @score_o < @target_score
        reset_grid
      else
        switch_state :MatchWonState, @target_score, winner
      end
    end
    
    def game_tied
      manager(:sound).play_sound :tie
      reset_grid
    end
    
    def reset_grid
      @grid.keys.each do |row|
        @grid[row].keys.each do |column|
          mark = @grid[row][column]
          next unless mark
          @grid[row][column] = nil
          mark.add_countdown :fade_timer, 0.5, 0.03
          mark.on_countdown_complete do
            remove mark
          end
          mark.on_timer_tick do |timer|
            mark.color.transparency = timer.percent_complete
          end
        end
      end
    end
    
end
