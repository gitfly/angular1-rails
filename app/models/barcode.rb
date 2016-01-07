require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/ascii_outputter'
require 'barby/outputter/html_outputter'
require 'barby/outputter/png_outputter'

class Barcode < ActiveRecord::Base
  include Barcodable

  def self.generate_barcodes(count)
  	barcodes = []
    count.times do
      barcodes << create!
    end
    barcodes
  end

  def thumb_barcode_url
    barcode.url(:thumb)
  end
end
