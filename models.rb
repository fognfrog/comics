%w(rubygems datamapper).each { |lib| require lib }

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:///#{Dir.pwd}/comics.db")

class Comics
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :length => 0..255
  property :twitter, String, :length => 0..255
  property :about, Text
  property :login, String, :length => 0..255
  property :password, String, :length => 0..255
  
end

class Strip
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :length => 0.255
  property :description, Text
  property :image, String, :length => 0.255
  property :created_at, DateTime
  
  def next
    Strip.first(:created_at.gt => self.created_at, :order => [:created_at.asc])
  end
  
  def previous
    Strip.first(:created_at.lt => self.created_at)
  end
  
  def get_id
    self.id
  end
  
  default_scope(:default).update(:order => [:created_at.desc])
end

def install
  DataMapper.auto_migrate!
  
  Comics.new(:title => 'Webcomic', :twitter => 'thcheetah',
              :about => 'Yet another webcomic', :login => 'admin', :password => 'admin').save!
  Strip.new(:title => 'Test Strip', :description => 'Some text here, not except <b>html</b>',
              :image => '/images/strips/1.png', :created_at => Time.now).save!
  sleep 1
  Strip.new(:title => 'Yet Another Test Strip', :description => 'Some text here, not except <b>html</b>',
              :image => '/images/strips/2.png', :created_at => Time.now).save!
end