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

  def smart_date_display_with_qualifier(startdate, enddate, startdate_qualifier = '', enddate_qualifier = '')
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
            startdate.strftime('%-d.%-m.%y').to_s
          end
        else
          startdate.strftime('%-d.%-m.%y, %H:%M').to_s
        end
      end
    elsif startdate > enddate
      startdate.strftime('%-d.%-m.%y, %H:%M').to_s
    elsif startdate == enddate
      if startdate.strftime('%H:%M') == '00:00'
        startdate.strftime('%-d.%-m.%y').to_s
      else
        startdate.strftime('%-d.%-m.%y, %H:%M').to_s
      end
    elsif startdate.to_date == enddate.to_date
      "#{startdate.strftime('%-d.%-m.%y, %H:%M')} ‒ #{enddate.strftime('%H:%M')}"
    else
      if startdate_qualifier == 'circa'
        if enddate_qualifier == 'circa'
          if (startdate.strftime('%Y').to_i % 10).zero? && (enddate.strftime('%Y').to_i % 10).zero?
            if (enddate.strftime('%Y').to_i - startdate.strftime('%Y').to_i) < 10
              # Ca. 1980s ‒ 2020s
              "ca. #{startdate.strftime('%Y')}s ‒ #{enddate.strftime('%Y')}s"
            elsif (enddate.strftime('%Y').to_i - startdate.strftime('%Y').to_i) == 10
              # Ca. 1980s
              "in the #{startdate.strftime('%Y')}s"
            else
              # Ca. 1980s
              "from #{startdate.strftime('%Y')}s to #{enddate.strftime('%Y')}s"
            end
          else
            "ca. #{startdate.strftime('%Y')} ‒ #{enddate.strftime('%Y')}"
          end
        elsif enddate_qualifier == 'exact'
          # (~ Ca. 2010 ‒ 15.10.2024)
          "ca. #{startdate.strftime('%Y')} ‒ #{enddate.strftime('%-d.%-m.%Y')}"
          # return date with no leading zero

        else
          if enddate.strftime('%d.%m') == '01.01'
            # (~ ca. 2010 ‒ 2024)
            "ca. #{startdate.strftime('%Y')} ‒ #{enddate.strftime('%Y')}"
          else
            # (~ Ca. 2010 ‒ 15.10.2024)
            "ca. #{startdate.strftime('%Y')} ‒ #{enddate.strftime('%-d.%-m.%Y')}"
          end
        end
      elsif enddate_qualifier == 'circa'
        if startdate_qualifier == 'exact'
          # ~ 15.6.2000 ‒ ca. 2008
          "#{startdate.strftime('%-d.%-m.%Y')} ‒ ca. #{enddate.strftime('%Y')}"
        else
          if startdate.strftime('%d.%m') == '01.01'
            if (enddate.strftime('%Y').to_i % 10).zero?
              # ~ from 1992 to 2000s
              "from #{startdate.strftime('%Y')} to #{enddate.strftime('%Y')}s"
            else
              # ~ from 1992 to ca. 2008
              "from #{startdate.strftime('%Y')} to ca. #{enddate.strftime('%Y')}"
            end
          end
        end

      else
        if startdate.strftime('%H:%M') == '00:00'
          if startdate.strftime('%d.%m') == '01.01' && enddate.strftime('%d.%m') == '01.01'
            "#{startdate.strftime('%Y')} ‒ #{enddate.strftime('%Y')}"
          elsif (startdate.strftime('%d.%m') == '01.01' && enddate.strftime('%d.%m') == '31.12') && (startdate.strftime('%Y') == enddate.strftime('%Y'))
            startdate.strftime('%Y').to_s
          else
            "#{startdate.strftime('%-d.%-m.%y')} ‒ #{enddate.strftime('%-d.%-m.%y')}"
          end
        else
          "#{startdate.strftime('%-d.%-m.%y, %H:%M')} ‒ #{enddate.strftime('%-d.%-m.%y, %H:%M')}"
        end
      end
    end
  end
end
