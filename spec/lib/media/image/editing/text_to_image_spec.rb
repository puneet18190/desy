# encoding: utf-8

require 'spec_helper'

module Media
  module Image
    module Editing
      describe TextToImage do

        it 'works' do

          File.foreach(Rails.root.join('fonts.txt')) do |font|

            font.strip!

            font_name = File.basename font, File.extname(font)
            instance = described_class.new("/home/mau/prove_fonts/#{font_name}.jpg", "#{font_name} àèìòùy 中华人民共和国 中華人民共和國", font: font, pointsize: 12)
            expect{ instance.tap{ |i| puts i.cmd }.run! }.to_not raise_error
            
          end

        end

      end
    end
  end
end