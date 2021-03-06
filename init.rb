require 'redmine'
require 'dispatcher' # Patches to the Redmine core.
 
Dispatcher.to_prepare :redmine_s3 do
  require_dependency 'attachment'
  unless Attachment.included_modules.include? RedmineS3::AttachmentPatch
    Attachment.send(:include, RedmineS3::AttachmentPatch)
  end

  app_dependency = Redmine::VERSION.to_a.slice(0,3).join('.') > '0.8.4' ? 'application_controller' : 'application'
  require_dependency(app_dependency)
  require_dependency 'attachments_controller'
  unless AttachmentsController.included_modules.include? RedmineS3::AttachmentsControllerPatch
    AttachmentsController.send(:include, RedmineS3::AttachmentsControllerPatch)
  end

  RedmineS3::Connection.create_bucket
end

Redmine::Plugin.register :redmine_s3_attachments do
  name 'S3'
  author 'Chris Dell'
  description 'Use Amazon S3 as a storage engine for attachments'
  version '0.0.3'
end
