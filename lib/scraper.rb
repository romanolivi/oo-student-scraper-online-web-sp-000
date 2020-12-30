require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  
  #name and location: doc.css(".card-text-container").text
  #location: doc.css(".card-text-container p").text

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_cards = []
    
  
    doc.css("div.roster-cards-container").each do |project|
    project.css(".student-card a").each do |student|
    
    student_link = "#{student.attr('href')}"
    student_name = student.css('.student-name').text
    student_location = student.css('.student-location').text
     
    student_cards << {:name => student_name, :location => student_location, :profile_url => student_link}
  end
  
  end
    #return the student_cards hash
    student_cards
  end


  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map {|icon| icon.attribute('href').value}  
    
    links.each do |link|   
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")
    
    student
  end

end
