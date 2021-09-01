class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create do 
    self.host.update(host: true)
  end

  after_destroy do 
    if host.listings.count == 0
      self.host.update(host: false)
    end
  end

  def average_review_rating
    total_score = 0.0
    total_reviews = 0
    self.reviews.each do |review|
      total_score += review.rating 
      total_reviews += 1
    end
    total_score / total_reviews
  end
end
