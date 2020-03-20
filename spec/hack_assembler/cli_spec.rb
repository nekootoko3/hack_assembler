RSpec.describe HackAssembler::Cli do
  it "processes Add.asm" do
    input_file = File.open(File.join(File.dirname(__FILE__), "../input_files/Add.asm"))
    output_file = File.new(File.join(File.dirname(__FILE__), "../tmp_ouput_dir/Add.hack"), "w+")

    HackAssembler::Cli.start([input_file, output_file])

    correct_output_file = File.open(File.join(File.dirname(__FILE__), "../correct_output_files/Add.hack"))
    expect(FileUtils.cmp(output_file, correct_output_file)).to be_truthy
  end

  it "processes Max.asm" do
    input_file = File.open(File.join(File.dirname(__FILE__), "../input_files/Max.asm"))
    output_file = File.new(File.join(File.dirname(__FILE__), "../tmp_ouput_dir/Max.hack"), "w+")

    HackAssembler::Cli.start([input_file, output_file])

    correct_output_file = File.open(File.join(File.dirname(__FILE__), "../correct_output_files/Max.hack"))
    expect(FileUtils.cmp(output_file, correct_output_file)).to be_truthy
  end

  it "processes Rect.asm" do
    input_file = File.open(File.join(File.dirname(__FILE__), "../input_files/Rect.asm"))
    output_file = File.new(File.join(File.dirname(__FILE__), "../tmp_ouput_dir/Rect.hack"), "w+")

    HackAssembler::Cli.start([input_file, output_file])

    correct_output_file = File.open(File.join(File.dirname(__FILE__), "../correct_output_files/Rect.hack"))
    expect(FileUtils.cmp(output_file, correct_output_file)).to be_truthy
  end
end
