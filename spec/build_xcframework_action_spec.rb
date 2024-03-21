describe Fastlane::Actions::BuildXcframeworkAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The build_xcframework plugin is working!")

      Fastlane::Actions::BuildXcframeworkAction.run({})
    end
  end
end
