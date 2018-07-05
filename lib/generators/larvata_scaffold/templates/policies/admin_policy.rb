class AdminPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record.class == Array ? record[1] : record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope.class == Array ? scope[1] : scope 
    end

    def resolve
      scope
    end
  end
end

