require 'spec_helper'

describe ReverbRecords::API do
  include Rack::Test::Methods

  def app
    ReverbRecords::API
  end

  context "records" do

    # Load a test.csv so we've got something to query...
    before(:each) do
      FileUtils.cp("spec/support/testdata.csv", "db/test.csv")
    end

    # ...and remove it again to keep our tests fresh.
    after(:all) do
      File.delete("db/test.csv") if File.file?('db/test.csv')
    end

    shared_examples "valid endpoint" do |endpoint|
      it "returns valid json" do
        get "/api/#{endpoint}"
        expect{ JSON.parse(last_response.body) }.not_to raise_error
      end

      it 'has the correct header' do
        get "/api/#{endpoint}"
        expect(last_response.headers['Content-Type']).to eq('application/json')
      end
    end

    describe ".name" do
      it_behaves_like "valid endpoint", "records/name"
    end # .name

    describe ".gender" do
      it_behaves_like "valid endpoint", "records/gender"
    end # .gender

    describe ".birthdate" do
      it_behaves_like "valid endpoint", "records/birthdate"
    end # .birthday

    describe ".post" do

      context "with a valid string" do

        it "returns status 201" do
          post "/api/records", {record: "LastName | FirstName | Gender | FavoriteColor | DateOfBirth" }
          expect(last_response.status).to eq(201)
        end

        it 'returns a success message' do
          post "/api/records", {record: "LastName | FirstName | Gender | FavoriteColor | DateOfBirth" }
          expect(JSON.parse(last_response.body)['success']).to be true
        end

        it "inserts a valid string into the database" do
          expect{ 
            post "/api/records", {record: "LastName | FirstName | Gender | FavoriteColor | DateOfBirth" }
          }.to change {
            CSV.read("db/test.csv").length  
          }.by(1)
        end

      end # context valid
      
      context "with an invalid string" do

        it "rejects an invalid string" do
          post "/api/records", 'record' => 'nothing to parse here'
          expect(last_response.status).to eq(400)
        end

        it "returns an error message" do
          post "/api/records", 'record' => 'nothing to parse here'
          expect(last_response.body).to eql({error: "record is invalid"}.to_json)

        end
      end # context invalid

    end # describe post
      
  end # context records

end