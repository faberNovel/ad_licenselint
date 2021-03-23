class LicenseEntry
  attr_reader :license_content, :license_name, :pod_name, :source_url
  attr_writer :source_url

  def initialize(hash)
    @pod_name = hash["Title"] || ""
    @license_name = hash["License"] || ""
    @license_content = hash["FooterText"] || ""
  end

  def is_valid
    !pod_name.empty? && !license_name.empty?
  end

  def copyright
    (/Copyright(.*)$/.match license_content)[0]
  end

  def to_hash
    {
      pod_name: @pod_name,
      license_content: @license_content,
      license_name: @license_name,
      source_url: @source_url
    }
  end
end