require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  
  def setup
    reset_parameters
  end
  
  def reset_parameters
    @parameters = {
      :initial_video_id => 1,
      :audio_id => 4,
      :components => [
        {
          :type => 'video',
          :video_id => 2,
          :from => 12,
          :until => 20
        },
        {
          :type => 'text',
          :content => 'Titolo titolo titolo',
          :duration => 14,
          :background_color => 'red',
          :text_color => 'white'
        },
        {
          :type => 'image',
          :image_id => 6,
          :duration => 2
        }
      ]
    }
  end
  
  test 'convert_parameter_hash' do
    assert_nil Video.convert_parameters('o', 1)
    assert_nil Video.convert_parameters({}, 1)
    @parameters.delete :initial_video_id
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:initial_video_id] = nil
    assert_not_nil Video.convert_parameters(@parameters, 1)
    @parameters.delete :audio_id
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:audio_id] = nil
    assert_not_nil Video.convert_parameters(@parameters, 1)
    reset_parameters
    @parameters[:initial_video_id] = @parameters[:initial_video_id].to_s
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:initial_video_id] = @parameters[:initial_video_id].to_i
    @parameters[:audio_id] = @parameters[:audio_id].to_s
    assert_nil Video.convert_parameters(@parameters, 1)
    reset_parameters
    @parameters[:initial_video_id] = 6
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:initial_video_id] = 99
    assert_nil Video.convert_parameters(@parameters, 1)
    reset_parameters
    MediaElement.where(:id => 1).update_all(:user_id => 2)
    assert_nil Video.convert_parameters(@parameters, 1)
    MediaElement.where(:id => 1).update_all(:user_id => 1)
    @parameters[:audio_id] = 1
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:audio_id] = 99
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:audio_id] = 3
    assert_nil Video.convert_parameters(@parameters, 1)
    reset_parameters

#    provare per ogni componente un caso in cui non è accessibile, ma non il caso in cui non esiste o non è il tipo giusto
# inoltre provare per una componente sola il caso in cui non è un intero


#    # there must be a list of components
#    return nil if !hash[:components].instance_of?(Array) || !hash[:components].empty?
#    
#    # initialize empty components
#    resp_hash[:components] = []
#    
#    # for each component I validate it and add it to the HASH
#    hash[:components].each do |p|
#      return nil if !p.instance_of?(Hash) || !COMPONENTS.include?(p[:type])
#      case p[:type]
#        when VIDEO_COMPONENT
#          c = extract_video_component(p, user_id)
#          return nil if c.nil?
#          resp_hash[:components] << c
#        when TEXT_COMPONENT
#          c = extract_text_component(p)
#          return nil if c.nil?
#          resp_hash[:components] << c
#        when IMAGE_COMPONENT
#          c = extract_image_component(p, user_id)
#          return nil if c.nil?
#          resp_hash[:components] << c
#      end
#    end
#    
#    resp_hash
#  end
#  
#  def self.extract_image_component(component, user_id)
#    image = get_media_element_from_hash(component, :image_id, user_id, 'Image')
#    # I validate that the image exists and is accessible from the user
#    return nil if image.nil?
#    # DURATION is correct
#    return nil if !component[:duration].instance_of?(Integer) || component[:duration] < 1
#    {
#      :type => IMAGE_COMPONENT,
#      :image => image,
#      :duration => component[:duration]
#    }
#  end
#  
#  def self.extract_video_component(component, user_id)
#    video = get_media_element_from_hash(component, :video_id, user_id, 'Video')
#    # I validate that the video exists and is accessible from the user
#    return nil if video.nil?
#    # FROM and UNTIL are correct
#    return nil if !component[:from].instance_of?(Integer) || !component[:until].instance_of?(Integer)
#    return nil if component[:from] < 0 || component[:until] > video.min_duration || component[:from] >= component[:until]
#    {
#      :type => VIDEO_COMPONENT,
#      :video => video,
#      :from => component[:from],
#      :until => component[:until]
#    }
#  end
#  
#  def self.extract_text_component(component)
#    # CONTENT, COLORS, and DURATION are present and correct
#    return nil if !component.has_key?(:content) || !component[:duration].instance_of?(Integer) || component[:duration] < 1
#    return nil if !CONFIG['colors'].has_key?(component[:background_color]) || !CONFIG['colors'].has_key?(component[:text_color])
#    {
#      :type => TEXT_COMPONENT,
#      :content => component[:content].to_s,
#      :duration => component[:duration],
#      :background_color => component[:background_color],
#      :text_color => component[:text_color]
#    }
#  end
#  
#  def self.get_media_element_from_hash(hash, key, user_id, my_sti_type)
#    hash[key].instance_of?(Integer) ? MediaElement.extract(hash[key], user_id, my_sti_type) : nil
#  end
#  
  end
  
end
