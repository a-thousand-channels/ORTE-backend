# frozen_string_literal: true

module ApplicationHelper

  def after_sign_in_path_for(resource)
    maps_path
  end


  def admin?
    current_user&.admin?
  end

  def smart_date_display(startdate,enddate)
    if !enddate
      "#{I18n.l(startdate, format: '%A')[0..1]} #{startdate.strftime("%d.%m.%y, %H:%M")}"
    elsif startdate > enddate
      "#{I18n.l(startdate, format: '%A')[0..1]} #{startdate.strftime("%d.%m.%y, %H:%M")}"
    elsif  startdate == enddate
      "#{I18n.l(startdate, format: '%A')[0..1]} #{startdate.strftime("%d.%m.%y, %H:%M")}"
    elsif startdate.to_date == enddate.to_date
      "#{I18n.l(startdate, format: '%A')[0..1]} #{startdate.strftime("%d.%m.%y, %H:%M")} ‒ #{enddate.strftime("%H:%M")}"
    else
      "#{I18n.l(startdate, format: '%A')[0..1]} #{startdate.strftime("%d.%m.%y, %H:%M")} ‒ #{I18n.l(enddate, format: '%A')[0..1]} #{enddate.strftime("%d.%m.%y, %H:%M")}"
    end

  end
end
