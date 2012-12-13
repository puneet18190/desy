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
    assert_not_nil Video.convert_parameters(@parameters, 1)
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
    @parameters[:components] = '[]'
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components] = []
    assert_nil Video.convert_parameters(@parameters, 1)
    reset_parameters
    @parameters[:components][0][:type] = 'viddeo'
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components][0][:type] = 'video'
    @parameters[:components][0].delete(:video_id)
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components][0][:video_id] = '3'
    assert_nil Video.convert_parameters(@parameters, 1)
    MediaElement.where(:id => 2).update_all(:user_id => 2, :is_public => false)
    @parameters[:components][0][:video_id] = 2
    assert_nil Video.convert_parameters(@parameters, 1)
    MediaElement.where(:id => 2).update_all(:user_id => 1, :is_public => true)
    reset_parameters
    @parameters[:components][0][:from] = 't'
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components][0][:until] = '1'
    assert_nil Video.convert_parameters(@parameters, 1)
    reset_parameters
    @parameters[:components][0][:until] = 12
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components][0][:until] = 11
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components][0][:until] = 22
    assert_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components][0][:until] = 21
    assert_not_nil Video.convert_parameters(@parameters, 1)
    @parameters[:components][0][:from] = -1
    assert_nil Video.convert_parameters(@parameters, 1)
    reset_parameters
    

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

#    provare per ogni componente un caso in cui non è accessibile, ma non il caso in cui non esiste o non è il tipo giusto

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


#  
#  def self.get_media_element_from_hash(hash, key, user_id, my_sti_type)
#    hash[key].instance_of?(Integer) ? MediaElement.extract(hash[key], user_id, my_sti_type) : nil
#  end
#  
  end
  
end
