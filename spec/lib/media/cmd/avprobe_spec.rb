require 'spec_helper'

module Media
  class Cmd
    describe Avprobe do

      describe 'class methods' do
        let(:subexec_options) { MESS::AVPROBE_SUBEXEC_OPTIONS }
        subject { described_class }

        describe '#subexec_options' do
          it('works') { subject.subexec_options.should == subexec_options }
        end
      end

      let(:input) { 'in put.flv' }
      subject { described_class.new(input) }

      describe '#to_s' do
        it('works') { subject.to_s.should == "#{MESS::AVPROBE_PRE_COMMAND} in\\ put.flv" }
      end

      describe 'run' do
        it 'returns a Subexec instance' do
          subject.run.should be_an_instance_of Subexec
        end
        it 'sets #subexec to the same object returned by the method' do
          subject.run.should be subject.subexec
        end
        it 'sets the correct #subexec sh vars' do
          subject.run.sh_vars.should == MESS::AVPROBE_SUBEXEC_SH_VARS
        end
        it 'sets the correct #subexec timeout' do
          subject.run.timeout.should == MESS::AVPROBE_SUBEXEC_TIMEOUT
        end
        it 'sets #exitstatus equal to subexec exitstatus' do
          subject.run.exitstatus.should be subject.exitstatus
        end
        context 'with a valid video' do
          let(:input) { MESS::VALID_VIDEO }
          it 'sets exitstatus equal to 0' do
            subject.run.exitstatus.should be 0
          end
        end
        context 'with an invalid video' do
          let(:input) { MESS::INVALID_VIDEO }
          it 'sets exitstatus greater than 0' do
            subject.run.exitstatus.should be > 0
          end
        end
      end
    end
  end
end
