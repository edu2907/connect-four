require './lib/player'

describe Player do
  let(:disk) { '⚫'.red }
  before do
    # The returned value is important for the #insert_disk test
    allow_any_instance_of(described_class).to receive(:gets_disk).and_return(disk)
    allow_any_instance_of(described_class).to receive(:gets_name)
  end

  describe '#gets_color' do
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

  describe '#gets_column' do
    subject(:player_column) { described_class.new }
    error_msg = 'Invalid column! You should type a number between 0-7, where the number represents a column that is not full!'

    context 'when user inputs a valid number' do
      it 'doesn\'t display a error message' do
        valid_column = '4'
        allow(player_column).to receive(:input_column).and_return(valid_column)
        expect(player_column).not_to receive(:puts).with(error_msg)
        player_column.gets_column
      end
    end

    context 'when user inputs two invalid numbers and then a valid number' do
      it 'displays a error message twice' do
        invalid_column1 = '9'
        invalid_column2 = 'ab'
        invalid_column3 = '23'
        valid_column = '4'
        allow(player_column).to receive(:input_column).and_return(invalid_column1, invalid_column2, invalid_column3, valid_column)
        expect(player_column).to receive(:puts).with(error_msg).exactly(3)
        player_column.gets_column
      end
    end

    context 'when user inputs a number that points to a fullfield column and then a valid number' do
      let(:disk) { '⚫'.red }
      let(:board) do
        [
          [nil, nil, disk, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil]
        ]
      end

      let(:player_full_column) { described_class.new(board: board) }

      it 'displays a error message once' do
        fullfield_column = '2'
        valid_column = '4'
        allow(player_full_column).to receive(:input_column).and_return(fullfield_column, valid_column)
        expect(player_full_column).to receive(:puts).with(error_msg).once
        player_full_column.gets_column
      end
    end
  end

  describe '#insert_disks' do
    context 'when the choosen column (2) is empty' do
      let(:player_empty_board) { described_class.new }
      it 'should assign @disk to the bottom of the column in board' do
        allow(player_empty_board).to receive(:gets_column).and_return(2)
        expect { player_empty_board.insert_disk }.to change { player_empty_board.instance_variable_get(:@board)[5][2] }.to player_empty_board.disk
      end
    end

    context 'when the choosen column (2) already have three disks ' do
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil],
          [nil, nil, disk, nil, nil, nil, nil]
        ]
      end
      let(:player_3_disks_board) { described_class.new(board: board) }
      it 'should assign @disk to the third row  of the column in board' do
        allow(player_3_disks_board).to receive(:gets_column).and_return(2)
        expect { player_3_disks_board.insert_disk }.to change { player_3_disks_board.instance_variable_get(:@board)[2][2] }.to player_3_disks_board.disk
      end
    end
  end
end
