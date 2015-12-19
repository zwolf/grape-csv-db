require 'spec_helper'

# What follows is a series of very very very simple request specs.
# They're enough to test the majority of the Rack app
# which is probably enough for our purposes.

describe 'ReverbRecords Rack App', js: true, type: :feature do

  context 'homepage' do
    it 'displays index.html page' do
      visit '/'
      expect(title).to eq('ReverbRecords API Test')
    end
  end

  context "page that doesn't exist" do
    before :each do
      visit '/aintnopagehere'
    end

    it 'displays 404 page' do
      expect(title).to eq('Page Not Found')
    end

  end

  context 'wrong method' do
    before :each do
      visit '/api/records'
    end

    it 'displays 405 page' do
      expect(title).to eq('Method Not Allowed')
    end

  end

end
