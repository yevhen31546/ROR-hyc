class EventResource < ActiveRecord::Base
  belongs_to :event
  has_attached_file :resource

  RESOURCE_TYPES = ['url', 'comment', 'document']
  BUTTON_STYLES = {
    online_entry: "Online Entry",
    entry_form: "Entry Form",
    notice_of_race: "Notice of Race",
    sailing_instructions: "Sailing Instructions",
    entry_list: "Entry List",
    event_webpage: "Event Web Page",
    event_website: "Event Website"
  }

  validates :event_id, :occurrence, :position, :presence => true
  validates :resource_type, :inclusion => RESOURCE_TYPES
  validates :name, :presence => true, :if => lambda { |e| ['url', 'document'].include?(e.resource_type) }

  before_validation :set_position

  class << self
    def pre
      where(:occurrence => 'pre')
    end

    def post
      where(:occurrence => 'post')
    end
  end
  
  private
  def set_position
    if self.position.blank?
      self.position = (EventResource.where(:event_id => self.event_id).maximum(:position) || 0) + 1
    end
  end

end
