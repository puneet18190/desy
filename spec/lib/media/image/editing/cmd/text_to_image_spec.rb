require 'spec_helper'


module Media
  module Image
    module Editing
      class Cmd
        describe TextToImage do
          context 'with valid arguments' do
            let(:text) do
              Tempfile.new('desy_spec').tap do |f|
                f.write("Test\ntest")
                f.close
              end
            end
            let(:output)  { Rails.root.join('tmp/test.jpg').to_s }
            let(:options) { { color: '#2EAADC', background_color: '#373737' } }

            before(:all) do
              FileUtils.rm output if File.exists? output
            end

            it 'works' do
              expect{ described_class.new(text, output, options).run! $stdout, $stderr }.to_not raise_error
            end

            after(:all) do
              text.unlink
              begin
                # FileUtils.rm output
              rescue Errno::ENOENT
              end
            end
            
          end
        end
      end
    end
  end
end