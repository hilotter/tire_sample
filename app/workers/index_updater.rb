class IndexUpdater
  @queue = :default

  def self.perform(action_type, id)
    case action_type.to_sym
    when :update
      Topic.find(id).tire.update_index
    when :delete
      Topic.index.remove Topic.find(id)
    end
  end
end
