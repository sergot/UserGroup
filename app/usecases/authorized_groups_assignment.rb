class AuthorizedGroupsAssignment

  def initialize(assigner)
    @assigner = assigner
  end

  def assigns_groups(assignee, groups)
    ActiveRecord::Base.transaction do
      groups.each do |group|
        assign_group(assignee, group)
      end
    end
  end

  def assign_group(assignee, group)
    if authorized_assignment?(group) and ensure_unique_assignment(assignee, group)
      assignee.groups << group
    end
  end


  private

  def authorized_assignment?(group)
    @assigner.groups.exists?(group)
  end

  def ensure_unique_assignment(assignee, group)
    !assignee.groups.exists?(group)
  end

end