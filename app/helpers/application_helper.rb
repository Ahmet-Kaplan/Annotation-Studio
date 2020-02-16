module ApplicationHelper

  include DeviseMailerUrlHelper

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end
    nil
  end

  def render_brand
    if ENV['BRAND_RIBBON'] && ENV['BRAND_RIBBON'] != ""
      render partial: ENV['BRAND_RIBBON']
    else
      render partial: "shared/default_brand"
    end
  end

  def home_banner
    if ENV['HOME_BANNER'] && ENV['HOME_BANNER'] != ""
      return ENV['HOME_BANNER']
    else
      return "home.png"
    end
  end

  def render_footer
    if ENV['FOOTER'] && ENV['FOOTER'] != ""
      render partial: ENV['FOOTER']
    else
      render partial: "shared/default_footer"
    end
  end

  def self_removing(notice)
    # This is a hack to get the devise messages to disappear on their own after a little while. If it is a normal
    # devise message, then we add a class.
    if notice == t("devise.sessions.signed_in") || notice == t("devise.sessions.signed_out")
      return "self_removing"
    end
      return ""
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.env["HTTP_USER_AGENT"] =~ /Mobile|webOS/
    end
    false
  end




  #group role checking
  #lots of repetition -> how to simplify???

  def is_owner(group_id)
    group = Group.find(group_id)
    return group.nil? ? false : group.owner_id == current_user.id
    
  end


  def is_manager(group_id)
    if Group.find(group_id)
        relation = Membership.find_by(group_id: group_id, user_id: current_user.id)
        return !relation.nil? && relation.role == 'manager'
    end
      false #if group is not found. 
  end

  def is_member(group_id)
    if !Group.find(group_id).nil?
        relation = Membership.find_by(group_id: group_id, user_id: current_user.id)
        return !relation.nil? && relation.role == 'member'
    end
      false #if group is not found. 
  end

  def in_group(group_id)
      !Membership.find_by(group_id: group_id, user_id: current_user.id).nil? 
  end

  #get all docs shared with current_user's groups
  def getSharedDocs()
    joined = current_user.groups.pluck(:id)
    docIDs = DocumentsGroup.where(group_id: joined).pluck(:document_id).uniq
    shared = Document.where(id: docIDs).where.not(state: "draft")
    # shared = Document.where.not(state: "draft").includes(:groups).where('groups.id': joined).references(:groups)
    return shared
  end

  #validate url for document source
  def validUrl?(url)
    #source: https://stackoverflow.com/questions/3809401/
    #and https://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149
    re =/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
    url =~ re ? true : false 
  end

  # convert tags into groups
  def tagsToGroups
    tags = Tag.where('name != ?','public').order('id ASC')
    # loop through all tags
    tags.each do |t|
      # find first instance of tag where taggable type is user in taggings table
      ownerTagging = Tagging.where({tag_id: t.id, taggable_type:'User'}).order('created_at ASC').first
      if !ownerTagging.nil?
        # get remaining members' taggings
        membersTaggings = Tagging.where({tag_id: t.id, taggable_type:'User'})
        # find tagged docs' taggings
        docsTaggings = Tagging.where({tag_id: t.id, taggable_type:'Document'})
        # find owner user
        owner = User.find(ownerTagging.taggable_id)

        # create new group w/ owner, add user to group, and save
        group = Group.new({name: t.name, owner_id: owner.id}) 
        group.users << owner
        if group.save
          # Update owner's membership role to owner
          Membership.find_by(group_id: group.id, user_id: owner.id).update_attribute("role", "owner")
          membersTaggings.each do |memberTagging|
            # find other member
            member = User.find(memberTagging.taggable_id)
            if !group.users.include? member
              # create membership
              group.users << member
              group.save
            end
          end #membersTaggings.each
          docsTaggings.each do |docTagging|
            # find actual tagged doc
            doc = Document.find(docTagging.taggable_id)
            if !doc.groups.include? group
              # create DocumentsGroup
              doc.groups << group
              doc.save
            end
          end #docsTaggings.each
        else
          flash[:alert] = "Error in creating group."
        end #if group.save
      else
        flash[:alert] = "Error: no user tagged with group id = " + t.id.to_s + " and name = " + t.name
      end #if ownerTagging.nil?
    end #tags.each
  end #tagsToGroups
end