require "rexml/document"

class Product
  attr_reader(:price, :amount)
  def initialize(params)
    @price = params[:price]
    @amount = params[:amount]
  end

  def price
    @price
  end

  def price=(price)
    @price = price
  end

  def amount
    @amount
  end

  def amount=(amount)
    @amount = amount
  end
  def to_s
    "#{@price}$ (#{@amount} left)"
  end

  def update(params)
    @amount = params[:amount] if params[:amount]
    @price = params[:price] if params[:price]
  end

  def self.from_file(file_path)
    raise NotImplementedError
  end

  def self.read_from_xml(file_name)
    file_path = File.dirname(__FILE__ ) + '/data/' + file_name
    unless File.exist?(file_path)
      abort "Файл #{file_path} не найден"
    end
    file = File.new(file_path)
    doc = REXML::Document.new(file)
    file.close

    result = []
    product = nil
    doc.elements.each("products/product") do |product_node|
      price = product_node.attributes["price"].to_i
      amount = product_node.attributes["amount"].to_i

      product_node.each_element("book") do |book_node|
        title = book_node.attributes["title"]
        genre = book_node.attributes["genre"]
        author = book_node.attributes["author"]
        product = Book.new(price: price,
                           amount: amount,
                           title: title,
                           genre: genre,
                           author: author)
      end
      product_node.each_element("film") do |film_node|
        title = film_node.attributes["title"]
        year = film_node.attributes["year"]
        producer = film_node.attributes["producer"]
        product = Film.new(price: price,
                           amount: amount,
                           title: title,
                           year: year,
                           producer: producer)
      end
      result.push(product)
    end
    result
  end

end
############
class Book < Product
  attr_reader(:title, :genre, :author)
  def initialize(params)
    super
    @title = params[:title]
    @genre = params[:genre]
    @author = params[:author]
  end

  def to_s
    "Книга \"#{@title}\", #{@genre}, автор - #{@author}, #{super}"
  end

  def title=(title)
    @title = title
  end

  def genre=(genre)
    @genre = genre
  end

  def author=(author)
    @author = author
  end

  def update(params)
    super
    @title = params[:title] if params[:title]
    @genre = params[:genre] if params[:genre]
    @author = params[:author] if params[:author]
  end

  def self.from_file(file_path)
    lines = File.readlines(file_path, encoding: 'UTF-8').map { |l| l.chomp }
    self.new(
        title: lines[0],
        genre: lines[1],
        author: lines[2],
        price: lines[3].to_i,
        amount: lines[4].to_i
    )
  end

end
############
class Film < Product

  attr_reader(:title, :year, :producer)


  def initialize(params)
    super
    @title = params[:title]
    @year = params[:year]
    @producer = params[:producer]
  end

  def to_s
    "Фильм #{@title}, #{@year}, продюссер #{@producer}, #{super}"
  end

  def title=(title)
    @title = title
  end

  def year=(year)
    @year = year
  end

  def producer=(producer)
    @producer = producer
  end

  def update(params)
    super
    @title = params[:title] if params[:title]
    @year = params[:year] if params[:year]
    @producer = params[:producer] if params[:producer]
  end

  def self.from_file(file_path)
    lines = File.readlines(file_path, encoding: 'UTF-8').map { |l| l.chomp }
    self.new(
        title: lines[0],
        producer: lines[1],
        year: lines[2].to_i,
        price: lines[3].to_i,
        amount: lines[4].to_i
    )
  end
end
############
class ProductCollection
  PRODUCT_TYPES = {
      film: {dir: 'films', class: Film},
      book: {dir: 'books', class: Book}
  }

  def initialize(products = [])
    @products = products
  end

  def self.from_dir(dir_path)
    products = []

    PRODUCT_TYPES.each do |type, hash|
      # Получим из хэша путь к директории с файлами нужного типа, например,
      # строку 'films'
      product_dir = hash[:dir]

      # Получим из хэша объект нужного класса, например класс Film. Обратите
      # внимание, мы оперируем сейчас классом, как объектом. Передаем его по
      # ссылки и вызываем у него методы. Такова природа руби: все — объекты.
      product_class = hash[:class]

      # Для каждого текстового файла из директории, например '/data/films/'
      # берем путь к файлу и передаем его в метод класса from_file, вызывая его
      # у объекта нужного класса.
      Dir[dir_path + '/' + product_dir + '/*.txt'].each do |path|
        products << product_class.from_file(path)
      end
    end

    # Вызываем конструктор этого же класса (ProductCollection) и передаем ему
    # заполненный массив продуктов
    self.new(products)
  end

  def to_a
    @products
  end

  def sort!(params)
    case params[:by]
    when :title
      @products.sort_by! {|item| item.to_s}
    when :price
      @products.sort_by! {|item| item.price}
    when :amount
      @products.sort_by! {|item| item.amount}
    end
    @products.reverse! if params[:order] == :asc
    self
  end
end
#######################################
puts Product.read_from_xml("products.xm")

