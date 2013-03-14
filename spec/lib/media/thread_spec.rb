require 'spec_helper'

module Media
  describe Thread do

    describe '#join' do
      context 'when the thread execution raises an exception' do
        subject { described_class.new{ raise 'exception' }.join }
        it 'raises the exception in the main thread' do
          expect{ subject }.to raise_error
        end
      end
    end

    # describe '.join' do
    #   seed = Random.new_seed
    #   prng = Random.new(seed)
    #   subject do 
    #     described_class.join *100.times.map{ proc{ sleep prng.rand(0.0..5.0).tap{ |n| p n } } }
    #   end
    #   it 'works' do
    #     expect{ subject }.to_not raise_error
    #   end
    # end

  end
end
