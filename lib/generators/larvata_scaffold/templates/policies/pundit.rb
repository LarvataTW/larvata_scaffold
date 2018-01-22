class <%= 'Admin::' if admin? %><%= class_name %>Policy < <%= admin? ? 'Admin' : 'Application' %>Policy
  def index?
    common_permission
  end

  def new?
    common_permission
  end

  def create?
    common_permission
  end

  def show?
    common_permission
  end

  def edit?
    common_permission
  end

  def update?
    common_permission
  end

  def destroy?
    common_permission
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def common_permission
    user.has_role? :admin
  end
end

