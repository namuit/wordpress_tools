describe WordPressTools::WPCLI do

  before do
    @original_wd = Dir.pwd
    Dir["tmp/*"].each do |dir|
      FileUtils.rm_rf(dir)
    end
    Dir.chdir('tmp')
  end

  after do
    Dir.chdir(@original_wd)
    Dir["tmp/*"].each do |dir|
      FileUtils.rm_rf(dir)
    end
  end

  let(:cli) { WordPressTools::WPCLI.new }

  context "#install_core" do

    let(:wp_cli_fixture_path) { File.expand_path('../spec/fixtures/wp-cli.phar') }
    let(:wp_cli_destination_path) { './wp-cli' }

    before do
      FakeWeb.register_uri(
        :get,
        WordPressTools::Configuration.for(:wp_cli_download_url),
        body: wp_cli_fixture_path
      )
    end

    context "overwite existing file" do
      before do
        allow(cli).to receive(:overwrite?).and_return(true)
        allow(cli).to receive(:wp_cli_path).and_return(wp_cli_destination_path)
      end

      it "downloads wp-cli" do
        cli.install_core
        expect(FileUtils.compare_file(wp_cli_fixture_path, wp_cli_destination_path)).to eq(true)
        expect(File.executable?(wp_cli_destination_path)).to eq(true)
      end
    end

    context "do not overwite existing file" do
      before do
        allow(cli).to receive(:overwrite?).and_return(false)
        allow(cli).to receive(:wp_cli_path).and_return(wp_cli_destination_path)
      end

      it "downloads wp-cli" do
        cli.install_core
        expect(File.exist?(wp_cli_destination_path)).to eq(false)
      end
    end
  end
end
