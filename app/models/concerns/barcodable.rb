module Barcodable
  extend ActiveSupport::Concern

  included do
    after_create :generate_number
    
    has_attached_file :barcode, 
      :styles => {:thumb => "500x200>" }, 
      :default_url => "/images/:style/missing.png"
    validates_attachment :barcode, 
      :size => { :in => 0..10.kilobytes },
      :content_type => { :content_type => "image/png" }

  end

  def barcode_blob
    Barby::Code128B.new(number).to_png(xdim: 3, margin: 0)
  end

  def generate_number
    self.number = "".tap do |str|
      str << Time.now.strftime('%Y%m%d')
      str << rand(3..9).to_s
      l = id.to_s.length

      if l > 5
        str << '0'
        str << id.to_s[-5..-1]
      else
        (5 - id.to_s.length).times do
          str << rand(1..9).to_s
        end
        str << '0'
        str << id.to_s
      end
    end
    store_barcode
  end

  private

    def store_barcode
      path = "/tmp/barcode#{Time.now.to_i}#{id}.png"
      File.open(path, 'w') do |f| 
        f.write barcode_blob
      end
      File.open(path, 'r') do |f|
        self.barcode = f
        save!
      end
      FileUtils.rm_f(path)
    end

  # class_methods do
  # end
end

