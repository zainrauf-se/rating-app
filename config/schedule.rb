# schedule the rake task

every :day, at: '9am' do
  runner '../task/generate_feedback_xml.rb'
end