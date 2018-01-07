class <%= 'Admin::' if admin? %><%= class_name %>Policy < <%= admin? ? 'Admin' : 'Application' %>Policy
  def index?
    user.has_role? :admin
  end

  def new?
    user.has_role? :admin
  end

  def create?
    user.has_role? :admin
  end

  def show?
    user.has_role? :admin
  end

  def edit?
    user.has_role? :admin
  end

  def update?
    user.has_role? :admin
  end

  def destroy?
    user.has_role? :admin
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

