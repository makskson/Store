class Product
  attr_reader :price, :amount
  attr_writer :price, :amount

  def initialize(params)
    @price = params[:price]
    @amount = params[:amount]
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
    abort "Файл #{file_path} не найден" unless File.exist?(file_path)
    file = File.new(file_path)
    doc = REXML::Document.new(file)
    file.close

    result = []
    product = nil
    doc.elements.each('products/product') do |product_node|
      price = product_node.attributes['price'].to_i
      amount = product_node.attributes['amount'].to_i

      product_node.each_element('book') do |book_node|
        title = book_node.attributes['title']
        genre = book_node.attributes['genre']
        author = book_node.attributes['author']
        product = Book.new(price: price,
                           amount: amount,
                           title: title,
                           genre: genre,
                           author: author)
      end
      product_node.each_element('film') do |film_node|
        title = film_node.attributes['title']
        year = film_node.attributes['year']
        producer = film_node.attributes['producer']
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

  def self.buy_offer(products)
    puts 'Что бы вы хотели купить?'
    products.each do |item|
      puts "#{products.index(item)}. #{item}"
    end
    puts 'x. Выход'
    mode = STDIN.gets.chomp
  end
end
