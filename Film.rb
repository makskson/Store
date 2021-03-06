require_relative 'Product'
class Film < Product
  attr_reader(:title, :year, :producer)
  attr_writer :title, :year, :producer

  def initialize(params)
    super
    @title = params[:title]
    @year = params[:year]
    @producer = params[:producer]
  end

  def to_s
    "Фильм #{@title}, #{@year}, продюссер #{@producer}, #{super}"
  end

  def update(params)
    super
    @title = params[:title] if params[:title]
    @year = params[:year] if params[:year]
    @producer = params[:producer] if params[:producer]
  end

  def self.from_file(file_path)
    lines = File.readlines(file_path, encoding: 'UTF-8').map(&:chomp)
    new(
      title: lines[0],
      producer: lines[1],
      year: lines[2].to_i,
      price: lines[3].to_i,
      amount: lines[4].to_i
    )
  end
end
