class ContactsController < ApplicationController

  def index
    @contacts_by_category = Contact.all.group_by(&:category)
  end

end
