module ReverbRecords

  class API < Grape::API
    version 'v1', using: :header, vendor: 'reverb'
    format :json
    prefix :api

    resource :records do
      before do
        @parser = RecordParser.new
      end

      desc 'Inserts a validated record into the database'
      params do
        requires :record, type: String, regexp: /.+(\||,).+(\||,).+(\||,).+(\||,).+/ 
      end
      post do
        parsed = @parser.parse(params[:record])
        @parser.insert(parsed)
        { success: true }
      end

      desc 'Return the data sorted by gender, then last name'
      get :gender do
        rows = @parser.by_gender_then_last(@parser.get_data)
        @parser.to_output_format(rows)
      end

      desc 'Return the data sorted by birthdate (ascending)'
      get :birthdate do
        rows = @parser.by_dob_asc(@parser.get_data)
        @parser.to_output_format(rows)
      end

      desc 'Return the data sorted by name (ascending)'
      get :name do
        rows = @parser.by_last_asc(@parser.get_data)
        @parser.to_output_format(rows)
      end

    end # resource records
  end # class API
end # module
