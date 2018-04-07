#Record and monitor login attempts

Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  unless auth.winning_strategy.is_a?(Devise::Strategies::Rememberable)
    req = ActionDispatch::Request.new(auth.env)
    SECURITY_LOGGER.info "Login success: #{user.email} from #{req.remote_ip}"
  end
end

Warden::Manager.before_failure do |env, opts|
  if opts[:message]
    req = ActionDispatch::Request.new(env)
    SECURITY_LOGGER.info "Login failure: #{req.params[:user][:email]} from #{req.remote_ip} for #{opts[:message]}"
  end
end