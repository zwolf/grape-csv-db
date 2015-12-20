require 'spec_helper'

describe RecordParser do

  before(:each) do
    @parser = described_class.new
    File.touch("db/test.csv") if !File.file?('db/test.csv')
  end

  after(:all) do
    File.delete("db/test.csv") if File.file?('db/test.csv')
  end

  let(:rowarray) { ["Celine","Hagbard","male","cerulean","1965-22-06"] }

  describe "input" do
    
    describe ".parse" do

      context "valid string" do

        shared_examples "parsed output" do
          it "doesn't raise an error" do
            expect {@parser.parse(record)}.not_to raise_error
          end

          it "has the correct number of fields" do
            expect(result.count).to equal(5)
          end
  
          describe 'fields match the inputs' do
            it { expect(result[0]).to eq "Celine" }
            it { expect(result[1]).to eq "Hagbard" }
            it { expect(result[2]).to eq "male" }
            it { expect(result[3]).to eq "cerulean" }
            it { expect(result[4]).to eq "1965-22-06" }
          end

          it 'result matches the standard' do
            expect(result).to eq(rowarray)
          end
        end

        describe 'parses a comma-delimited string' do
          let(:record) { "Celine, Hagbard, male, cerulean, 1965-22-06" }
          let(:result) { @parser.parse(record) }
          it_behaves_like "parsed output"
        end

        describe 'parses a pipe-delimited string' do
          let(:record) { "Celine | Hagbard | male | cerulean | 1965-22-06" }
          let(:result) { @parser.parse(record) }
          it_behaves_like "parsed output"
        end

      end # context 'valid string'

      context "invalid string" do
        let(:record) { "there's nothing to parse here" }
        it "raises an exception" do
          expect{ @parser.parse(record) }.to raise_error ArgumentError
        end
      end

    end # describe .parse

    describe '.insert' do
      it 'inserts the record into the db' do
        @parser.insert(rowarray)
        expect(CSV.read("db/test.csv").length).to eq(1)
      end
    end
  
  end # describe input

  describe 'output' do

    describe '.get_data' do
      let(:alldata) { @parser.get_data }

      it 'is an array' do
        expect(alldata).to be_a Array
      end 

    end

    describe 'sorting options' do

      describe '.by_gender_then_last' do
        answer = [
          ["Anderson", "Zoe", "female", "cerulean", "1965-22-01"], 
          ["smith", "Amanda", "female", "cerulean", "1975-22-06"], 
          ["Wilson", "Amelia", "female", "cerulean", "1985-22-09"],
          ["Brown", "Zach", "male", "cerulean", "1965-22-09"],
          ["williams", "Aaron", "male", "cerulean", "1965-22-07"]
        ]
        scrambled = answer.shuffle.shuffle # extra double shuffled
        it "orders the array by gender, then last name ascending" do
          expect(@parser.by_gender_then_last(scrambled)).to eq(answer)
        end
      end

      describe '.by_dob_asc' do
        answer = [
          ["Anderson", "Zoe", "female", "cerulean", "1965-22-01"], 
          ["williams", "Aaron", "male", "cerulean", "1965-22-07"],
          ["Brown", "Zach", "male", "cerulean", "1965-22-09"],
          ["smith", "Amanda", "female", "cerulean", "1975-22-06"], 
          ["Wilson", "Amelia", "female", "cerulean", "1985-22-09"]
        ]
        scrambled = answer.shuffle.shuffle # extra double shuffled
        it "orders the array by date of birth, ascending" do
          expect(@parser.by_dob_asc(scrambled)).to eq(answer)
        end
      end

      describe '.by_last_asc' do
        answer = [
          ["Anderson", "Zoe", "female", "cerulean", "1965-22-01"],
          ["Brown", "Zach", "male", "cerulean", "1965-22-09"],
          ["smith", "Amanda", "female", "cerulean", "1975-22-06"], 
          ["Williams", "Aaron", "male", "cerulean", "1965-22-07"],
          ["wilson", "Amelia", "female", "cerulean", "1985-22-09"]
        ]
        scrambled = answer.shuffle.shuffle # extra double shuffled
        it "orders the array by last name, ascending" do
          expect(@parser.by_last_asc(scrambled)).to eq(answer)
        end
      end

      describe '.to_output_format' do
        question = [
          ["Wilson", "Amelia", "female", "cerulean", "1985-22-09"],
          ["Williams", "Aaron", "male", "cerulean", "1965-22-07"],
          ["Smith", "Amanda", "female", "cerulean", "1975-22-06"], 
          ["Brown", "Zach", "male", "cerulean", "1965-22-09"],
          ["Anderson", "Zoe", "female", "cerulean", "1965-22-01"]
        ]
        answer = [
          { last_name: "Wilson", first_name: "Amelia", gender: "female", favorite_color: "cerulean", birthdate: "1985-22-09" }, 
          { last_name: "Williams", first_name: "Aaron", gender: "male", favorite_color: "cerulean", birthdate: "1965-22-07" },
          { last_name: "Smith", first_name: "Amanda", gender: "female", favorite_color: "cerulean", birthdate: "1975-22-06" }, 
          { last_name: "Brown", first_name: "Zach", gender: "male", favorite_color: "cerulean", birthdate: "1965-22-09" }, 
          { last_name: "Anderson", first_name: "Zoe", gender: "female", favorite_color: "cerulean", birthdate: "1965-22-01" }
        ]

        it 'maps an array of arrays to a JSON-friendly hash' do
          expect(@parser.to_output_format(question)).to eq(answer)
          expect{@parser.to_output_format(question).to_json}.not_to raise_error 
        end

      end

    end # sorting options

  end # output

end

