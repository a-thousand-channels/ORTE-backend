require 'action_view'


class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include ActionView::Helpers::SanitizeHelper

  def start!(*)
    respond_with :message, text: t('.content')
  end

  def help!(*)
    respond_with :message, text: t('.content')
  end

  def settings!(*)
    respond_with :message, text: t('.content',  map_id: session[:map_id],  layer_id: session[:layer_id],  place_id: session[:place_id])
  end



  def choose_map!(*)
    @maps = Map.sorted.by_user(current_user).published
    mapper = []
    @maps.each do |map|
      mapper.push [{text: map.title, callback_data: "/maps/#{map.id}"}]
    end
    save_context :select_map
    respond_with :message, text: t('.select'), reply_markup: {
      inline_keyboard: mapper
    }
  end

  def choose_layer!(*)
    return unless session[:map_id]
    @map = Map.sorted.by_user(current_user).friendly.find(session[:map_id])
    @layers = @map.layers
    layer_array = []
    @layers.each do |lay|
      layer_array.push [{text: lay.title, callback_data: "/layer/#{lay.id}"}]
    end
    respond_with :message, text: t('.select'), reply_markup: {
      inline_keyboard: layer_array
    }
  end

  def choose_place!(*)
    
    return unless session[:layer_id]
    @layer = Layer.friendly.find(session[:layer_id])
    @map = @layer.map
    @places = @layer.places.published
    places_array = []
    @places.each do |p|
      places_array.push [{text: p.title, callback_data: "/place/#{p.id}"}]
    end
    respond_with :message, text: t('.select'), reply_markup: {
      inline_keyboard: places_array
    }
  end

  def callback_query(data)
    if data.include? 'map'
      session[:map_id] = data.gsub(/[^0-9]/, '').to_i
      respond_with :message, text: t('.map_selected', map_id: session[:map_id]), show_alert: true
    elsif data.include? 'layer'
      session[:layer_id] = data.gsub(/[^0-9]/, '').to_i
      respond_with :message, text: t('.layer_selected', layer_id: session[:layer_id]), show_alert: true
    elsif data.include? 'place'
      session[:place_id] = data.gsub(/[^0-9]/, '').to_i
      place = Place.published.find(session[:place_id])
      respond_with :message, text: t('.place_selected', place_id: session[:place_id], title: place.title, description: place.text, lon: place.lon, lat: place.lat), show_alert: true
    else
      answer_callback_query t('.nothing_found')
    end
  end

  def list!(*)
    return unless session[:place_id]
    @place = Place.published.find(session[:place_id])
    @annotations = @place.annotations.order(created_at: :desc).limit(10)
    annotations_array = []
    @annotations.each do |a|
      respond_with :message, text: t('.annotation', title: a.title, text: strip_tags(a.text), date: a.updated_at), parse_mode: 'HTML'
    end
  end

  def add!(*args)
    return unless session[:place_id]
    @place = Place.published.find(session[:place_id])
    if args.any?
      @annotation = Annotation.new(place_id: @place.id, text: args.join(' '))
      puts @annotation.inspect
      if @annotation.save
        session[:annotation] = @annotation.id
        respond_with :message, text: t('.saved')
      else
        respond_with :message, text: t('.not_saved')
      end
    else
      respond_with :message, text: t('.prompt')
      save_context :add!
    end
  end

  def location!(*)
    send_location
  end

  def memo!(*args)
    if args.any?
      session[:memo] = args.join(' ')
      respond_with :message, text: t('.notice')
    else
      respond_with :message, text: t('.prompt')
      save_context :memo!
    end
  end

  def remind_me!(*)
    to_remind = session.delete(:memo)
    reply = to_remind || t('.nothing')
    respond_with :message, text: reply
  end

  def keyboard!(value = nil, *)
    if value
      respond_with :message, text: t('.selected', value: value)
    else
      save_context :keyboard!
      respond_with :message, text: t('.prompt'), reply_markup: {
        keyboard: [t('.buttons')],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true,
      }
    end
  end

  def inline_keyboard!(*)
    respond_with :message, text: t('.prompt'), reply_markup: {
      inline_keyboard: [
        [
          {text: t('.alert'), callback_data: 'alert'},
          {text: t('.no_alert'), callback_data: 'no_alert'},
        ],
        [{text: t('.repo'), url: 'https://github.com/telegram-bot-rb/telegram-bot'}],
      ],
    }
  end
  
  def inline_query(query, _offset)
    query = query.first(10) # it's just an example, don't use large queries.
    t_description = t('.description')
    t_content = t('.content')
    results = Array.new(5) do |i|
      {
        type: :article,
        title: "#{query}-#{i}",
        id: "#{query}-#{i}",
        description: "#{t_description} #{i}",
        input_message_content: {
          message_text: "#{t_content} #{i}",
        },
      }
    end
    answer_inline_query results
  end

  # As there is no chat id in such requests, we can not respond instantly.
  # So we just save the result_id, and it's available then with `/last_chosen_inline_result`.
  def chosen_inline_result(result_id, _query)
    session[:last_chosen_inline_result] = result_id
  end

  def last_chosen_inline_result!(*)
    result_id = session[:last_chosen_inline_result]
    if result_id
      respond_with :message, text: t('.selected', result_id: result_id)
    else
      respond_with :message, text: t('.prompt')
    end
  end

  def message(message)
    respond_with :message, text: t('.content', text: message['text'])
  end

  def action_missing(action, *_args)
    if action_type == :command
      respond_with :message,
        text: t('telegram_webhooks.action_missing.command', command: action_options[:command])
    end
  end

  def current_user
    @current_user ||= User.find(1)
  end
end