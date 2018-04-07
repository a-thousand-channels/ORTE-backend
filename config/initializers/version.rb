if Rails.env.production? || Rails.env.staging?
  DEPLOY_REVISION =  File.read(File.join(Rails.root, 'REVISION'))[0..7]
  DEPLOY_DATE = File.new(File.join(Rails.root, 'REVISION')).ctime
else
  DEPLOY_REVISION = "local"
  DEPLOY_DATE = DateTime.now
end
