#
# Cucumber steps dealing with checking the content of stdout/stderr.
#
streams		= %w( stdout stderr )
streams.each do |sname|
  Then(%r!^#{sname} should contain exactly (.+)$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).to eq(eval(xval))
  end
  Then(%r!^#{sname} should NOT contain exactly (.+)$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).not_to eq(eval(xval))
  end
  Then(%r!^#{sname} should contain exactly:$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).to eq(xval)
  end
  Then(%r!^#{sname} should NOT contain exactly:$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).not_to eq(xval)
  end
  Then(%r!^#{sname} should match (.*)$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).to match(Regexp.new(xval))
  end
  Then(%r!^#{sname} should match:$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).to match(Regexp.new(xval))
  end
  Then(%r!^#{sname} should NOT match (.*)$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).not_to match(Regexp.new(xval))
  end
  Then(%r!^#{sname} should NOT match:$!) do |xval|
    sval	= instance_variable_get("@#{sname}_text".to_sym)
    expect(sval).not_to match(Regexp.new(xval))
  end
end                             # streams.each do

#
# This should probably go into utility.rb -- except it explicitly
# mentions stream stuff.
#
When(%r!^I include the (\S+) module$!) do |xval|
  traffic		= capture_streams(:$stdout, :$stderr) {
    invocation		= "class #{xval}_Includer ; include #{xval} ; end"
    @return_value	= eval(invocation)
  }
  @stdout_text		= traffic[:$stdout]
  @stderr_text		= traffic[:$stderr]
  @return_value
end

