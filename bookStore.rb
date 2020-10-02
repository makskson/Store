require 'rexml/document'
require_relative 'Product'
require_relative 'Book'
require_relative 'ProductCollection'


puts Product.read_from_xml("products.xm")
