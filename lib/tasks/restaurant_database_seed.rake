namespace :seed do
	desc "Maintenance on production database for successful deployment"

  	task kimono_restaurants: :environment do 
  		OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development? 	
		kimono_url = 'https://www.kimonolabs.com/api/auux9lu2?apikey=baea0cea33df9ec23c38d115c5fb2480'
		
		

		output = HTTParty.get(kimono_url)
		output['results']['collection1'].each do |rest|
			begin
				blog_post_url = rest['Restaurant name']['href']
				output = search(rest['Restaurant name']['text'])

				search(rest['Restaurant name']['text'].split(/-/).first)
				output = HTTParty.get(request_url, query: {location: new_york_coordinates, radius: radius, keyword: query_text, key: api_key})
				place_id = output['results'].first['place_id']
				place_details_url = "https://maps.googleapis.com/maps/api/place/details/json"
				details_output = HTTParty.get(place_details_url, query: {key: api_key, placeid: place_id})
				formatted_address = details_output['result']['formatted_address']
				latitude = details_output['result']['geometry']['location']['lat']
				longitude = details_output['result']['geometry']['location']['lng']
				name = details_output['result']['name']			
				website_url = details_output['result']['website']
				neighborhood = details_output['result']['address_components'][2]['long_name']
			rescue Exception => e 
				byebug
				puts query_text
			end 
			Restaurant.create(name: name, neighborhood: neighborhood, formatted_address: formatted_address, blog_post_url: blog_post_url, location_latitude: latitude, location_longitude: longitude)
		end 
  	end 

  	def search(query)
  		api_key = ENV['google_places_api_key']
		new_york_coordinates = "40.71278,-74.00594"
		radius = 300000	
		request_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
  		output = HTTParty.get(request_url, query: {location: new_york_coordinates, radius: radius, keyword: query_text, key: api_key})
  	end 
	
	task google_places: :environment do
		api_key = ENV['google_places_api_key']
		new_york_coordinates = "40.71278,-74.00594"
		radius = 30000	
		request_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
		output = HTTParty.get(request_url, query: {location: new_york_coordinates, radius: radius, keyword: query_text, key: api_key})
		request_url = "http://www.espn.com"
		
		"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=#{restaurant_name}&key=#{api_key}"
		request_url = "https://maps.googleapis.com/maps/api/place/textsearch/json" 
		test = HTTParty.get(request_url, query: {query: query_text, key: api_key})
		
		"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{new_york_coordinates}&radius=20&name=#{restaurant_name}&key=#{api_key}"
	end 
end
