class LicenseEntry
  attr_reader :footer_text, :license, :title, :type, :source_url
  attr_writer :source_url

  def initialize(hash)
    @footer_text = hash["FooterText"] || ""
    @license = hash["License"] || ""
    @title = hash["Title"] || ""
    @type = hash["Type"] || ""
  end

  def is_valid
    !title.empty? && !license.empty?
  end

  def is_accepted
    ADLicenseLint::Constant::ACCEPTED_LICENSES.include?(license)
  end

  def copyright
    (/Copyright(.*)$/.match footer_text)[0]
  end
end