module ReverbRecords

  class API < Grape::API
    version 'v1', using: :header, vendor: 'reverb'
    format :json
    prefix :api

    # A good idea? Prevents users from seeing app errors, at least.
    rescue_from :all do |e|
      error!("There was a problem with the API.")
    end

    resource :records do
      before do
        @parser = RecordParser.new
      end

      desc 'Inserts a validated record into the database'
      params do
        requires :record, type: String, regexp: /.+(\||,).+(\||,).+(\||,).+(\||,).+/ # This is being checked in the RecordParser class.
      end
      post do
        begin
          parsed = @parser.parse(params[:record])
          @parser.insert(parsed)
        rescue ArgumentError
          error!("Your string is not in an approved format")
        end

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
