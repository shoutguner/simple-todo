class Comment < ActiveRecord::Base

  MAX_FILE_SIZE = 50.megabytes.to_i

  belongs_to :task

  mount_uploaders :attachments, AttacmentUploader

  validates :text, length: { maximum: 140 }, allow_blank: true

  validate :attachment_size

  # This validation performs after files is uploaded.
  # Stupid, but at the moment I don't see better solution
  # But it works, generally. For good users works frontend validation, for evil users may works server's limit for POST queries
  def attachment_size
    attachments.each do |attachment|
      if attachment.file.size.to_i > MAX_FILE_SIZE
        errors.add(attachment.file.original_filename, 'Attachment is too large (maximum 50 MB per file)')
      end
    end
  end

end