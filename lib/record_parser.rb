require 'csv'

class RecordParser
  attr_reader :filename

  def initialize
    # Set the file based on the environment
    @filename = ENV['DB_PATH']
    # Touch the file in case #get_data is called first
    CSV.open("db/#{@filename}", 'a') {}
  end

  # Parse a line
  def parse(record)
    # Test string validity?
    if record.count(',') == 4 && record =~ /.+(\||,).+(\||,).+(\||,).+(\||,).+/ 
      delim = ','
    elsif record.count("|") == 4
      delim = '|'
    else
      # String not valid, for it is not correctly delimited
      raise ArgumentError, "String is not in a valid format"
    end
    # parse that string
    last_name, first_name, gender, favorite_color, date_of_birth = record.split(delim).map(&:strip)

  end

  def insert(row)
    # Create the file if it doesn't exist, then append to the end of it
    CSV.open("db/#{@filename}", 'a') { |csv| csv << row }
  end

  def get_data
    # Loading all the data in one fell swoop isn't scalable, but it'll work for our purposes.
    data = CSV.read("db/#{@filename}")
  end

  def by_gender_then_last(data)
    # Sort by gender (a[2]) female (ascending), then last name (a[0]), ascending
    data.sort_by {|a| [a[2].downcase,a[0].downcase] }
  end

  def by_dob_asc(data)
    # Sort by DOB (a[4]), ascending
    data.sort_by {|a| a[4].downcase}
  end

  def by_last_asc(data)
    # Sort by last (a[0]) ascending.
    data.sort_by {|a| [a[0].downcase,a[1].downcase] }
  end

  # A CSV-output-style array of arrays becomes a json-able ruby hash
  def to_output_format(data)
    records = []
    data.each do |arr|
      records << {
        last_name: arr[0],
        first_name: arr[1],
        gender: arr[2],
        favorite_color: arr[3],
        birthdate: arr[4]
      } 
    end
    records
  end

end