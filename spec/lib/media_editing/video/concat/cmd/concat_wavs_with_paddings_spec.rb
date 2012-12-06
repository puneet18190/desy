require 'spec_helper'

module MediaEditing
  module Video
    class Concat
      module Cmd
        describe ConcatWavsWithPaddings do
          let(:pre_command) { 'sox -V6 --buffer 131072 --multi-threaded' }

          subject { described_class.new(wavs_with_paddings, 'out put.wav') }
          
          context 'with 1 wave' do
            let(:wavs_with_paddings) { [ ['concat 0.wav', [1.234, 5.678] ] ] }
            its(:to_s) { should == "#{pre_command} concat\\ 0.wav out\\ put.wav pad 1.23 5.68" }
          end

          context 'with 2 waves' do
            let(:wavs_with_paddings) { [ ['concat 0.wav', [1.234, 5.678] ], ['concat 1.wav', [8.765, 4.321] ] ] }
            its(:to_s) { should == "#{pre_command} concat\\ 0.wav -p pad 1.23 5.68 | #{pre_command} -p concat\\ 1.wav out\\ put.wav pad 8.77 4.32" }
          end

          context 'with 3 waves' do
            let(:wavs_with_paddings) { [ ['concat 0.wav', [1.234, 5.678] ], ['concat 1.wav', [8.765, 4.321] ], ['concat 3.wav', [12.34, 56.78] ] ] }
            its(:to_s) { should == "#{pre_command} concat\\ 0.wav -p pad 1.23 5.68 | #{pre_command} -p concat\\ 1.wav -p pad 8.77 4.32 | #{pre_command} -p concat\\ 3.wav out\\ put.wav pad 12.34 56.78" }
          end

        end
      end
    end
  end
end