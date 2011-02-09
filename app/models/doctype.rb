class Doctype
  include MongoMapper::Document
  include MongoMapperExt::Slugizer
  include MongoMapperExt::Filter

  timestamps!

  key :_id, String
  key :_type, String
  key :name, String
  key :display_name, String
  key :doctype, String

  key :hidden, Boolean, :default => false
  key :has_video, Boolean, :default => false
  key :has_links, Boolean, :default => false

  key :create_label, String
  key :custom_icon, String

  key :group_id, String
  belongs_to :group

  has_many :items #, :dependent => :destroy

  slug_key :name, :unique => true, :min_length => 3
  key :slugs, Array, :index => true

  #validates_presence_of :group_id


  def up
    self.move_to("up")
  end

  def down
    self.move_to("down")
  end

  def move_to(pos)
    pos ||= "up"
    doctypes = group.doctypes
    current_pos = doctypes.index(self)
    if pos == "up"
      pos = current_pos-1
    elsif pos == "down"
      pos = current_pos+1
    end

    if pos >= doctypes.size
      pos = 0
    elsif pos < 0
      pos = doctypes.size-1
    end

    doctypes[current_pos], doctypes[pos] = doctypes[pos], doctypes[current_pos]
    group.doctypes = doctypes
    group.save
  end




end
