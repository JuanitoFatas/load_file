RSpec.describe LoadFile::Loader do
  describe "initialize" do
    it "loads content from json file" do
      result = LoadFile::Loader.new(sample_json_path, :Sample)

      expect(result).to be_a Hash
    end

    it "loads content from yaml file" do
      result = LoadFile::Loader.new(sample_yaml_path, :Sample)

      expect(result).to be_a Hash
    end

    it "fails if specified file does not exist" do
      expect do
        LoadFile::Loader.new("not_exists.yml", :Sample)
      end.to raise_error(Errno::ENOENT)
    end
  end

  describe "set_constant" do
    after { Object.send(:remove_const, :DevEnv) }

    it "sets variables from yaml into desired constant" do
      reader = LoadFile::Loader.new(sample_yaml_path, :DevEnv)

      reader.set_constant

      expect(DevEnv["open"]["app_url"]).to eq "http://localhost:3000/yaml"
    end

    it "sets variables from json into desired constant" do
      reader = LoadFile::Loader.new(sample_json_path, :DevEnv)

      reader.set_constant

      expect(DevEnv["open"]["app_url"]).to eq "http://localhost:3000/json"
    end

    it "does not override defined variables" do
      LoadFile::Loader.new(sample_json_path, :DevEnv).set_constant

      LoadFile::Loader.new(sample_yaml_path, :DevEnv).set_constant

      expect(DevEnv["open"]["app_url"]).to eq("http://localhost:3000/json")
    end
  end

  describe "set_constant!" do
    after { Object.send(:remove_const, :DevEnv) }

    it "sets variables from yaml into desired constant" do
      reader = LoadFile::Loader.new(sample_yaml_path, :DevEnv)

      reader.set_constant!

      expect(DevEnv["open"]["app_url"]).to eq "http://localhost:3000/yaml"
    end

    it "sets variables from json into desired constant" do
      reader = LoadFile::Loader.new(sample_json_path, :DevEnv)

      reader.set_constant!

      expect(DevEnv["open"]["app_url"]).to eq "http://localhost:3000/json"
    end

    it "overrides defined variables" do
      LoadFile::Loader.new(sample_json_path, :DevEnv).set_constant

      LoadFile::Loader.new(sample_yaml_path, :DevEnv).set_constant!

      expect(DevEnv["open"]["app_url"]).to eq("http://localhost:3000/yaml")
    end
  end

  describe "existing constant" do
    before { Object.const_set :App, { "open" => "exists" } }
    after { Object.send(:remove_const, :App) }

    describe "writes" do
      it "works" do
        expect(App["open"]).to eq "exists"

        LoadFile::Loader.new(sample_yaml_path, :App).set_constant

        expect(App["open"]).to eq "exists"
      end
    end

    describe "overrides" do
      it "works" do
        expect(App["open"]).to eq "exists"

        LoadFile::Loader.new(sample_json_path, :App).set_constant!

        expect(App["open"]).to eq({ "app_url" => "http://localhost:3000/json"})
      end
    end
  end
end
