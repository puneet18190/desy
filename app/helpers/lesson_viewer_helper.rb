module LessonViewerHelper
  
  def is_horizontal?(width,height,kind)
    ratio = width.to_f/height.to_f
    result = case kind
    when "cover"
      ratio > 1.6
    when "image1"
      ratio > 1
    when "image2"
      ratio > 0.75
    when "image3"
      ratio > 1.55
    when "image4"
      ratio > 1.55
    end
  end
  
  def resize_width(width,height,kind)
    result = case kind
    when "cover"
      (width*560)/height
    when "image1"
      (width*420)/height
    when "image2"
      (width*550)/height
    when "image3"
      (width*550)/height
    when "image4"
      (width*265)/height
    end
  end
  
  def resize_height(width,height,kind)
    result = case kind
    when "cover"
      (height*900)/width
    when "image1"
      (height*420)/width
    when "image2"
      (height*420)/width
    when "image3"
      (height*860)/width
    when "image4"
      (height*420)/width
    end
  end
  
end
