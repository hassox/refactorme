require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'cgi'

class Snippet < ActiveRecord::Base
  acts_as_list
  
  belongs_to :user
  has_many :refactors
  
  validates_presence_of :title, :message => "can't be blank"
  validates_presence_of :code, :message => "can't be blank", :if => :gist_is_blank?
  validates_presence_of :context, :on => :create, :message => "can't be blank"
  validates_length_of :context, :minimum => 10
  
  before_save :send_to_gist

  named_scope :latest, :conditions => ["displayed_on IS NOT NULL"], :limit => 5, :order => 'created_at DESC'
  named_scope :in_date_range, lambda { |date|
    { :conditions => ["MONTH(displayed_on) = ? AND YEAR(displayed_on) = ?", date.month, date.year], 
      :order => 'displayed_on ASC' }
  }
  
  def self.set_daily_snippet
    todays = Snippet.first(:conditions => 'displayed_on IS NULL AND position IS NOT NULL', :order => 'position')
    if todays.remove_from_list
      todays.update_attribute :displayed_on, Date.today
    else
      Exception.new("Error running rake set_todays_snippet at #{Time.now}, remove_from_list returned false.")
    end
  end
  
  def approve!
    add_to_list
  end
  
  def reject!
    return self.destroy ? true : false
  end
  
  def gist_url
    "http://gist.github.com/#{self.gist_id}"
  end
  
  def gist_url=(url)
    id = url.match(/[http:\/\/gist.github.com\/]?(\d+)\/?/)
    unless id.nil?
      p id[1]
      self.gist_id = id[1]
      gist_url = "http://gist.github.com/#{gist_id}"
      doc = Nokogiri::HTML.parse(open(gist_url))
    
      raw_gist_url = "http://gist.github.com" + doc.xpath('//a[text()="raw"]').first.attributes['href'].to_s

      self.code = open(raw_gist_url).read
    end
  end
  
  def code=(code)
    write_attribute(:code, code) unless code.blank?
  end
  
  def send_to_gist
    if self.gist_id.blank?
      response = Net::HTTP.post_form(URI.parse('http://gist.github.com/api/v1/xml/new'), { "files[#{title.downcase.gsub(' ', '_')}.rb]" => "#{code}" })
      doc = Nokogiri::XML.parse(response.body)
      repo_id = doc.xpath('//repo').first.content
      write_attribute(:gist_id, repo_id)
    end
  end
  
  def display
    # Rails.cache.fetch("gist_#{self.gist_id}", :expires_in => 24.hours) do
      result = open(gist_url + ".js").read
      result.scan(/document.write\('(.*|\s*)'\)/)[1][0]
    # end
  end
  
  private
    def gist_is_blank?
      self.gist_id.blank?
    end
end
