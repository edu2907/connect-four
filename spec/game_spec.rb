require './lib/game'

describe Game do
  let(:player1) { double('Player1') }
  let(:player2) { double('Player2') }
  let(:cyan_disk) { '⚫'.cyan }
  let(:blue_disk) { '⚫'.blue }
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
    subject(:end_game) { described_class.new }
    before do
      allow(player1).to receive(:disk).and_return(cyan_disk)
    end

    context 'when a horizontal line is formed' do
      # Board sample:
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ⚪ ⚫ ⚪ ⚫ ' ' '
      #  ⚪ ⚫ ⚫ ⚫ ⚫ ⚪ ⚪
      # Cyan: ⚫ | Blue: ⚪ | Empty: '

      it 'returns true' do
        end_game.board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [blue_disk, cyan_disk, blue_disk, cyan_disk, nil, nil, nil],
          [blue_disk, cyan_disk, cyan_disk, cyan_disk, cyan_disk, blue_disk, blue_disk]
        ]
        result = end_game.game_over?
        expect(result).to be true
      end
    end

    context 'when a vertical line is formed' do
      # Board sample:
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ' ' ' ⚫ ' ' '
      #  ' ' ⚪ ⚫ ' ' '
      #  ' ⚫ ⚪ ⚫ ⚫ ⚪ '
      #  ' ⚫ ⚪ ⚫ ⚪ ⚪ '
      # Cyan: ⚫ | Blue: ⚪ | Empty: '

      it 'returns true' do
        end_game.board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, cyan_disk, nil, nil, nil],
          [nil, nil, blue_disk, cyan_disk, nil, nil, nil],
          [nil, cyan_disk, blue_disk, cyan_disk, cyan_disk, blue_disk, nil],
          [nil, cyan_disk, blue_disk, cyan_disk, blue_disk, blue_disk, nil]
        ]
        result = end_game.game_over?
        expect(result).to be true
      end
    end

    context 'when a diagonal line is formed' do
      # Board sample:
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ⚫ ' ' ' ' ' '
      #  ⚪ ⚫ ' ' ' ⚪ '
      #  ⚪ ⚫ ⚫ ⚫ ' ⚪ ⚫
      #  ⚫ ⚫ ⚪ ⚫ ⚪ ⚪ ⚪
      # Cyan: ⚫ | Blue: ⚪ | Empty: '

      it 'returns true' do
        end_game.board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [cyan_disk, nil, nil, nil, nil, nil, nil],
          [blue_disk, cyan_disk, nil, nil, nil, blue_disk, nil],
          [blue_disk, cyan_disk, cyan_disk, cyan_disk, nil, blue_disk, cyan_disk],
          [cyan_disk, cyan_disk, blue_disk, cyan_disk, blue_disk, blue_disk, blue_disk]
        ]
        result = end_game.game_over?
        expect(result).to be true
      end
    end

    context 'when a reverse diagonal line is formed' do
      # Board sample:
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' ⚫
      #  ' ' ' ' ⚪ ⚫ ⚪
      #  ' ⚫ ' ⚫ ⚫ ⚪ ⚫
      #  ' ⚫ ⚪ ⚫ ⚪ ⚪ ⚪
      # Cyan: ⚫ | Blue: ⚪ | Empty: '

      it 'returns true' do
        end_game.board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, cyan_disk],
          [nil, nil, nil, nil, blue_disk, cyan_disk, blue_disk],
          [nil, cyan_disk, nil, cyan_disk, cyan_disk, blue_disk, cyan_disk],
          [nil, cyan_disk, blue_disk, cyan_disk, blue_disk, blue_disk, blue_disk]
        ]
        result = end_game.game_over?
        expect(result).to be true
      end
    end

    context 'when no line is formed' do
      # Board sample:
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ' ' '
      #  ' ' ' ' ⚪ ⚫ ⚪
      #  ' ⚫ ' ⚫ ⚫ ⚪ ⚫
      #  ⚫ ⚫ ⚪ ⚫ ⚪ ⚪ ⚪
      # Cyan: ⚫ | Blue: ⚪ | Empty: '
      it 'returns false' do
        end_game.board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, blue_disk, cyan_disk, blue_disk],
          [nil, cyan_disk, nil, cyan_disk, cyan_disk, blue_disk, cyan_disk],
          [cyan_disk, cyan_disk, blue_disk, cyan_disk, blue_disk, blue_disk, blue_disk]
        ]
        result = end_game.game_over?
        expect(result).to be false
      end
    end
  end

  describe '#draw?' do
    subject(:draw_game) { described_class.new }

    context 'when the board is full' do
      it 'returns true' do
        draw_game.board = Array.new(7) { Array.new(6, cyan_disk) }
        expect(draw_game.draw?).to be true
      end
    end

    context 'when the board isn\'t full' do
      it 'returns false' do
        draw_game.board = Array.new(7) { Array.new(6, cyan_disk) }
        draw_game.board[0][2] = nil
        expect(draw_game.draw?).to be false
      end
    end
  end

  describe '#disks' do
    subject(:game_disks) { described_class.new }

    context 'when space is empty' do
      it 'returns a empty disk' do
        expect(game_disks.disks(nil)).to eq('⚪')
      end
    end

    context 'when space contains a disk' do
      it 'returns the same disk' do
        expect(game_disks.disks('⚫')).to eq('⚫')
      end
    end
  end
end
