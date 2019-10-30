module Admin::GalleryHelper

  def all_gallery_category_options
    get_all_with_descendants.map { |gc| get_gc_option(gc) }
  end

  def get_all_with_descendants
    GalleryCategory.top_level.order('name desc').collect do |gc|
      [gc, gc.descendants]
    end.flatten
  end

  def get_gc_option(gc)
    level = gc.ancestors.size
    [('-'*level) + ' ' + gc.name, gc.id]
  end
end