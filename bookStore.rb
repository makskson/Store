require 'rexml/document'
require_relative 'Product'
require_relative 'Book'
require_relative 'ProductCollection'


products = Product.read_from_xml("products.xml")
puts Product.buy_offer(products)
