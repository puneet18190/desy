module ImageEditorHelper
  def image_or_height(image_width,image_height)
    ratio = image_width/image_height;
    slideRatio = 1.33;
    if (ratio >= slideRatio)
      return "'width'=>'"+image_width.to_s+"'"
    else
      return "'height'=>'"+image_height.to_s+"'"
    end
  end
end