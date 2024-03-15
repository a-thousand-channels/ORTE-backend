# frozen_string_literal: true

module ApplicationHelper
  def after_sign_in_path_for(_resource)
    maps_path
  end

  def admin?
    current_user&.admin?
  end

  def basemaps
    require 'yaml'
    YAML.load_file('config/basemaps.yaml')
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
        elsif (startdate.strftime('%d.%m') == '01.01' && enddate.strftime('%d.%m') == '31.12') && (startdate.strftime('%Y') == enddate.strftime('%Y'))
          startdate.strftime('%Y').to_s
        else
          "#{startdate.strftime('%d.%m.%y')} ‒ #{enddate.strftime('%d.%m.%y')}"
        end
      else
        "#{startdate.strftime('%d.%m.%y, %H:%M')} ‒ #{enddate.strftime('%d.%m.%y, %H:%M')}"
      end
    end
  end

  def smart_date_display_with_qualifier(startdate, enddate, startdate_qualifier, enddate_qualifier)
    return unless startdate

    if !enddate
      if startdate_qualifier == 'circa'
        # Ca. 1981
        "Ca. #{startdate.strftime('%Y')}"
      else
        if startdate.strftime('%H:%M') == '00:00'
          if startdate.strftime('%d.%m') == '01.01'
            startdate.strftime('%Y').to_s
          else
            startdate.strftime('%d.%m.%y').to_s
          end
        else
          startdate.strftime('%d.%m.%y, %H:%M').to_s
        end
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
      if startdate_qualifier == 'circa'
        if enddate_qualifier == 'circa'
          if (startdate.strftime('%Y').to_i % 10).zero? && (enddate.strftime('%Y').to_i % 10).zero?
            if (startdate.strftime('%Y').to_i - enddate.strftime('%Y').to_i) < 10
              # Ca. 1980s ‒ 2020s
              "Ca. #{startdate.strftime('%Y')}s ‒ #{enddate.strftime('%Y')}s"
            else
              # Ca. 1980s
              "Ca. #{startdate.strftime('%Y')}s"
            end
          else
            "Ca. #{startdate.strftime('%Y')} ‒ #{enddate.strftime('%Y')}"
          end
        else
          "Ca. #{startdate.strftime('%Y')} ‒ #{enddate.strftime('%d.%m.%Y')}"
        end
      elsif enddate_qualifier == 'circa'
        "#{enddate.strftime('%d.%m.%Y')}  ‒ ca. #{startdate.strftime('%Y')}"
      else
        if startdate.strftime('%H:%M') == '00:00'
          if startdate.strftime('%d.%m') == '01.01' && enddate.strftime('%d.%m') == '01.01'
            "#{startdate.strftime('%Y')} ‒ #{enddate.strftime('%Y')}"
          elsif (startdate.strftime('%d.%m') == '01.01' && enddate.strftime('%d.%m') == '31.12') && (startdate.strftime('%Y') == enddate.strftime('%Y'))
            startdate.strftime('%Y').to_s
          else
            "#{startdate.strftime('%d.%m.%y')} ‒ #{enddate.strftime('%d.%m.%y')}"
          end
        else
          "#{startdate.strftime('%d.%m.%y, %H:%M')} ‒ #{enddate.strftime('%d.%m.%y, %H:%M')}"
        end
      end
    end
  end
end
