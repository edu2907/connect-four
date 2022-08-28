require './lib/game'

describe Game do
  describe '#next_player' do
    let(:player1) { double('Player1') }
    let(:player2) { double('Player2') }
    before do
      allow_any_instance_of(described_class).to receive(:create_players).and_return([player1, player2])
    end
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
end
