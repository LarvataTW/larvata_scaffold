class <%= 'Admin::' if admin? %><%= controller_class_name %>Policy < <%= admin? ? 'Admin' : 'Application' %>Policy
  def index?
    common_permission
  end

  def new?
    common_permission
  end

  def create?
    common_permission
  end

  private

  def common_permission
    user.has_role? :admin
  end
end

