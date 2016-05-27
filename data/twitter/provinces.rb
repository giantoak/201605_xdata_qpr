require 'csv'

require 'georuby'
require 'geo_ruby/ewk'        # EWKT/EWKB
require 'geo_ruby/shp'        # Shapefile
require 'geo_ruby/gpx'        # GPX data
require 'geo_ruby/kml'        # KML data
require 'geo_ruby/georss'     # GeoRSS
require 'geo_ruby/geojson'    # GeoJSON

class Province

	def initialize( filename )

		@polygons = {}

		factory = GeoRuby::SimpleFeatures::GeometryFactory::new 
		ewkt_parser = GeoRuby::SimpleFeatures::EWKTParser::new(factory) 
		
		# ewkt_parser.parse(<EWKT String>) 
		# geometry = @factory.geometry

		count = 0
			
		CSV.foreach( filename ) do | row |
			unless count == 0
				province = "#{row[1]}, #{row[9]}"
				polygon = GeoRuby::SimpleFeatures::Polygon.from_ewkt( row[0] )
				print "polygon is null\n" if polygon.nil?
				@polygons[ province ] = polygon
				# print "province: #{province} loaded...\n"
			end
			count = count + 1
		end

		print "#{@polygons.length} polygons loaded.\n"

	end


	def intersects( bounding_box )
		
		@polygons.each do | province, polygon |
			if polygon.intersects?( bounding_box )
				return province
			end
		end		
	
		return ''

	end


	def contains( point )

		@polygons.each do | province, polygon |

			# print "poly #{polygon}\n"

			if polygon.instance_of?( GeoRuby::SimpleFeatures::Polygon )
				if polygon.contains_point?( point )
					return province
				end
			elsif polygon.instance_of?( GeoRuby::SimpleFeatures::MultiPolygon )
				polygon.geometries.each do |geo|
					if geo.contains_point?( point )
						return province
					end
				end
			end
		
		end

		return ''

	end

end


# province = Province.new('provinces.csv')
