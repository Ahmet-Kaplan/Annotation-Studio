class Document < ActiveRecord::Base
  belongs_to :collection
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  acts_as_taggable_on :rep_privacy, :rep_group
  
end
