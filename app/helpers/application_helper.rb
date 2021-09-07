# frozen_string_literal: true

module ApplicationHelper
  def after_sign_in_path_for(_resource)
    maps_path
  end

  def admin?
    current_user&.admin?
  end

  def smart_date_display(startdate, enddate)
    return unless startdate

    if !enddate
      if startdate.strftime('%H:%M') == '00:00'
        if startdate.strftime('%d.%m') == '01.01'
          startdate.strftime('%Y').to_s
        else
          startdate.strftime('%d.%m.%y').to_s
        end
      else
        startdate.strftime('%d.%m.%y, %H:%M').to_s
      end
    elsif startdate > enddate
      startdate.strftime('%d.%m.%y, %H:%M').to_s
    elsif startdate == enddate
      if startdate.strftime('%H:%M') == '00:00'
        startdate.strftime('%d.%m.%y').to_s
      else
        startdate.strftime('%d.%m.%y, %H:%M').to_s
      end
    elsif startdate.to_date == enddate.to_date
      "#{startdate.strftime('%d.%m.%y, %H:%M')} ‒ #{enddate.strftime('%H:%M')}"
    else
      if startdate.strftime('%H:%M') == '00:00'
        if startdate.strftime('%d.%m') == '01.01' && enddate.strftime('%d.%m') == '01.01'
          "#{startdate.strftime('%Y')} ‒ #{enddate.strftime('%Y')}"
        else
          "#{startdate.strftime('%d.%m.%y')} ‒ #{enddate.strftime('%d.%m.%y')}"
        end
      else
        "#{startdate.strftime('%d.%m.%y, %H:%M')} ‒ #{enddate.strftime('%d.%m.%y, %H:%M')}"
      end
    end
  end
end
