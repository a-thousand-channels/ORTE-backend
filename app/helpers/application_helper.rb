# frozen_string_literal: true

module ApplicationHelper

  def after_sign_in_path_for(resource)
    maps_path
  end


  def admin?
    current_user&.admin?
  end

  def smart_date_display(startdate,enddate)
    if !startdate
      '?'
      return
    end
    if !enddate
      "#{startdate.strftime("%d.%m.%y, %H:%M")}"
    elsif startdate > enddate
      "#{startdate.strftime("%d.%m.%y, %H:%M")}"
    elsif  startdate == enddate
      "#{startdate.strftime("%d.%m.%y, %H:%M")}"
    elsif startdate.to_date == enddate.to_date
      "#{startdate.strftime("%d.%m.%y, %H:%M")} ‒ #{enddate.strftime("%H:%M")}"
    else
      "#{startdate.strftime("%d.%m.%y, %H:%M")} ‒ #{enddate.strftime("%d.%m.%y, %H:%M")}"
    end
  end
end
