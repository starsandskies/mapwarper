CONFIG_PATH="#{Rails.root}/config/application.yml"

APP_CONFIG = YAML.load_file(CONFIG_PATH)[Rails.env]

#
# Overide APP_CONFIG values from the environment. For example
# MW_SITE_NAME=New Name
# will overide APP_CONFIG['site_name']
#
ENV.each do |key, value|
  APP_CONFIG[Regexp.last_match(1).downcase] = value if key =~ /^MW_(.*)$/
end


#directories for maps and layer/mosaic tileindex shapefiles
DST_MAPS_DIR = APP_CONFIG['dst_maps_dir'].blank? ? File.join(Rails.root, '/public/mapimages/dst/') : APP_CONFIG['dst_maps_dir']
SRC_MAPS_DIR = APP_CONFIG['src_maps_dir'].blank? ? File.join(Rails.root, '/public/mapimages/src/') : APP_CONFIG['src_maps_dir']
TILEINDEX_DIR = APP_CONFIG['tileindex_dir'].blank? ? File.join(Rails.root, '/db/maptileindex') : APP_CONFIG['tileindex_dir']
MAP_MASK_DIR =  APP_CONFIG['map_mask_dir'].blank? ? File.join(Rails.root, '/public/mapimages/') : APP_CONFIG['map_mask_dir'] 

#if gdal is not on the normal path
GDAL_PATH = APP_CONFIG['gdal_path'] || ""

#
# Uncomment and populate the config file if you want to enable:
# MAX_DIMENSION = will reduce the dimensions of the image when uploaded
# MAX_ATTACHMENT_SIZE = will reject files that are bigger than this
# APP_CONFIG['gdal_memory_limit'] = limit the amount of memory available to gdal 
#
#MAX_DIMENSION = APP_CONFIG['max_dimension']
#MAX_ATTACHMENT_SIZE = APP_CONFIG['max_attachment_size']
#GDAL_MEMORY_LIMIT = APP_CONFIG['gdal_memory_limit']

Rails.application.routes.default_url_options[:host] = APP_CONFIG['host']
ActionMailer::Base.default_url_options[:host] = APP_CONFIG['host']
#ActionMailer::Base.delivery_method = :sendmail
Devise.mailer_sender = APP_CONFIG['email']

ActionMailer::Base.delivery_method = :sendgrid_actionmailer
ActionMailer::Base.sendgrid_actionmailer_settings = {
    api_key: APP_CONFIG['sendgrid_api_key'],
    raise_delivery_errors: true
}
ActionMailer::Base.raise_delivery_errors = true

