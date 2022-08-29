require './lib/game'

describe Game do
  let(:player1) { double('Player1') }
  let(:player2) { double('Player2') }
  before do
    allow_any_instance_of(described_class).to receive(:create_players).and_return([player1, player2])
  end

  describe '#run' do
    subject(:game_run) { described_class.new }

    before do
      allow(game_run).to receive(:execute_round)
      allow(game_run).to receive(:next_player)
      allow(game_run).to receive(:draw?)
      allow(game_run).to receive(:print_win_msg)
      allow(game_run).to receive(:print_draw_msg)
    end

    # It's impossible to occur, but it's just to test if the loop breaks
    context 'when the game is over in first round' do
      before do
        allow(game_run).to receive(:game_over?).and_return(true)
      end
      it 'completes the loop and execute round once' do
        expect(game_run).to receive(:execute_round).once
        game_run.run
      end
    end

    context 'when the game is over after 4 rounds' do
      before do
        allow(game_run).to receive(:game_over?).and_return(false, false, false, true)
      end
      it 'completes the loop and execute round four times' do
        expect(game_run).to receive(:execute_round).exactly(4)
        game_run.run
      end
    end
  end

  describe '#next_player' do
    subject(:next_player_game) { described_class.new }

    context 'when the current player is \'Player 1\'' do
      it 'switches the current player to Player two' do
        next_player_game.current_player = player1
        expect { next_player_game.next_player }.to change { next_player_game.current_player }.to player2
      end
    end
    context 'when the current player is \'Player 2\'' do
      it 'switches the current player to Player one' do
        next_player_game.current_player = player2
        expect { next_player_game.next_player }.to change { next_player_game.current_player }.to player1
      end
    end
  end

  describe '#game_over?' do
    
  end

  describe 'draw?' do
    subject(:draw_game) { described_class.new }

    context 'when the board is full' do
      it 'returns true' do
        draw_game.board = Array.new(7) { Array.new(6, 'O') }
        expect(draw_game.draw?).to be true
      end
    end

    context 'when the board isn\'t full' do
      it 'returns false' do
        draw_game.board = Array.new(7) { Array.new(6) }
        draw_game.board[0][2] = 'O'
        expect(draw_game.draw?).to be false
      end
    end
  end
end
