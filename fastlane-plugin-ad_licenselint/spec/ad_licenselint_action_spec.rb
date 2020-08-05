describe Fastlane::Actions::AdLicenselintAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The ad_licenselint plugin is working!")

      Fastlane::Actions::AdLicenselintAction.run(nil)
    end
  end
end
