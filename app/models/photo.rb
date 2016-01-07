class Photo < ActiveRecord::Base
  default_scope { where(front: nil).order('sequence,photo_file_name ASC') }
  belongs_to :photoable, polymorphic: true

  after_create :delete_after_photos

  # before_create :photos_count_within_bounds

  has_attached_file :photo, styles: lambda { |attachment| 
    instance = attachment.instance
    { medium: "800x600>", thumb: "100x100>" }.tap do |hash|
      style = instance.parent_id ? :after : :before
      hash.merge!(
        original: {
          auto_orient: false,
          geometry: "3264x2448>",
          watermark_path: "#{Rails.root}/public/images/watermark-#{style}.png"
        }
      )
    end
  }, 
  default_url: "/images/:style/missing.png", 
  processors: lambda { |instance| instance.processors || [:thumbnail] }

  attr_accessor :processors

  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  has_many :symptoms, :foreign_key => 'photo_id', :class_name => "PhotoSymptom"
  belongs_to :desc, :foreign_key => 'desc_id', :class_name => "PhotoDesc"

  belongs_to :parent_photo, :class_name => "Photo", :foreign_key => "parent_id"
  has_many :child_photos, :class_name => "Photo", :foreign_key => "parent_id"

  belongs_to :before, :class_name => "Photo", :foreign_key => "parent_id"
  has_one :after, :class_name => "Photo", :foreign_key => "parent_id"

  scope :all_parents, -> { where(parent_id: nil) }
  scope :all_children, -> { where("parent_id is not NULL") }
  scope :before, -> { where(parent_id: nil) }
  scope :after, -> { where("parent_id is not NULL") }
  scope :used, -> { where(used: true) }

  def order
    Order.find(photoable_id) if photoable_type == 'Order'
  end

  def thumb_url
    photo.url(:thumb)
  end

  def original_url
    photo.url(:medium)
  end

  def name
    photo_file_name
  end

  def show_size
    return 0 unless photo_file_size
    (photo_file_size/1024.0).round(2)
  end

  def push_to_wechat
    self.photo? or return false
    res = Wechat::Media.create_image(self.photo.path)
    self.media_id = res['media_id']
    self.media_url = res['url']
    self.save! and self
  end

  private

  def delete_after_photos
    parent_id and self.class.where(
      parent_id: parent_id
    ).where("id != #{id}").destroy_all
  end

  # def photos_count_within_bounds
    # return if order.try(:photos).blank?
    # errors.add("Too many photos") if order.photos.size > 30
  # end
end
