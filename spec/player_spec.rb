require './lib/player'

describe Player do
  describe '#gets_color' do
    before do
      allow_any_instance_of(described_class).to receive(:gets_disk)
      allow_any_instance_of(described_class).to receive(:gets_name)
    end
    let(:valid_colors) { [:red, :blue, :yellow] }
    let(:error_msg) { 'Invalid color! The color should be one of the valid colors and cannot be a repeated color!' }
    subject(:player_color) { Player.new(valid_colors: valid_colors) }

    context 'when user inputs a valid color' do
      it 'doesn\'t display a error message' do
        valid_input = :red
        allow(player_color).to receive(:input_color).and_return(valid_input)
        expect(player_color).not_to receive(:puts).with(error_msg)
        player_color.gets_color
      end
    end

    context 'when user inputs an invalid color and then a valid color' do
      it 'displays a error message once' do
        invalid_input = :cyan
        valid_input = :red
        allow(player_color).to receive(:input_color).and_return(invalid_input, valid_input)
        expect(player_color).to receive(:puts).with(error_msg).once
        player_color.gets_color
      end
    end
  end
end
