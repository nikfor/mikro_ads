require_relative '../basic_service'

module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
      option :user_id
    end

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)
      puts @ad
      puts @ad.class
      return fail!(@ad.errors) unless @ad.save

      # GeocodingJob.perform_later(@ad)
    end
  end
end
