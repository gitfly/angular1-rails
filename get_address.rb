require 'net/http'

def get_address
  areas = JSON.parse(File.read('areas.json'))
  provinces = areas['province']
  cities = areas['city']

  provinces.each do |pro|
    province = Province.create!(name: pro['text'])

    get_by_id(pro['id']).each do |c|
      puts c

      city = province.cities.create!(name: c.first)

      get_by_id(c.last).each do |d|
        puts d
        city.districts.create!(name: d.first)
      end

    end
  end
end

def get_by_id(id)
  JSON.parse(
    Net::HTTP.get(
      URI.parse("http://baozheng.com:3000/china_city/#{id}")
    )
  )
end

def format_data
  City.where(name: "县").each do |city|
    c = city.province.cities.first
    city.districts.update_all(city_id: c.id)
    city.destroy
  end
end

def change_city
  City.where(name: "市辖区").each do |city|
    city.update_attributes!(name: city.province.name)
  end
end

def remove_districts
  District.where(name: "市辖区").destroy_all
end
