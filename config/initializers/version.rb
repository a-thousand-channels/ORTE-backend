if Rails.env.production? || Rails.env.staging?
  DEPLOY_REVISION =  File.read(File.join(Rails.root, 'REVISION'))[0..7]
  DEPLOY_DATE = File.new(File.join(Rails.root, 'REVISION')).ctime.strftime('%d.%m.%Y').to_s
else
  DEPLOY_REVISION = ""
  DEPLOY_DATE = DateTime.now
end
