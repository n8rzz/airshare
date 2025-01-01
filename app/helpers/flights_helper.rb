module FlightsHelper
  def flight_actions(flight)
    actions = []
    
    # View action is always available
    actions << link_to('View', flight_path(flight), class: "text-primary-600 hover:text-primary-900")
    
    if current_user&.admin? || current_user == flight.pilot
      actions << link_to('Edit', edit_flight_path(flight), class: "ml-3 text-primary-600 hover:text-primary-900")
      
      if flight.scheduled?
        actions << link_to('Cancel', flight_path(flight), 
          data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' },
          class: "ml-3 text-red-600 hover:text-red-900")
      end
    end
    
    safe_join(actions)
  end
end 