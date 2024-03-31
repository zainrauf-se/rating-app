# Load the environment

require_relative '../config/environment'
require 'builder'

# Fetch all feedbacks from the database
feedbacks = Feedback.all

# Generate XML
xml_data = Builder::XmlMarkup.new(indent: 2)
xml_data.instruct!

xml_data.feedbacks do
  feedbacks.each do |feedback|
    xml_data.feedback do
      xml_data.owner_login feedback.post.author_login
      xml_data.comment feedback.comment
      xml_data.rating feedback.post.ratings.values || ''
      xml_data.feedback_type feedback.post.title
    end
  end
end

# Write XML data to file
File.open('feedbacks.xml', 'w') { |file| file.write(xml_data.target!) }
