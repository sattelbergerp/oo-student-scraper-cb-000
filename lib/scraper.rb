require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
		students = []
    doc = Nokogiri::HTML(File.open("fixtures/student-site/index.html").read)
		doc.css('.student-card').each do |card|
			student = {}
			student[:profile_url]='./fixtures/student-site/'+card.css('a').attr('href')
			student[:name] = card.css('.student-name').text
			student[:location]=card.css('.student-location').text
			students << student
		end
		students
  end

  def self.scrape_profile_page(profile_url)
		student = {}
    doc = Nokogiri::HTML(File.open(profile_url).read)
		add_blog_url(student, :twitter, "twitter-icon.png", doc)
		add_blog_url(student, :linkedin, "linkedin-icon.png", doc)
		add_blog_url(student, :github, "github-icon.png", doc)
		add_blog_url(student, :blog, "rss-icon.png", doc)
		student[:bio] = doc.css('.bio-content p').text
		student[:profile_quote] = doc.css('.profile-quote').text
		student
  end

	private
	def self.add_blog_url(hash, key, img_name, doc)
		images = doc.css('.social-icon[src$="'+img_name+'"]')
		hash[key] = images[0].parent.attr('href') if images[0]!=nil
	end

end
