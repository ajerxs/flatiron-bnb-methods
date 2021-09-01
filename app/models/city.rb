class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    checkin = checkin.to_date
    checkout = checkout.to_date
    available_listings = []
    self.listings.each do |listing|
      conflicts = listing.reservations.map do |reservation|
        reservation.checkin <= checkout && checkin <= reservation.checkout
      end
      if !conflicts.any?
        available_listings.push(listing)
      end
    end
    return available_listings
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_city = nil
    self.all.each do |city|
      listing_count = city.listings.count
      total_res = 0 
      city.listings.each do |listing|
        total_res += listing.reservations.count
      end

      ratio = total_res / listing_count unless listing_count == 0 || total_res == 0
      if ratio > highest_ratio
        highest_ratio = ratio
        highest_city = city
      end
    end
    highest_city
  end

  def self.most_res
    highest_res = 0
    highest_city = nil
    self.all.each do |city|
      total_res = 0
      city.listings.each do |listing|
        total_res += listing.reservations.count
      end
      
      if total_res > highest_res
        highest_res = total_res
        highest_city = city
      end
    end
    highest_city
  end

end

