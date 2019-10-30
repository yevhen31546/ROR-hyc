module Admin::AdminHelper
  def object_thumbnail_tag(object, attachment_method)
    if object && object.respond_to?(attachment_method)
      if !object.send(attachment_method).exists?
        image_tag('admin/missing_icon.png', :alt => 'missing')
      elsif object.send(attachment_method).original_filename.match(/(\.gif|\.png|\.jpe?g)$/i)
        image_tag(object.send(attachment_method).url(:thumb))
      elsif object.send(attachment_method).original_filename.match(/(\.pdf)$/i)
        image_tag('admin/pdf_icon.png', :alt => 'PDF')
      elsif object.send(attachment_method).original_filename.match(/(\.docx?)$/i)
        image_tag('admin/word_icon.png', :alt => 'Word Document')
      else
        image_tag('admin/unknown_icon.png', :alt => 'not available')
      end
    else
      image_tag('admin/unknown_icon.png', :alt => 'not available')
    end
  end

  def available_layouts
    Dir.glob(Rails.root.join('app/views/layouts/[^_]*')). # list of all nonpartial files in layouts
      collect { |f| File.basename(f).gsub(/\..*$/, '') }. # remove the path and file extension(s) /home/dermot/application.html.haml -> application
      reject { |l| Page::BLACKLISTED_LAYOUTS.include?(l) } + # remove blacklisted layouts
      [['no layout']] # add option for no layout
  end

  def entry_comment_tr_class(entry)
    entry.additional_comment.present? ? 'has_comment' : nil
  end
end
