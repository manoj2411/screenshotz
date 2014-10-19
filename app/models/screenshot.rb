class Screenshot < ActiveRecord::Base

  belongs_to :user
  has_attached_file :image, :styles => { :medium => "300x300>" }, :default_url => "default.jpg"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :url, presence: :true, url: true
  validates_uniqueness_of :url, scope: :user_id

  before_create :set_substitute_id


  #  ====================
  #  = Instance methods =
  #  ====================
  def update_views
    self.update_attribute :views_count, (views_count + 1)
  end

  def sid
    substitute_id
  end

  def set_substitute_id
    generate_substitute_id
    until self.class.where(substitute_id: self.substitute_id).blank?
      generate_substitute_id
    end
  end

  #  =====================
  #  = Protected methods =
  #  =====================
  protected

    def generate_substitute_id
      self.substitute_id = SecureRandom.urlsafe_base64(8).gsub('-','').gsub('_','')
    end


end

# == Schema Information
#
# Table name: screenshots
#
#  id                 :integer          not null, primary key
#  substitute_id      :string(255)
#  name               :string(255)
#  views_count        :integer          default(0)
#  url                :string(255)
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#
