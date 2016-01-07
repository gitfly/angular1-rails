class Encryption
  def self.encode(str)
    ::Hashids.new(Settings.hashids_salt).encode str
  end

  def self.decode(str)
    ::Hashids.new(Settings.hashids_salt).decode str
  end

end
