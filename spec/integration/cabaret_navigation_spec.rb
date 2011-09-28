require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret' do

  it 'should reflect the actual web site structure' do
    home = Cabaret::HomePage.new
    home.parties.each do |party|
      puts "Party: #{party.name} [nice: #{party.nice?}]"
    end
  end

end

