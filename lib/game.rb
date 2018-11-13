class Game
  attr_accessor :board, :player_1, :player_2, :timer

  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2]
  ]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new, wargame = false)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
    @wargame = wargame
    @timer = 1.5
  end

  def current_player
    @board.turn_count % 2 == 0 ? player_1 : player_2
  end

  def won?
    WIN_COMBINATIONS.detect do |combo|
      @board.cells[combo[0]] == @board.cells[combo[1]] &&
      @board.cells[combo[1]] == @board.cells[combo[2]] &&
      @board.taken?(combo[0]+1)
    end
  end

  def draw?
    @board.full? && !won?
  end

  def over?
    draw? || won?
  end

  def winner
    if won = won?
      @winner = @board.cells[won.first]
    end
  end

  def turn
    player = current_player
    current_move = player.move(@board)
    if !@board.valid_move?(current_move)
      turn
    else
      puts "Turn: #{@board.turn_count+1}\n"
      @board.display
      @board.update(current_move, player)
      puts "#{player.token} moved #{current_move}"
      @board.display
      puts "\n\n"
    end
  end

  def play
    while !over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end
  def wargames
    @counter = 0
    x = 0
    o = 0
    draw = 0
    until @counter == 100
      @counter += 1
      play
      if draw?
        draw += 1
      elsif winner == "X"
        x += 1
      elsif winner == "O"
        o += 1
      end
      sleep(@timer*1.5)
      @timer -= (@timer/3)
    end
    puts "This round had #{x} wins for X, #{o} wins for O, and #{draw} draws."
    puts "A STRANGE GAME. THE ONLY WINNING MOVE IS NOT TO PLAY."
    puts "HOW ABOUT A NICE GAME OF CHESS?"
  end
end
