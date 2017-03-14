module ComplianceHelper
  def compliance_class(percent)
    case percent
    when 0...0.6 then 'text-danger'
    when 0.6...0.8 then 'text-warning'
    when 0.8..1.0 then 'text-success'
    end
  end

  def compliant_class(success)
    success ? 'compliance-ok' : 'compliance-bad'
  end

  def display_compliance(compliance)
    compliance ? number_with_precision(compliance * 100, precision: 1, strip_insignificant_zeros: true) : 'n/a'
  end
end
